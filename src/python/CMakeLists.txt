file (GLOB PYTYPES_SOURCES "pytypes/*.cpp")

add_library(_essentia SHARED essentia.cpp parsing.cpp ${PYTYPES_SOURCES})

target_include_directories(_essentia PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}"
  "${CMAKE_CURRENT_SOURCE_DIR}/pytypes"
  "${Python3_INCLUDE_DIRS}"
  "${Python3_NumPy_INCLUDE_DIRS}")

target_link_libraries(_essentia PRIVATE essentia ${Python3_LIBRARIES})

set(WHEEL_DEPLOY_DIRECTORY "${CMAKE_BINARY_DIR}/wheel")

include(python-wheel)


if (MSVC)
  # On Windows, the file extension should be .pyd, see
  # https://docs.python.org/3/faq/windows.html#is-a-pyd-file-the-same-as-a-dll
  set_target_properties(_essentia
    PROPERTIES
      OUTPUT_NAME "_essentia.cp${Python3_VERSION_MAJOR}${Python3_VERSION_MINOR}-${PY_WHEEL_PLATFORM}"
      SUFFIX ".pyd")
else()
  # Make sure to not add "lib" prefix on Linux
  set_target_properties(_essentia PROPERTIES PREFIX "")
endif()

string(REPLACE "-beta" "b" WHL_VERSION ${essentia_VERSION_STRING})
string(REPLACE "-dev" ".dev" WHL_VERSION ${WHL_VERSION})

add_wheel(_essentia
  NAME "essentia"
  VERSION "${WHL_VERSION}"
  AUTHOR "Dmitry Bogdanov"
  EMAIL "dmitry.bogdanov@upf.edu"
  URL "http://essentia.upf.edu"
  PYTHON_REQUIRES ">=3.8"
  DESCRIPTION "Library for audio and music analysis, description and synthesis."
  KEYWORDS "audio music sound dsp MIR"
  LICENSE "AGPLv3"
  DEPLOY_PATH "${CMAKE_CURRENT_SOURCE_DIR}/essentia"
  README_PATH "${CMAKE_SOURCE_DIR}/README.md"
  LICENSE_PATH "${CMAKE_SOURCE_DIR}/COPYING.txt"
  MODULE_DEPENDENCIES "numpy>=1.8.2,<2.0" "pyyaml" "six")
