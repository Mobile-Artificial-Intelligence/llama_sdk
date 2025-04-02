cmake_minimum_required(VERSION 3.22)

# Define the project
project(lcpp)

# Set CMake flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3 -DNDEBUG -pthread -ffunction-sections -fdata-sections -DBUILD_COMMIT=unknown -DBUILD_COMPILER=unknown -DBUILD_TARGET=Android")
add_link_options("LINKER:--hash-style=gnu,--build-id=none,--gc-sections")

# Set the minimum Android API level
set(GGML_VULKAN ON CACHE BOOL "Enable Vulkan support" FORCE)

# Enable compiler optimizations for arm64-v8a
if(ANDROID_ABI STREQUAL "arm64-v8a")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=armv8.4-a+fp16+dotprod")
endif()

set(API_DIR ../src)
set(LLAMA_CPP_DIR ${API_DIR}/llama_cpp)

# Add subdirectory with explicit source and binary directories
add_subdirectory(${LLAMA_CPP_DIR} ${CMAKE_BINARY_DIR}/llama_cpp_build)

target_sources(
  llama 
  PRIVATE 
  ${API_DIR}/params.cpp
  ${API_DIR}/llm.cpp
)