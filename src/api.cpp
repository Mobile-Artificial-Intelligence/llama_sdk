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