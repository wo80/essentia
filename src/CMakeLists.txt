add_library(essentia STATIC)

set_property(TARGET essentia PROPERTY VERSION ${Essentia_VERSION})
set_property(TARGET essentia PROPERTY SOVERSION 1)

include_directories(${EIGEN3_INCLUDE_DIRS})
target_link_libraries(essentia Eigen3::Eigen)

if(ESSENTIA_USE_FFMPEG)
  include_directories(${AVCODEC_INCLUDE_DIRS} ${AVFORMAT_INCLUDE_DIRS} ${AVUTIL_INCLUDE_DIRS} ${SWRESAMPLE_INCLUDE_DIRS})
endif()

if(ESSENTIA_USE_FFTW)
  include_directories(${FFTW3_INCLUDE_DIRS})
  set(ENABLE_FFTW ON)
endif()

if(ESSENTIA_USE_KISSFFT)
  include_directories(${KISSFFT_INCLUDE_DIRS})
  set(ENABLE_KISS ON)
endif()

if(ESSENTIA_USE_ACCELERATE_FFT)
  include_directories(${ACCELERATE_FFT_INCLUDE_DIRS})
  set(ENABLE_ACCELERATE ON)
endif()

if(ESSENTIA_USE_YAML)
  include_directories(${YAML_INCLUDE_DIR})
  set(ENABLE_YAML ON)
endif()

if(ESSENTIA_USE_LIBSAMPLERATE)
  include_directories(${SAMPLERATE_INCLUDE_DIR})
  set(ENABLE_SAMPLERATE ON)
endif()

if(ESSENTIA_USE_TAGLIB)
  include_directories(${TAGLIB_INCLUDE_DIRS})
  set(ENABLE_TAGLIB ON)
endif()

if(ESSENTIA_USE_CHROMAPRINT)
  include_directories(${CHROMAPRINT_INCLUDE_DIR})
  set(ENABLE_CHROMAPRINT ON)
endif()

if(ESSENTIA_USE_TENSORFLOW)
  include_directories(${TensorFlow_INCLUDE_DIR})
  set(ENABLE_TENSORFLOW ON)
endif()

if(ESSENTIA_USE_GAIA2)
  include_directories(${Qt5Core_INCLUDE_DIRS} ${Qt5Concurrent_INCLUDE_DIRS} ${GAIA2_INCLUDE_DIR})
  set(ENABLE_GAIA2 ON)
endif()

if(MSVC)
  target_compile_options(essentia PRIVATE /bigobj /MP)
endif()

configure_file(${CMAKE_CURRENT_LIST_DIR}/version.h.in ${CMAKE_CURRENT_LIST_DIR}/version.h @ONLY)

target_include_directories(essentia PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(essentia)
add_subdirectory(algorithms)
add_subdirectory(3rdparty)


if(BUILD_EXAMPLES)
  add_subdirectory(examples)
endif()