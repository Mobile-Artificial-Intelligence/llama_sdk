cmake_minimum_required(VERSION 3.22)

# Define the project
project(llama_sdk)

# Set CMake flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DANDROID_16K_PAGES")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DBUILD_COMMIT=unknown -DBUILD_COMPILER=unknown -DBUILD_TARGET=Android -DANDROID_16K_PAGES")
add_link_options("LINKER:--hash-style=gnu,--build-id=none")

set(API_DIR ../src)
set(LLAMA_CPP_DIR ${API_DIR}/llama_cpp)

# Add subdirectory with explicit source and binary directories
add_subdirectory(${LLAMA_CPP_DIR} ${CMAKE_BINARY_DIR}/llama_cpp_build)

target_include_directories(
  llama 
  PRIVATE 
  ${LLAMA_CPP_DIR}/common
  ${LLAMA_CPP_DIR}/include
  ${LLAMA_CPP_DIR}/vendor/nlohmann
  ${API_DIR}
)

target_sources(
  llama 
  PRIVATE 
  ${API_DIR}/params.cpp
  ${API_DIR}/llm.cpp
)

target_compile_options(
  llama 
  PRIVATE 
  -O3 
  -DNDEBUG
  -ffunction-sections 
  -fdata-sections
)

target_link_options(
  llama 
  PRIVATE 
  -Wl,--gc-sections 
  -Wl,-z,max-page-size=16384
  -flto
)

# Enable compiler optimizations for arm64-v8a
if(ANDROID_ABI STREQUAL "arm64-v8a")
  target_compile_options(llama PRIVATE -march=armv8.4-a+fp16+dotprod -DLM_GGML_USE_CPU -DLM_GGML_USE_CPU_AARCH64 -pthread)
endif()