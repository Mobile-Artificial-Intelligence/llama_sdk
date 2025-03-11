#include "params.hpp"
#include <cassert>
#include <vector>

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

llama_sampler * llama_sampler_from_json(llama_model * model, json & params) {
    assert(model != nullptr);

    auto vocab = llama_model_get_vocab(model);
    auto sampler = llama_sampler_chain_init(llama_sampler_chain_default_params());

    if (
        params.contains("greedy") && 
        params["greedy"].is_boolean() && 
        params["greedy"]
    ) {
        llama_sampler_chain_add(sampler, llama_sampler_init_greedy());
    }

    if (
        params.contains("infill") && 
        params["infill"].is_boolean() && 
        params["infill"]
    ) {
        llama_sampler_chain_add(sampler, llama_sampler_init_infill(vocab));
    }

    if (
        params.contains("seed") && 
        params["seed"].is_number_integer() && 
        params["seed"] != LLAMA_DEFAULT_SEED
    ) {
        llama_sampler_chain_add(sampler, llama_sampler_init_dist(params["seed"]));
    }

    if (
        params.contains("top_k") && 
        params["top_k"].is_number_integer() && 
        params["top_k"] > 0
    ) {
        llama_sampler_chain_add(sampler, llama_sampler_init_top_k(params["top_k"]));
    }

    if (
        params.contains("top_p") && 
        params["top_p"].is_number_float() && 
        params.contains("top_p_min_keep") && 
        params["top_p_min_keep"].is_number_integer()
    ) {
        llama_sampler_chain_add(
            sampler, 
            llama_sampler_init_top_p(
                params["top_p"], 
                params["top_p_min_keep"]
            )
        );
    }

    if (
        params.contains("min_p") && 
        params["min_p"].is_number_float() && 
        params.contains("min_p_min_keep") && 
        params["min_p_min_keep"].is_number_integer()
    ) {
        llama_sampler_chain_add(
            sampler, 
            llama_sampler_init_min_p(
                params["min_p"], 
                params["min_p_min_keep"]
            )
        );
    }

    if (
        params.contains("typical_p") && 
        params["typical_p"].is_number_float() && 
        params.contains("typical_p_min_keep") && 
        params["typical_p_min_keep"].is_number_integer()
    ) {
        llama_sampler_chain_add(
            sampler, 
            llama_sampler_init_typical(
                params["typical_p"], 
                params["typical_p_min_keep"]
            )
        );
    }

    if (
        params.contains("temperature") && 
        params["temperature"].is_number_float()
    ) {
        if (
            params.contains("temperature_delta") && 
            params["temperature_delta"].is_number_float() && 
            params.contains("temperature_exponent") && 
            params["temperature_exponent"].is_number_float()
        ) {
            llama_sampler_chain_add(
                sampler, 
                llama_sampler_init_temp_ext(
                    params["temperature"], 
                    params["temperature_delta"], 
                    params["temperature_exponent"]
                )
            );
        } 
        else {
            llama_sampler_chain_add(sampler, llama_sampler_init_temp(params["temperature"]));
        }
    }

    if (
        params.contains("xtc_p") && 
        params["xtc_p"].is_number_float() && 
        params.contains("xtc_t") && 
        params["xtc_t"].is_number_float() && 
        params.contains("xtc_min_keep") && 
        params["xtc_min_keep"].is_number_integer() &&
        params.contains("xtc_seed") &&
        params["xtc_seed"].is_number_integer()
    ) {
        llama_sampler_chain_add(
            sampler, 
            llama_sampler_init_xtc(
                params["xtc_p"], 
                params["xtc_t"], 
                params["xtc_min_keep"], 
                params["xtc_seed"]
            )
        );
    }

    if (
        params.contains("mirostat_n_vocab") && 
        params["mirostat_n_vocab"].is_number_integer() &&
        params.contains("mirostat_seed") &&
        params["mirostat_seed"].is_number_integer() &&
        params.contains("mirostat_tau") &&
        params["mirostat_tau"].is_number_float() &&
        params.contains("mirostat_eta") &&
        params["mirostat_eta"].is_number_float() &&
        params.contains("mirostat_m") &&
        params["mirostat_m"].is_number_integer()
    ) {
        llama_sampler_chain_add(
            sampler, 
            llama_sampler_init_mirostat(
                params["mirostat_n_vocab"], 
                params["mirostat_seed"], 
                params["mirostat_tau"], 
                params["mirostat_eta"], 
                params["mirostat_m"]
            )
        );
    }

    if (
        params.contains("mirostat_v2_seed") && 
        params["mirostat_v2_seed"].is_number_integer() &&
        params.contains("mirostat_v2_tau") &&
        params["mirostat_v2_tau"].is_number_float() &&
        params.contains("mirostat_v2_eta") &&
        params["mirostat_v2_eta"].is_number_float()
    ) {
        llama_sampler_chain_add(
            sampler, 
            llama_sampler_init_mirostat_v2(
                params["mirostat_v2_seed"], 
                params["mirostat_v2_tau"], 
                params["mirostat_v2_eta"]
            )
        );
    }

    if (
        params.contains("grammar_str") && 
        params["grammar_str"].is_string() &&
        params.contains("grammar_root") &&
        params["grammar_root"].is_string()
    ) {
        auto str = params["grammar_str"].get<std::string>();
        auto root = params["grammar_root"].get<std::string>();

        llama_sampler_chain_add(
            sampler, 
            llama_sampler_init_grammar(
                vocab, 
                str.c_str(),
                root.c_str()
            )
        );
    }

    if (
        params.contains("penalties_last_n") &&
        params["penalties_last_n"].is_number_integer() &&
        params.contains("penalties_repeat") &&
        params["penalties_repeat"].is_number_float() &&
        params.contains("penalties_freq") &&
        params["penalties_freq"].is_number_float() &&
        params.contains("penalties_present") &&
        params["penalties_present"].is_number_float()
    ) {
        llama_sampler_chain_add(
            sampler, 
            llama_sampler_init_penalties(
                params["penalties_last_n"],
                params["penalties_repeat"],
                params["penalties_freq"],
                params["penalties_present"]
            )
        );
    }

    if (
        params.contains("dry_sampler_n_ctx_train") && 
        params["dry_sampler_n_ctx_train"].is_number_integer() &&
        params.contains("dry_sampler_multiplier") &&
        params["dry_sampler_multiplier"].is_number_float() &&
        params.contains("dry_sampler_base") &&
        params["dry_sampler_base"].is_number_float() &&
        params.contains("dry_sampler_allowed_length") &&
        params["dry_sampler_allowed_length"].is_number_integer() &&
        params.contains("dry_sampler_penalty_last_n") &&
        params["dry_sampler_penalty_last_n"].is_number_integer() &&
        params.contains("dry_sampler_breakers") &&
        params["dry_sampler_breakers"].is_array()
    ) {
        auto breakers = params["dry_sampler_breakers"].get<std::vector<std::string>>();
        std::vector<const char *> breakers_c(breakers.size());
        for (size_t i = 0; i < breakers.size(); i++) {
            breakers_c[i] = breakers[i].c_str();
        }

        llama_sampler_chain_add(
            sampler, 
            llama_sampler_init_dry(
                vocab, 
                params["dry_sampler_n_ctx_train"],
                params["dry_sampler_multiplier"],
                params["dry_sampler_base"],
                params["dry_sampler_allowed_length"],
                params["dry_sampler_penalty_last_n"],
                breakers_c.data(),
                breakers_c.size()
            )
        );
    }

    return sampler;
}