if (MSVC)
  if (BUILD_SHARED_LIBS)
    # In case of errors reporting missing exports, this option might help.
    #set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS YES)
  endif()
  
  if (ENABLE_STATIC_DEPENDENCIES)
    # These are necessary to properly set up the __declspec attribute. It might be better
    # to have separate options: ENABLE_STATIC_CHROMAPRINT, ENABLE_STATIC_YAML etc.
    add_compile_definitions(CHROMAPRINT_NODLL YAML_DECLARE_STATIC TAGLIB_STATIC)
  endif()
endif()

add_library(essentia)
add_library(Essentia::essentia ALIAS essentia)

if (MSVC AND ENABLE_STATIC_DEPENDENCIES)
  # In case Essentia is linked against static FFmpeg libraries, we need to add
  # the bcrypt dependency manually (required by avutil).
  target_link_libraries(essentia PUBLIC bcrypt.lib)
endif()

set_target_properties(essentia PROPERTIES DEBUG_POSTFIX _d)
set_target_properties(essentia PROPERTIES
  VERSION   ${essentia_VERSION}
  SOVERSION 1)

include_directories(${EIGEN3_INCLUDE_DIRS})
target_link_libraries(essentia PUBLIC Eigen3::Eigen)

if(ESSENTIA_USE_FFMPEG)
  include_directories(${AVCODEC_INCLUDE_DIRS} ${AVFORMAT_INCLUDE_DIRS} ${AVUTIL_INCLUDE_DIRS} ${SWRESAMPLE_INCLUDE_DIRS})
  target_link_libraries(essentia PUBLIC ${AVCODEC_LIBRARIES} ${AVFORMAT_LIBRARIES} ${AVUTIL_LIBRARIES} ${SWRESAMPLE_LIBRARIES})
  set(ENABLE_AUDIOLOADER ON)
  set(ENABLE_AUDIOWRITER ON)
endif()

if(ESSENTIA_USE_FFTW)
  target_link_libraries(essentia PUBLIC FFTW3::fftw3f)
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
  target_link_libraries(essentia PUBLIC yaml)
  set(ENABLE_YAML ON)
endif()

if(ESSENTIA_USE_LIBSAMPLERATE)
  target_link_libraries (essentia PUBLIC SampleRate::samplerate)
  set(ENABLE_SAMPLERATE ON)
endif()

if(ESSENTIA_USE_TAGLIB)
  target_link_libraries (essentia PUBLIC TagLib::tag)
  set(ENABLE_TAGLIB ON)
endif()

if(ESSENTIA_USE_CHROMAPRINT)
  target_link_libraries (essentia PUBLIC Chromaprint::chromaprint)
  add_compile_definitions(HAVE_LIBCHROMAPRINT)
  set(ENABLE_CHROMAPRINT ON)
endif()

if(ESSENTIA_USE_TENSORFLOW)
  target_link_libraries(essentia PUBLIC TensorFlow::tensorflow)
  set(ENABLE_TENSORFLOW ON)
endif()

if(ESSENTIA_USE_GAIA2)
  target_link_libraries(essentia PUBLIC Gaia2::gaia2 Qt5::Core Qt5::Concurrent)
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

# VAMP plugin
if(ESSENTIA_USE_VAMP)
  add_library(vamp_essentia SHARED
    examples/vampplugins.cpp
    examples/vamppluginsextra.cpp
    examples/vampwrapper.cpp
    examples/vampeasywrapper.h
    examples/vampwrapper.h)
  target_link_libraries(vamp_essentia PRIVATE essentia VampSdk::vamp)
  if(BUILD_SHARED_LIBS)
    target_compile_definitions(vamp_essentia PUBLIC ESSENTIA_EXPORTS=0)
  endif()
endif()
