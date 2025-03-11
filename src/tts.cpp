#include "api.h"
#include "llama.h"
#include "json.hpp"
#include "params.hpp"
#include "tts.hpp"
#include <cassert>
#include <vector>
#include <atomic>
#include <mutex>

using json = nlohmann::ordered_json;

const int n_parallel = 1;
const int n_predict  = 4096;

static llama_model * model_ttc = nullptr;
static llama_model * model_cts = nullptr;

static llama_context_params ctx_params;

static std::vector<llama_sampler *> smpl;

static std::string audio_text;
static std::string audio_data;

int llama_tts_init(char * params) {
    auto json_params = json::parse(params);

    if (!json_params.contains("model_path") || !json_params["model_path"].is_string()) {
        fprintf(stderr, "Missing 'model_path' in parameters\n");
        return 1;
    }

    auto ttc_model_path = json_params["model_path"].get<std::string>();

    if (!json_params.contains("vocoder_model_path") || !json_params["vocoder_model_path"].is_string()) {
        fprintf(stderr, "Missing 'vocoder_model_path' in parameters\n");
        return 1;
    }

    auto cts_model_path = json_params["vocoder_model_path"].get<std::string>();

    if (!json_params.contains("voice_path") || !json_params["voice_path"].is_string()) {
        fprintf(stderr, "Missing 'voice_path' in parameters\n");
        return 1;
    }

    auto voice_path = json_params["voice_path"].get<std::string>();

    std::ifstream voice_file(voice_path);

    if (!voice_file) {
        fprintf(stderr, "Failed to open voice file\n");
        return 1;
    }

    auto speaker = json::parse(voice_file);

    auto model_params = llama_model_params_from_json(json_params);
    ctx_params = llama_context_params_from_json(json_params);

    ggml_backend_load_all();

    model_ttc = llama_model_load_from_file(ttc_model_path.c_str(), model_params);

    smpl = std::vector<llama_sampler *>(n_parallel);
    for (int i = 0; i < n_parallel; ++i) {
        smpl[i] = llama_sampler_from_json(model_ttc, json_params);
    }

    model_cts = llama_model_load_from_file(cts_model_path.c_str(), model_params);

    outetts_version tts_version = get_tts_version(model_ttc);

    audio_text = audio_text_from_speaker(speaker, tts_version);
    audio_data = audio_data_from_speaker(speaker, tts_version);

    return 0;
}

int llama_tts(char * text, char * output_path) {
    std::string prompt(text);
    std::string fname(output_path);

    ctx_params.embeddings = false;
    auto ctx_ttc = llama_init_from_model(model_ttc, ctx_params);
    ctx_params.embeddings = true;
    auto ctx_cts = llama_init_from_model(model_cts, ctx_params);

    std::vector<llama_token> prompt_inp;

    const llama_vocab * vocab = llama_model_get_vocab(model_ttc);

    prompt_init(prompt_inp, vocab);

    prompt_add(prompt_inp, vocab, audio_text, false, true);

    outetts_version tts_version = get_tts_version(model_ttc);

    std::string prompt_clean = process_text(prompt, tts_version);

    std::vector<llama_token> guide_tokens = prepare_guide_tokens(vocab, prompt_clean, tts_version);

    prompt_add(prompt_inp, vocab, prompt_clean, false, true);

    prompt_add(prompt_inp, vocab, "<|text_end|>\n", false, true);

    prompt_add(prompt_inp, vocab, audio_data, false, true);

    // create a llama_batch
    // we use this object to submit token data for decoding
    llama_batch batch = llama_batch_init(std::max(prompt_inp.size(), (size_t) n_parallel), 0, n_parallel);

    std::vector<llama_seq_id> seq_ids(n_parallel, 0);
    for (int32_t i = 0; i < n_parallel; ++i) {
        seq_ids[i] = i;
    }

    // evaluate the initial prompt
    for (size_t i = 0; i < prompt_inp.size(); ++i) {
        batch_add(batch, prompt_inp[i], i, seq_ids, false);
    }

    // llama_decode will output logits only for the last token of the prompt
    batch.logits[batch.n_tokens - 1] = true;

    if (llama_decode(ctx_ttc, batch) != 0) {
        fprintf(stderr, "%s: llama_decode() failed\n", __func__);
        return 1;
    }

    llama_synchronize(ctx_ttc);

    // main loop

    // remember the batch index of the last token for each parallel sequence
    // we need this to determine which logits to sample from
    std::vector<int32_t> i_batch(n_parallel, batch.n_tokens - 1);

    int n_past   = batch.n_tokens;
    int n_decode = 0;

    bool next_token_uses_guide_token = true;

    std::vector<llama_token> codes;

    while (n_decode <= n_predict) {
        batch.n_tokens = 0;

        // sample the next token for each parallel sequence / stream
        for (int32_t i = 0; i < n_parallel; ++i) {
            if (i_batch[i] < 0) {
                // the stream has already finished
                continue;
            }

            llama_token new_token_id = llama_sampler_sample(smpl[i], ctx_ttc, i_batch[i]);

            //guide tokens help prevent hallucinations by forcing the TTS to use the correct word
            if (!guide_tokens.empty() && next_token_uses_guide_token && !llama_vocab_is_control(vocab, new_token_id) && !llama_vocab_is_eog(vocab, new_token_id)) {
                llama_token guide_token = guide_tokens[0];
                guide_tokens.erase(guide_tokens.begin());
                new_token_id = guide_token; //ensure correct word fragment is used
            }

            //this is the token id that always precedes a new word
            next_token_uses_guide_token = (new_token_id == 198);

            llama_sampler_accept(smpl[i], new_token_id);

            codes.push_back(new_token_id);

            if (llama_vocab_is_eog(vocab, new_token_id) || n_decode == n_predict) {
                // Mark the stream as finished
                i_batch[i] = -1;
                continue;
            }

            i_batch[i] = batch.n_tokens;

            batch_add(batch, new_token_id, n_past, { i }, true);
        }

        // all streams are finished
        if (batch.n_tokens == 0) {
            break;
        }

        n_decode += 1;
        n_past += 1;

        // evaluate the current batch with the transformer model
        if (llama_decode(ctx_ttc, batch)) {
            fprintf(stderr, "%s: llama_decode() failed\n", __func__);
            return 1;
        }
    }

    llama_batch_free(batch);

    // remove all non-audio tokens (i.e. < 151672 || > 155772)
    codes.erase(std::remove_if(codes.begin(), codes.end(), [](llama_token t) { return t < 151672 || t > 155772; }), codes.end());

    for (auto & token : codes) {
        token -= 151672;
    }

    const int n_codes = codes.size();

    batch = llama_batch_init(n_codes, 0, 1);

    for (size_t i = 0; i < codes.size(); ++i) {
        batch_add(batch, codes[i], i, { 0 }, true); // TODO: all logits?
    }

    // evaluate the current batch with the transformer model
    if (llama_decode(ctx_cts, batch)) {
        fprintf(stderr, "%s: llama_decode() failed\n", __func__);
        return 1;
    }

    llama_synchronize(ctx_cts);

    // spectral operations
    const int n_embd = llama_model_n_embd(model_cts);
    const float * embd = llama_get_embeddings(ctx_cts);

    auto audio = embd_to_audio(embd, n_codes, n_embd, ctx_params.n_threads);

    const int n_sr = 24000; // sampling rate

    // zero out first 0.25 seconds
    for (int i = 0; i < 24000/4; ++i) {
        audio[i] = 0.0f;
    }

    save_wav16(fname, audio, n_sr);

    llama_free(ctx_ttc);
    llama_free(ctx_cts);

    return 0;
}

void llama_tts_free(void) {
    for (auto & s : smpl) {
        llama_sampler_free(s);
    }

    llama_model_free(model_ttc);
    llama_model_free(model_cts);
}