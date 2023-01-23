cmake_minimum_required(VERSION 3.16.0)

project(essentia VERSION 2.1.0
                 DESCRIPTION "C++ library for audio and music analysis, description and synthesis"
                 LANGUAGES C CXX)

file(STRINGS "VERSION" essentia_VERSION_STRING)

set(CMAKE_C_STANDARD 99)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules)

option(BUILD_TESTS "Build tests" ON)
option(BUILD_EXAMPLES "Build examples" OFF)
option(BUILD_PYTHON_BINDINGS "Build Python bindings" OFF)
option(USE_TENSORFLOW "Use TensorFlow" OFF)
option(USE_GAIA2 "Use Gaia2" OFF)

find_package(Eigen3 3.3 REQUIRED NO_MODULE)
find_package(FFmpeg)
find_package(FFTW3)
find_package(SampleRate)
find_package(Taglib)
find_package(Chromaprint)
find_package(YAML)

if(BUILD_PYTHON_BINDINGS)
  find_package(Python3 COMPONENTS Development NumPy)
endif()

if(USE_TENSORFLOW)
  find_package(TensorFlow)
endif()

if(USE_GAIA2)
  find_package(Gaia2)
  find_package(Qt5 COMPONENTS Core Concurrent REQUIRED)
endif()

set(ESSENTIA_USE_FFMPEG OFF)
set(ESSENTIA_USE_FFTW OFF)
set(ESSENTIA_USE_KISSFFT OFF)
set(ESSENTIA_USE_VDSP OFF)
set(ESSENTIA_USE_YAML OFF)
set(ESSENTIA_USE_LIBSAMPLERATE OFF)
set(ESSENTIA_USE_TAGLIB OFF)
set(ESSENTIA_USE_CHROMAPRINT OFF)
set(ESSENTIA_USE_TENSORFLOW OFF)
set(ESSENTIA_USE_GAIA OFF)

if(FFMPEG_FOUND)
  set(ESSENTIA_USE_FFMPEG ON)
endif()

if(APPLE AND ACCELERATE_LIBRARIES)
  set(ESSENTIA_USE_VDSP ON)
elseif(FFTW3_FOUND)
  set(ESSENTIA_USE_FFTW ON)
else()
  set(ESSENTIA_USE_KISSFFT ON)
endif()

if(SampleRate_FOUND)
  set(ESSENTIA_USE_LIBSAMPLERATE ON)
endif()

if(TAGLIB_FOUND)
  set(ESSENTIA_USE_TAGLIB ON)
endif()

if(Chromaprint_FOUND)
  set(ESSENTIA_USE_CHROMAPRINT ON)
endif()

if(YAML_FOUND)
  set(ESSENTIA_USE_YAML ON)
endif()

if(TensorFlow_FOUND)
  set(ESSENTIA_USE_TENSORFLOW ON)
endif()

if(Gaia2_FOUND)
  set(ESSENTIA_USE_GAIA2 ON)
endif()

if(MSVC)
  add_compile_definitions(NOMINMAX _USE_MATH_DEFINES)
  add_compile_options(/W4 /wd4100 /Zc:__cplusplus)
else()
  add_compile_options(-Wall -Wextra -Wno-unused-parameter -Wno-unknown-pragmas -Wno-ignored-qualifiers)
endif()

add_subdirectory(src)

if(BUILD_TESTS AND CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
  enable_testing()
  add_subdirectory(test/src/basetest)
endif()