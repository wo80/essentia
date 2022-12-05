target_sources(essentia
  PRIVATE
    accumulatoralgorithm.cpp
    algorithms
    phantombuffer_impl.h
    sinkbase.cpp
    sourcebase.cpp
    streamingalgorithm.cpp
    streamingalgorithmcomposite.cpp
    streamingalgorithmwrapper.cpp
  PUBLIC
    accumulatoralgorithm.h
    multiratebuffer.h
    phantombuffer.h
    sink.h
    sinkbase.h
    sinkproxy.h
    source.h
    sourcebase.h
    sourceproxy.h
    streamingalgorithm.h
    streamingalgorithmcomposite.h
    streamingalgorithmwrapper.h)

target_include_directories(essentia PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(algorithms)
