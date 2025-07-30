#include "api.h"
#include "llama_cpp/include/llama.h"
#include "llama_cpp/vendor/nlohmann/json.hpp"
#include "params.hpp"
#include <cassert>
#include <vector>
#include <atomic>
#include <mutex>

static std::atomic_bool stop_generation(false);
static std::mutex continue_mutex;

static llama_model * model = nullptr;
static llama_context * ctx = nullptr;
static llama_sampler * smpl = nullptr;
static int prev_len = 0;

static std::vector<llama_chat_message> llama_parse_messages(char * messages) {
    auto json_messages = nlohmann::ordered_json::parse(messages);
    std::vector<llama_chat_message> result;

    for (auto & message : json_messages) {
        auto role = message["role"].get<std::string>();
        auto content = message["content"].get<std::string>();

        llama_chat_message msg = {
            strdup(role.c_str()),
            strdup(content.c_str())
        };

        result.push_back(msg);
    }

    return result;
}

char * llama_default_params(void) {
    nlohmann::ordered_json params = nlohmann::ordered_json::object();

    /// Model parameters
    auto default_model_params = llama_model_default_params();

    params["vocab_only"] = default_model_params.vocab_only;
    params["use_mmap"] = default_model_params.use_mmap;
    params["use_mlock"] = default_model_params.use_mlock;
    params["check_tensors"] = default_model_params.check_tensors;

    /// Context parameters
    auto default_context_params = llama_context_default_params();

    params["n_ctx"] = default_context_params.n_ctx;
    params["n_batch"] = default_context_params.n_batch;
    params["n_ubatch"] = default_context_params.n_ubatch;
    params["n_seq_max"] = default_context_params.n_seq_max;
    params["n_threads"] = default_context_params.n_threads;
    params["n_threads_batch"] = default_context_params.n_threads_batch;
    params["rope_scaling_type"] = default_context_params.rope_scaling_type;
    params["pooling_type"] = default_context_params.pooling_type;
    params["attention_type"] = default_context_params.attention_type;
    params["rope_freq_base"] = default_context_params.rope_freq_base;
    params["rope_freq_scale"] = default_context_params.rope_freq_scale;
    params["yarn_ext_factor"] = default_context_params.yarn_ext_factor;
    params["yarn_attn_factor"] = default_context_params.yarn_attn_factor;
    params["yarn_beta_fast"] = default_context_params.yarn_beta_fast;
    params["yarn_beta_slow"] = default_context_params.yarn_beta_slow;
    params["yarn_orig_ctx"] = default_context_params.yarn_orig_ctx;
    params["defrag_thold"] = default_context_params.defrag_thold;
    params["embeddings"] = default_context_params.embeddings;
    params["offload_kqv"] = default_context_params.offload_kqv;
    params["flash_attn"] = default_context_params.flash_attn;
    params["no_perf"] = default_context_params.no_perf;

    /// Sampler parameters
    params["greedy"] = true;

    return strdup(params.dump().c_str());
}

int llama_llm_init(char * params) {
    auto json_params = nlohmann::ordered_json::parse(params);

    if (!json_params.contains("model_path") || !json_params["model_path"].is_string()) {
        fprintf(stderr, "Missing 'model_path' in parameters\n");
        return 1;
    }

    auto model_path = json_params["model_path"].get<std::string>();

    auto model_params = llama_model_params_from_json(json_params);
    auto context_params = llama_context_params_from_json(json_params);

    ggml_backend_load_all();

    model = llama_model_load_from_file(model_path.c_str(), model_params);
    ctx = llama_init_from_model(model, context_params);
    smpl = llama_sampler_from_json(model, json_params);

    prev_len = 0;

    return 0;
}

int llama_prompt(char * msgs, dart_output * output) {
    auto messages = llama_parse_messages(msgs);

    std::lock_guard<std::mutex> lock(continue_mutex);
    stop_generation.store(false);

    assert(model != nullptr);
    assert(ctx != nullptr);
    assert(smpl != nullptr);

    auto vocab = llama_model_get_vocab(model);

    std::vector<char> formatted(llama_n_ctx(ctx));

    const char * tmpl = llama_model_chat_template(model, nullptr);
    int new_len = llama_chat_apply_template(tmpl, messages.data(), messages.size(), true, formatted.data(), formatted.size());
    if (new_len > (int) formatted.size()) {
        formatted.resize(new_len);
        new_len = llama_chat_apply_template(tmpl, messages.data(), messages.size(), true, formatted.data(), formatted.size());
    }

    if (new_len < 0) {
        fprintf(stderr, "failed to apply the chat template\n");
        return 1;
    }

    // remove previous messages to obtain the prompt to generate the response
    std::string prompt(formatted.begin() + prev_len, formatted.begin() + new_len);

    std::string response;

    // Get memory handle and check position
    llama_memory_t mem = llama_get_memory(ctx);
    const bool is_first = llama_memory_seq_pos_max(mem, 0) == 0;

    // tokenize the prompt
    const int n_prompt_tokens = -llama_tokenize(vocab, prompt.c_str(), prompt.size(), NULL, 0, is_first, true);
    std::vector<llama_token> prompt_tokens(n_prompt_tokens);
    if (llama_tokenize(vocab, prompt.c_str(), prompt.size(), prompt_tokens.data(), prompt_tokens.size(), is_first, true) < 0) {
        GGML_ABORT("failed to tokenize the prompt\n");
    }

    // prepare a batch for the prompt
    llama_batch batch = llama_batch_get_one(prompt_tokens.data(), prompt_tokens.size());
    llama_token new_token_id;
    while (!stop_generation.load()) {
        // check if we have enough space in the context to evaluate this batch
        int n_ctx = llama_n_ctx(ctx);
        int n_ctx_used = llama_memory_seq_pos_max(mem, 0);
        if (n_ctx_used + batch.n_tokens > n_ctx) {
            fprintf(stderr, "context size exceeded\n");
            break;
        }
        
        if (llama_decode(ctx, batch)) {
            GGML_ABORT("failed to decode\n");
        }

        // sample the next token
        new_token_id = llama_sampler_sample(smpl, ctx, -1);

        // is it an end of generation?
        if (llama_vocab_is_eog(vocab, new_token_id)) {
            break;
        }

        // convert the token to a string, print it and add it to the response
        char buf[256];
        int n = llama_token_to_piece(vocab, new_token_id, buf, sizeof(buf), 0, true);
        if (n < 0) {
            GGML_ABORT("failed to convert token to piece\n");
        }

        std::string piece(buf, n);
        output(piece.c_str());
        response += piece;

        // prepare the next batch with the sampled token
        batch = llama_batch_get_one(&new_token_id, 1);
    }

    // add the response to the messages
    messages.push_back({"assistant", strdup(response.c_str())});
    prev_len = llama_chat_apply_template(tmpl, messages.data(), messages.size(), false, nullptr, 0);
    if (prev_len < 0) {
        fprintf(stderr, "failed to apply the chat template\n");
        return 1;
    }
    
    output(nullptr);
    return 0;
}

void llama_llm_stop(void) {
    stop_generation.store(true);
}

void llama_llm_free(void) {
    llama_sampler_free(smpl);
    llama_free(ctx);
    llama_model_free(model);
}