target_sources(essentia
  PRIVATE
    network.cpp
    networkparser.cpp
  PUBLIC
    graphutils.h
    network.h
    networkparser.h)

target_include_directories(essentia PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
