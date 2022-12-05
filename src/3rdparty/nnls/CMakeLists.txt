target_sources(essentia
  PRIVATE
    nnls.c
  PUBLIC
    nnls.h)

target_include_directories(essentia PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
