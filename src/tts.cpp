#include "api.h"
#include "llama.h"
#include "json.hpp"
#include "params.hpp"
#include <cassert>
#include <vector>
#include <atomic>
#include <mutex>

using json = nlohmann::ordered_json;

static llama_model * model_ttc = nullptr;
static llama_model * model_cts = nullptr;

static llama_context * ctx_ttc = nullptr;
static llama_context * ctx_cts = nullptr;

static llama_sampler * smpl = nullptr;

int llama_tts_init(char * params) {
    auto json_params = json::parse(params);

    if (!json_params.contains("ttc_model_path") || !json_params["ttc_model_path"].is_string()) {
        fprintf(stderr, "Missing 'ttc_model_path' in parameters\n");
        return 1;
    }

    auto ttc_model_path = json_params["ttc_model_path"].get<std::string>();

    if (!json_params.contains("cts_model_path") || !json_params["cts_model_path"].is_string()) {
        fprintf(stderr, "Missing 'cts_model_path' in parameters\n");
        return 1;
    }

    auto cts_model_path = json_params["cts_model_path"].get<std::string>();

    auto model_params = llama_model_params_from_json(json_params);
    auto context_params = llama_context_params_from_json(json_params);

    ggml_backend_load_all();

    model_ttc = llama_model_load_from_file(ttc_model_path.c_str(), model_params);
    ctx_ttc = llama_init_from_model(model_ttc, context_params);
    smpl = llama_sampler_from_json(model_ttc, json_params);

    model_cts = llama_model_load_from_file(cts_model_path.c_str(), model_params);
    ctx_cts = llama_init_from_model(model_cts, context_params);

    return 0;
}

void llama_tts_free(void) {
    llama_sampler_free(smpl);
    llama_free(ctx_ttc);
    llama_free(ctx_cts);
    llama_model_free(model_ttc);
    llama_model_free(model_cts);
}