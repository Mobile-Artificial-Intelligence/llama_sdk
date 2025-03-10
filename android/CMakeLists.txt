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

target_sources(llama PRIVATE ${API_DIR}/api.cpp)