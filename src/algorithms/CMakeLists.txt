set(ESSENTIA_ALGORITHMS
  audioproblems
  complex
  experimental
  extractor
  filters
  highlevel
  io
  rhythm
  sfx
  spectral
  standard
  stats
  synthesis
  temporal
  tonal)

if(ESSENTIA_USE_TENSORFLOW)
  set(ESSENTIA_ALGORITHMS ${ESSENTIA_ALGORITHMS} machinelearning)
endif()

foreach(DIR IN LISTS ESSENTIA_ALGORITHMS)
  add_subdirectory(${DIR})
endforeach()

configure_file(${CMAKE_CURRENT_LIST_DIR}/essentia_algorithms_reg_2.h.in ${CMAKE_CURRENT_LIST_DIR}/essentia_algorithms_reg_2.h)

target_sources(essentia
  PRIVATE
    essentia_algorithms_reg_2.cpp)
