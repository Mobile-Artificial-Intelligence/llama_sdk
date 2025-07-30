#ifndef PARAMS_HPP
#define PARAMS_HPP

#include "llama_cpp/include/llama.h"
#include "llama_cpp/vendor/nlohmann/json.hpp"

using json = nlohmann::ordered_json;

struct llama_model_params llama_model_params_from_json(json & params);

struct llama_context_params llama_context_params_from_json(json & params);

llama_sampler * llama_sampler_from_json(llama_model * model, json & params);

#endif