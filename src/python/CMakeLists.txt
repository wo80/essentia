file (GLOB PYTYPES_SOURCES "pytypes/*.cpp")

add_library(_essentia SHARED essentia.cpp parsing.cpp ${PYTYPES_SOURCES})

target_include_directories(_essentia PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")
target_include_directories(_essentia PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/pytypes")
target_include_directories(_essentia PRIVATE ${Python3_INCLUDE_DIRS})
target_include_directories(_essentia PRIVATE ${Python3_NumPy_INCLUDE_DIRS})

target_link_libraries(_essentia PRIVATE essentia)
target_link_libraries(_essentia PRIVATE ${Python3_LIBRARIES})
