include(GoogleTest)

add_subdirectory("${PROJECT_SOURCE_DIR}/test/3rdparty/googletest" "test/3rdparty/googletest")

set(BUILD_GMOCK OFF CACHE BOOL "" FORCE)
set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)
mark_as_advanced(BUILD_GMOCK INSTALL_GTEST GTEST_HAS_ABSL)

set_target_properties(gtest PROPERTIES FOLDER extern)
set_target_properties(gtest_main PROPERTIES FOLDER extern)

add_executable(essentia_tests 
  test_audioloader.cpp
  test_composite.cpp
  test_connectors.cpp
  test_copy.cpp
  test_fileoutput.cpp
  test_math.cpp
  test_network.cpp
  test_networkparser.cpp
  test_parameter.cpp
  test_peak.cpp
  test_pool.cpp
  test_scheduler.cpp
  test_stringutil.cpp
  test_treetraversal.cpp
  test_vectorinput.cpp
  test_vectoroutput.cpp
  test_main.cpp)

if(MSVC)
  target_compile_options(essentia_tests PRIVATE /MP)
  if(BUILD_SHARED_LIBS)
    target_compile_definitions(essentia_tests PUBLIC ESSENTIA_EXPORTS=0)
  endif()
endif()

target_link_libraries(essentia_tests PRIVATE gtest gtest_main essentia)

gtest_discover_tests(essentia_tests
  WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
  PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
)
set_target_properties(essentia_tests PROPERTIES FOLDER tests)
