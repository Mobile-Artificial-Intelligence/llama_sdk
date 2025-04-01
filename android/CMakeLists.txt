cmake_minimum_required(VERSION 3.22)

# Define the project
project(lcpp)

# Set CMake flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DBUILD_COMMIT=unknown -DBUILD_COMPILER=unknown -DBUILD_TARGET=Android")
add_link_options("LINKER:--hash-style=gnu,--build-id=none")

set(API_DIR ../src)
set(LLAMA_CPP_DIR ${API_DIR}/llama_cpp)

# Add subdirectory with explicit source and binary directories
add_subdirectory(${LLAMA_CPP_DIR} ${CMAKE_BINARY_DIR}/llama_cpp_build)

set(GGML_VULKAN ON CACHE BOOL "Enable Vulkan support" FORCE)

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
  -flto
)

find_package(Vulkan REQUIRED)
target_link_libraries(llama PRIVATE Vulkan::Vulkan)

target_compile_options(
  llama 
  PRIVATE 
  -DGGML_USE_CPU 
  -DGGML_USE_VULKAN
  -pthread
)

# Enable compiler optimizations for arm64-v8a
if(ANDROID_ABI STREQUAL "arm64-v8a")
  target_compile_options(llama PRIVATE -march=armv8.4-a+fp16+dotprod -DGGML_USE_CPU_AARCH64)
endif()