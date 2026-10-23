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
  tonal
)

if(ESSENTIA_USE_TENSORFLOW)
  target_sources(essentia
    PRIVATE
      machinelearning/tensorflowpredict.cpp
      machinelearning/tensorflowpredict2d.cpp
      machinelearning/tensorflowpredictcrepe.cpp
      machinelearning/tensorflowpredicteffnetdiscogs.cpp
      machinelearning/tensorflowpredictfsdsinet.cpp
      machinelearning/tensorflowpredictmaest.cpp
      machinelearning/tensorflowpredictmusicnn.cpp
      machinelearning/tensorflowpredicttempocnn.cpp
      machinelearning/tensorflowpredictvggish.cpp
      machinelearning/tensorflowpredict.h
      machinelearning/tensorflowpredict2d.h
      machinelearning/tensorflowpredictcrepe.h
      machinelearning/tensorflowpredicteffnetdiscogs.h
      machinelearning/tensorflowpredictfsdsinet.h
      machinelearning/tensorflowpredictmaest.h
      machinelearning/tensorflowpredictmusicnn.h
      machinelearning/tensorflowpredicttempocnn.h
      machinelearning/tensorflowpredictvggish.h)
endif()

if(ESSENTIA_USE_ONNXRUNTIME)
  target_sources(essentia
    PRIVATE
      machinelearning/onnxpredict.cpp
      machinelearning/onnxpredict.h)
endif()

foreach(DIR IN LISTS ESSENTIA_ALGORITHMS)
  add_subdirectory(${DIR})
endforeach()

configure_file(${CMAKE_CURRENT_LIST_DIR}/essentia_algorithms_reg_2.h.in ${CMAKE_CURRENT_LIST_DIR}/essentia_algorithms_reg_2.h)

target_sources(essentia
  PRIVATE
    essentia_algorithms_reg_2.cpp
)
