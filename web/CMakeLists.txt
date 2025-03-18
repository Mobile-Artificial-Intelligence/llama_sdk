cmake_minimum_required(VERSION 3.22)
project(lcpp)

# Ensure we are building with Emscripten
if(NOT EMSCRIPTEN)
  message(FATAL_ERROR "This project must be built with Emscripten to target WebAssembly. Use 'emcmake cmake ..'")
endif()

set(BUILD_SHARED_LIBS OFF)
set(CMAKE_EXECUTABLE_SUFFIX ".html")

# Define directories for sources
set(API_DIR ../src)
set(LLAMA_CPP_DIR ${API_DIR}/llama_cpp)

# Add subdirectory for llama_cpp (with its own binary directory)
add_subdirectory(${LLAMA_CPP_DIR} ${CMAKE_BINARY_DIR}/llama_cpp_build)

# Add additional sources to the 'llama' target
target_sources(
  llama 
  PRIVATE 
  ${API_DIR}/params.cpp
)

# Global Emscripten flags (adjusted to match your Docker build)
set(EMSCRIPTEN_FLAGS
  "-O3"
  "-msimd128"
  "-pthread"
  "-DNDEBUG"
  "-flto=full"
  "-frtti"
  "-fwasm-exceptions"
  "-sEXPORT_ALL=1"
  "-sEXPORT_ES6=0"         # Use 0 if you don't need ES6 modules
  "-sMODULARIZE=0"         # Use 0 if you prefer a non-modularized build
  "-sINITIAL_MEMORY=128MB"
  "-sMAXIMUM_MEMORY=4096MB"
  "-sALLOW_MEMORY_GROWTH=1"
  "-sFORCE_FILESYSTEM=1"
  "-sUSE_PTHREADS=1"
  "-sASYNCIFY=1"
  "-sPTHREAD_POOL_SIZE=4"
  "-sNO_EXIT_RUNTIME=1"
)

# Apply Emscripten flags to the llama target
target_compile_options(llama PRIVATE ${EMSCRIPTEN_FLAGS})
target_link_options(llama PRIVATE ${EMSCRIPTEN_FLAGS})

# Define the executable target with a proper entry point.
add_executable(lcpp ${API_DIR}/llm.cpp)
target_link_libraries(lcpp PRIVATE ggml llama)

# Also apply the same Emscripten flags to the final executable
target_compile_options(lcpp PRIVATE ${EMSCRIPTEN_FLAGS})
target_link_options(lcpp PRIVATE ${EMSCRIPTEN_FLAGS})

# Set output directory for the final wasm file
set_target_properties(
    lcpp 
    PROPERTIES 
    RUNTIME_OUTPUT_NAME "llama"
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/web
)
