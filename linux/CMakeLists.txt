# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

# Project-level configuration.
set(PROJECT_NAME "llama")
project(${PROJECT_NAME} LANGUAGES CXX)

set(API_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../src)
set(LLAMA_CPP_DIR ${API_DIR}/llama_cpp)

set(BUILD_SHARED_LIBS ON)
set(CMAKE_INSTALL_LIBDIR lib CACHE PATH "library install dir" FORCE)

# Set the linker flags for shared libraries
set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--build-id=none")

set(LLAMA_NATIVE OFF CACHE BOOL "llama: disable -march=native flag" FORCE)
set(LLAMA_VULKAN ON CACHE BOOL "llama: enable vulkan" FORCE)

add_subdirectory(${LLAMA_CPP_DIR} ${CMAKE_CURRENT_BINARY_DIR}/shared)

target_sources(
  llama 
  PRIVATE 
  ${API_DIR}/llm.cpp
  ${API_DIR}/tts.cpp
)

set_target_properties(llama PROPERTIES
  PUBLIC_HEADER ${API_DIR}/api.h
  BUILD_WITH_INSTALL_RPATH TRUE
  INSTALL_RPATH "$ORIGIN"
)

target_compile_definitions(llama PUBLIC DART_SHARED_LIB)

set(llama_bundled_libraries
  $<TARGET_FILE:llama>
  PARENT_SCOPE
)