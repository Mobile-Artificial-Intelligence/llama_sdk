#include "api.h"
#include "llama.h"
#include "json.hpp"
#include <cassert>
#include <vector>
#include <atomic>
#include <mutex>

using json = nlohmann::ordered_json;

static std::atomic_bool stop_generation(false);
static std::mutex continue_mutex;

static llama_model * model = nullptr;
static llama_context * ctx = nullptr;
static llama_sampler * smpl = nullptr;
static int prev_len = 0;

char * llama_default_params(void) {
    json params = json::object();

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
    params["logits_all"] = default_context_params.logits_all;
    params["embeddings"] = default_context_params.embeddings;
    params["offload_kqv"] = default_context_params.offload_kqv;
    params["flash_attn"] = default_context_params.flash_attn;
    params["no_perf"] = default_context_params.no_perf;

    /// Sampler parameters
    params["greedy"] = true;

    return strdup(params.dump().c_str());
}

struct llama_model_params llama_model_params_from_json(json & params) {
    auto model_params = llama_model_default_params();

    if (params.contains("vocab_only") && params["vocab_only"].is_boolean()) {
        model_params.vocab_only = params["vocab_only"];
    }

    if (params.contains("use_mmap") && params["use_mmap"].is_boolean()) {
        model_params.use_mmap = params["use_mmap"];
    }

    if (params.contains("use_mlock") && params["use_mlock"].is_boolean()) {
        model_params.use_mlock = params["use_mlock"];
    }

    if (params.contains("check_tensors") && params["check_tensors"].is_boolean()) {
        model_params.check_tensors = params["check_tensors"];
    }

    return model_params;
}

struct llama_context_params llama_context_params_from_json(json & params) {
    auto context_params = llama_context_default_params();

    if (params.contains("n_ctx") && params["n_ctx"].is_number_integer()) {
        context_params.n_ctx = params["n_ctx"];
    }

    if (params.contains("n_batch") && params["n_batch"].is_number_integer()) {
        context_params.n_batch = params["n_batch"];
    }

    if (params.contains("n_ubatch") && params["n_ubatch"].is_number_integer()) {
        context_params.n_ubatch = params["n_ubatch"];
    }

    if (params.contains("n_seq_max") && params["n_seq_max"].is_number_integer()) {
        context_params.n_seq_max = params["n_seq_max"];
    }

    if (params.contains("n_threads") && params["n_threads"].is_number_integer()) {
        context_params.n_threads = params["n_threads"];
    }

    if (params.contains("n_threads_batch") && params["n_threads_batch"].is_number_integer()) {
        context_params.n_threads_batch = params["n_threads_batch"];
    }

    if (params.contains("rope_scaling_type") && params["rope_scaling_type"].is_number_integer()) {
        context_params.rope_scaling_type = params["rope_scaling_type"];
    }

    if (params.contains("pooling_type") && params["pooling_type"].is_number_integer()) {
        context_params.pooling_type = params["pooling_type"];
    }

    if (params.contains("attention_type") && params["attention_type"].is_number_integer()) {
        context_params.attention_type = params["attention_type"];
    }

    if (params.contains("rope_freq_base") && params["rope_freq_base"].is_number_float()) {
        context_params.rope_freq_base = params["rope_freq_base"];
    }

    if (params.contains("rope_freq_scale") && params["rope_freq_scale"].is_number_float()) {
        context_params.rope_freq_scale = params["rope_freq_scale"];
    }

    if (params.contains("yarn_ext_factor") && params["yarn_ext_factor"].is_number_float()) {
        context_params.yarn_ext_factor = params["yarn_ext_factor"];
    }

    if (params.contains("yarn_attn_factor") && params["yarn_attn_factor"].is_number_float()) {
        context_params.yarn_attn_factor = params["yarn_attn_factor"];
    }

    if (params.contains("yarn_beta_fast") && params["yarn_beta_fast"].is_number_float()) {
        context_params.yarn_beta_fast = params["yarn_beta_fast"];
    }

    if (params.contains("yarn_beta_slow") && params["yarn_beta_slow"].is_number_float()) {
        context_params.yarn_beta_slow = params["yarn_beta_slow"];
    }

    if (params.contains("yarn_orig_ctx") && params["yarn_orig_ctx"].is_number_integer()) {
        context_params.yarn_orig_ctx = params["yarn_orig_ctx"];
    }

    if (params.contains("defrag_thold") && params["defrag_thold"].is_number_float()) {
        context_params.defrag_thold = params["defrag_thold"];
    }

    if (params.contains("logits_all") && params["logits_all"].is_boolean()) {
        context_params.logits_all = params["logits_all"];
    }

    if (params.contains("embeddings") && params["embeddings"].is_boolean()) {
        context_params.embeddings = params["embeddings"];
    }

    if (params.contains("offload_kqv") && params["offload_kqv"].is_boolean()) {
        context_params.offload_kqv = params["offload_kqv"];
    }

    if (params.contains("flash_attn") && params["flash_attn"].is_boolean()) {
        context_params.flash_attn = params["flash_attn"];
    }

    if (params.contains("no_perf") && params["no_perf"].is_boolean()) {
        context_params.no_perf = params["no_perf"];
    }

    return context_params;
}

int llama_init(char * params) {
    auto json_params = json::parse(params);

    if (!json_params.contains("model_path")) {
        fprintf(stderr, "Missing 'model_path' in parameters\n");
        return 1;
    }

    auto model_path = json_params["model_path"].get<std::string>();

    auto model_params = llama_model_params_from_json(json_params);
    auto context_params = llama_context_params_from_json(json_params);

    ggml_backend_load_all();

    model = llama_model_load_from_file(model_path.c_str(), model_params);
    ctx = llama_init_from_model(model, context_params);
}