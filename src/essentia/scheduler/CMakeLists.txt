target_sources(essentia
  PRIVATE
    network.cpp
    networkparser.cpp
    graphutils.h
    network.h
    networkparser.h
)

target_include_directories(essentia
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)
