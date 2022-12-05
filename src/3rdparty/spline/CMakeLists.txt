target_sources(essentia
  PRIVATE
    splineutil.cpp
  PUBLIC
    splineutil.h)

target_include_directories(essentia PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
