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

set(CMAKE_FIND_PACKAGE_PREFER_CONFIG TRUE)
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake/modules)

include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/EssentiaUtilities.cmake)

option(BUILD_TESTS "Build tests" ON)
option(BUILD_EXAMPLES "Build examples" OFF)
option(BUILD_PYTHON_BINDINGS "Build Python bindings" OFF)
option(BUILD_VAMP_PLUGIN "Build VAMP plugin" OFF)
option(USE_KISSFFT "Use internal KissFFT" OFF)
option(USE_TENSORFLOW "Use TensorFlow" OFF)
option(USE_GAIA2 "Use Gaia2" OFF)
option(ENABLE_STATIC_DEPENDENCIES "MSVC only: enable linking against static dependencies" OFF)

# Options from src/essentia/config.h
option(DEBUGGING_ENABLED "Enable Essentia debugging mode" ON)
option(STRIP_DOCUMENTATION "Strip documentation from binaries" OFF)

mark_as_advanced(DEBUGGING_ENABLED STRIP_DOCUMENTATION)

find_package(Eigen3 3.3...<5.1 REQUIRED NO_MODULE)
find_package(FFmpeg)
find_package(SampleRate QUIET)
find_package(Taglib QUIET)
find_package(Chromaprint QUIET)
find_package(Yaml QUIET)

if(BUILD_PYTHON_BINDINGS)
  find_package(Python3 COMPONENTS Development NumPy)
endif()

if(BUILD_VAMP_PLUGIN)
  find_package(VampSdk QUIET)
endif()

if(USE_TENSORFLOW)
  find_package(TensorFlow QUIET)
endif()

if(USE_GAIA2)
  find_package(Gaia2 QUIET)

  if(NOT Qt5_FOUND)
    find_package(Qt5 COMPONENTS Core Concurrent REQUIRED)
  endif()
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
set(ESSENTIA_USE_VAMP OFF)
set(ESSENTIA_USE_GAIA OFF)

if(USE_KISSFFT)
  set(ESSENTIA_USE_KISSFFT ON)
else()
  find_package(FFTW3f)

  if(APPLE)
    find_library(ACCELERATE_LIBRARIES Accelerate)
  endif()

  if(TARGET FFTW3::fftw3f)
    set(ESSENTIA_USE_FFTW ON)
  elseif(APPLE AND ACCELERATE_LIBRARIES)
    set(ESSENTIA_USE_VDSP ON)
  else()
    set(ESSENTIA_USE_KISSFFT ON)
  endif()
endif()

if(FFMPEG_FOUND)
  set(ESSENTIA_USE_FFMPEG ON)
else()
  message(WARNING "FFmpeg not found - compilation of audio loaders/writers disabled!")
endif()

if(TARGET SampleRate::samplerate)
  essentia_package_info(SampleRate SampleRate::samplerate)
  set(ESSENTIA_USE_LIBSAMPLERATE ON)
endif()

if(TARGET TagLib::tag)
  essentia_package_info(Taglib TagLib::tag)
  set(ESSENTIA_USE_TAGLIB ON)
endif()

if(TARGET Chromaprint::chromaprint)
  essentia_package_info(Chromaprint Chromaprint::chromaprint)
  set(ESSENTIA_USE_CHROMAPRINT ON)
endif()

if(TARGET yaml)
  essentia_package_info(yaml yaml)
  set(ESSENTIA_USE_YAML ON)
endif()

if(TARGET TensorFlow::tensorflow)
  essentia_package_info(TensorFlow TensorFlow::tensorflow)
  set(ESSENTIA_USE_TENSORFLOW ON)
endif()

if(TARGET VampSdk::vamp)
  essentia_package_info(VampSdk VampSdk::vamp)
  set(ESSENTIA_USE_VAMP ON)
endif()

if(TARGET Gaia2::gaia2)
  essentia_package_info(Gaia2 Gaia2::gaia2)
  set(ESSENTIA_USE_GAIA2 ON)
endif()

if(MSVC)
  add_compile_definitions(NOMINMAX _USE_MATH_DEFINES)
  add_compile_options(/MP /W4 /wd4100 /Zc:__cplusplus)
else()
  add_compile_options(-Wall -Wextra -Wno-unused-parameter -Wno-unknown-pragmas -Wno-ignored-qualifiers)
endif()

add_subdirectory(src)

if(BUILD_TESTS AND CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
  enable_testing()
  add_subdirectory(test/src/basetest)
endif()

include(GNUInstallDirs)
include(CMakePackageConfigHelpers)

install(TARGETS essentia
  EXPORT EssentiaTargets
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

configure_package_config_file(
  cmake/EssentiaConfig.cmake.in
  ${CMAKE_CURRENT_BINARY_DIR}/EssentiaConfig.cmake
  PATH_VARS CMAKE_INSTALL_INCLUDEDIR
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Essentia
)

write_basic_package_version_file(
  ${CMAKE_CURRENT_BINARY_DIR}/EssentiaConfigVersion.cmake
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY SameMajorVersion
)

# Maybe not the best idea to install headers this way.
install(DIRECTORY src/essentia/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/essentia
  FILES_MATCHING PATTERN "*.h"
)

install(FILES src/version.h
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/essentia
)

install(FILES
  ${CMAKE_CURRENT_BINARY_DIR}/EssentiaConfig.cmake
  ${CMAKE_CURRENT_BINARY_DIR}/EssentiaConfigVersion.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Essentia
)

install(EXPORT EssentiaTargets
  FILE EssentiaTargets.cmake
  NAMESPACE Essentia::
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/Essentia
)
