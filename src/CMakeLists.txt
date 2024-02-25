if (BUILD_SHARED_LIBS AND MSVC)
  #set(CMAKE_CXX_VISIBILITY_PRESET hidden)
  #set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)
  set(WINDOWS_EXPORT_ALL_SYMBOLS YES)
endif()

add_library(essentia)
add_library(Essentia::essentia ALIAS essentia)

set_target_properties(essentia PROPERTIES DEBUG_POSTFIX _d)
set_target_properties(essentia PROPERTIES
  VERSION   ${essentia_VERSION}
  SOVERSION 1)

include_directories(${EIGEN3_INCLUDE_DIRS})
target_link_libraries(essentia PUBLIC Eigen3::Eigen)

if(ESSENTIA_USE_FFMPEG)
  include_directories(${AVCODEC_INCLUDE_DIRS} ${AVFORMAT_INCLUDE_DIRS} ${AVUTIL_INCLUDE_DIRS} ${SWRESAMPLE_INCLUDE_DIRS})
  target_link_libraries(essentia PUBLIC ${AVCODEC_LIBRARIES} ${AVFORMAT_LIBRARIES} ${AVUTIL_LIBRARIES} ${SWRESAMPLE_LIBRARIES})
endif()

if(ESSENTIA_USE_FFTW)
  include_directories(${FFTW3f_INCLUDE_DIRS})
  target_link_libraries(essentia PUBLIC ${FFTW3f_LIBRARIES})
  set(ENABLE_FFTW ON)
elseif(ESSENTIA_USE_VDSP)
  target_link_libraries(essentia PUBLIC ${ACCELERATE_LIBRARIES})
  set(ENABLE_VDSP ON)
elseif(ESSENTIA_USE_KISSFFT)
  set(ENABLE_KISS ON)
else()
  message(WARNING "No FFT library configured.")
endif()

if(ESSENTIA_USE_YAML)
  include_directories(${YAML_INCLUDE_DIRS})
  target_link_libraries(essentia PUBLIC ${YAML_LIBRARIES})
  set(ENABLE_YAML ON)
endif()

if(ESSENTIA_USE_LIBSAMPLERATE)
  include_directories(${SAMPLERATE_INCLUDE_DIRS})
  target_link_libraries(essentia PUBLIC ${SAMPLERATE_LIBRARIES})
  set(ENABLE_SAMPLERATE ON)
endif()

if(ESSENTIA_USE_TAGLIB)
  include_directories(${TAGLIB_INCLUDE_DIRS})
  target_link_libraries (essentia PUBLIC ${TAGLIB_LIBRARIES})
  set(ENABLE_TAGLIB ON)
endif()

if(ESSENTIA_USE_CHROMAPRINT)
  include_directories(${CHROMAPRINT_INCLUDE_DIRS})
  target_link_libraries (essentia PUBLIC ${CHROMAPRINT_LIBRARIES})
  add_compile_definitions(HAVE_LIBCHROMAPRINT)
  set(ENABLE_CHROMAPRINT ON)
endif()

if(ESSENTIA_USE_TENSORFLOW)
  include_directories(${TENSORFLOW_INCLUDE_DIRS})
  target_link_libraries(essentia PUBLIC ${TENSORFLOW_LIBRARIES})
  set(ENABLE_TENSORFLOW ON)
endif()

if(ESSENTIA_USE_GAIA2)
  include_directories(${Qt5Core_INCLUDE_DIRS} ${Qt5Concurrent_INCLUDE_DIRS} ${GAIA2_INCLUDE_DIRS})
  target_link_libraries(essentia PUBLIC ${GAIA2_LIBRARIES})
  add_compile_definitions(HAVE_GAIA2)
  set(ENABLE_GAIA2 ON)
endif()

if(MSVC)
  target_compile_options(essentia PRIVATE /bigobj)
endif()

configure_file(${CMAKE_CURRENT_LIST_DIR}/version.h.in ${CMAKE_CURRENT_LIST_DIR}/version.h @ONLY)

target_include_directories(essentia
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

add_subdirectory(essentia)
add_subdirectory(algorithms)
add_subdirectory(3rdparty)


if(BUILD_EXAMPLES)
  add_subdirectory(examples)
endif()

if(BUILD_PYTHON_BINDINGS)
  add_subdirectory(python)
endif()
