cmake_minimum_required(VERSION 3.22)

# Define the project
project(lcpp)

# Ensure we are building with Emscripten
if(NOT EMSCRIPTEN)
  message(FATAL_ERROR "This project must be built with Emscripten to target WebAssembly. Use 'emcmake cmake ..'")
endif()

# Set build metadata and update target from Android to wasm
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DBUILD_COMMIT=unknown -DBUILD_COMPILER=unknown -DBUILD_TARGET=wasm")

# Optional: set executable suffix to .html (Emscripten default output)
set(CMAKE_EXECUTABLE_SUFFIX ".html")

# Define directories for sources
set(API_DIR ../src)
set(LLAMA_CPP_DIR ${API_DIR}/llama_cpp)

# Add subdirectory (specifying separate binary directory)
add_subdirectory(${LLAMA_CPP_DIR} ${CMAKE_BINARY_DIR}/llama_cpp_build)

# Add additional sources to the 'llama' target
target_sources(
  llama 
  PRIVATE 
  ${API_DIR}/params.cpp
  ${API_DIR}/llm.cpp
)

# General compile options
target_compile_options(
  llama 
  PRIVATE 
  -O3 
  -DNDEBUG
  -ffunction-sections 
  -fdata-sections
)

# Emscripten-specific compile flags (passed as single strings)
target_compile_options(
  llama
  PRIVATE
  "-sWASM=1"
  "-sALLOW_MEMORY_GROWTH=1"
)

# Emscripten-specific link options (passed as single strings)
target_link_options(
  llama 
  PRIVATE 
  "-sWASM=1"
  "-sALLOW_MEMORY_GROWTH=1"
  "-sEXPORTED_FUNCTIONS=['_main', '_llama_default_params', '_llama_llm_init', '_llama_prompt', '_llama_llm_stop', '_llama_llm_free']"
  "-sEXTRA_EXPORTED_RUNTIME_METHODS=['ccall','cwrap']"
  -Wl,--gc-sections 
  -flto
)

# Define the executable target with a proper entry point.
add_executable(lcpp wasm-entry.c)
target_link_libraries(lcpp PRIVATE llama)

# Set output directory for the final wasm file
set_target_properties(
    lcpp 
    PROPERTIES 
    RUNTIME_OUTPUT_NAME "llama"
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/web
)