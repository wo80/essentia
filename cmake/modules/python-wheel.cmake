include(python-wheel-globals)

set(PY_WHEEL_SETUP_FILE "${CMAKE_CURRENT_LIST_DIR}/setup.py.in" CACHE INTERNAL "")

# Target for building all added wheels
add_custom_target(wheel ALL)

# Function for transforming a CMake string array LIST
# to a python array OUT (without brackets).
macro (to_python_list_string LIST OUT)
  list(TRANSFORM ${LIST} PREPEND "'")
  list(TRANSFORM ${LIST} APPEND "'")
  list(JOIN ${LIST} ", " ${OUT})
endmacro()

# Copy SOURCE's target file, or if SOURCE is an interface-lib:
# all linked target files to the destination DEST. Add the
# command to the target TARGET.
function (_copy_target TARGET SOURCE DEST)
  get_target_property(source_type ${SOURCE} TYPE)

  if (source_type STREQUAL "INTERFACE_LIBRARY")
    get_target_property(source_libs ${SOURCE} INTERFACE_LINK_LIBRARIES)
    foreach (source_lib IN LISTS source_libs)
      add_custom_command(TARGET ${TARGET}
        COMMAND ${CMAKE_COMMAND} -E copy "$<TARGET_FILE:${source_lib}>" "${DEST}")
    endforeach()
  else()
    add_custom_command(TARGET ${TARGET}
      COMMAND ${CMAKE_COMMAND} -E copy "$<TARGET_FILE:${SOURCE}>" "${DEST}")
  endif()
endfunction()

function (add_wheel WHEEL_TARGET)
  set(Python_FIND_VIRTUALENV FIRST) # Favor venv over system install
  find_package(Python3 COMPONENTS Interpreter Development REQUIRED)

  # Parse arguments
  cmake_parse_arguments(WHEEL
    ""
    "NAME;AUTHOR;EMAIL;URL;PYTHON_REQUIRES;VERSION;DESCRIPTION;KEYWORDS;LICENSE;PLATFORMS;README_PATH;LICENSE_PATH"
    "TARGET_DEPENDENCIES;MODULE_DEPENDENCIES;DEPLOY_PATH;DEPLOY_FILES;SUBMODULES" ${ARGN})

  to_python_list_string(WHEEL_MODULE_DEPENDENCIES WHEEL_MODULE_DEPENDENCIES_PYLIST)

  if (NOT WHEEL_VERSION)
    message(FATAL_ERROR "Missing wheel version.")
  endif()

  if (NOT WHEEL_AUTHOR)
    message(FATAL_ERROR "Missing wheel author.")
  endif()

  if (NOT WHEEL_EMAIL)
    set(WHEEL_EMAIL "")
  endif()

  if (NOT WHEEL_URL)
    set(WHEEL_URL "")
  endif()

  if (NOT WHEEL_KEYWORDS)
    set(WHEEL_KEYWORDS "")
  endif()

  if (NOT WHEEL_LICENSE)
    set(WHEEL_LICENSE "")
  endif()

  if (NOT WHEEL_PLATFORMS)
    set(WHEEL_PLATFORMS "any")
  endif()

  if (NOT WHEEL_PYTHON_REQUIRES)
    set(WHEEL_PYTHON_REQUIRES ">=3.8")
  endif()

  if (NOT WHEEL_LICENSE_PATH)
    # Default license file
    set(WHEEL_LICENSE_PATH "${CMAKE_SOURCE_DIR}/LICENSE")
  endif()

  if (NOT WHEEL_NAME)
    set(WHEEL_NAME "${WHEEL_TARGET}")
  endif()

  # Set up wheel build dir
  set(WHEEL_LIB_DIR "${CMAKE_CURRENT_BINARY_DIR}/${WHEEL_NAME}.wheel")
  set(WHEEL_PACKAGE_DIR "${WHEEL_LIB_DIR}/${WHEEL_NAME}")

  # Create the package directory and __init__.py
  file(REMOVE_RECURSE "${WHEEL_LIB_DIR}")
  file(MAKE_DIRECTORY "${WHEEL_LIB_DIR}")
  file(MAKE_DIRECTORY "${WHEEL_PACKAGE_DIR}")
  if (WHEEL_WRITE_INIT)
    file(WRITE "${WHEEL_PACKAGE_DIR}/__init__.py" "from .${WHEEL_TARGET} import *")
    foreach(SUBMODULE IN LISTS WHEEL_SUBMODULES)
      string(REPLACE "." "/" SUBMODULE_DIR ${SUBMODULE})
      file(MAKE_DIRECTORY "${WHEEL_PACKAGE_DIR}/${SUBMODULE_DIR}")
      # Create repeating dots by removing all non-dot characters from the submodule string
      string(REGEX REPLACE "[^\\.]" "" DOTS ${SUBMODULE})
      # Correctly adjust the import statement considering depth
      file(WRITE "${WHEEL_PACKAGE_DIR}/${SUBMODULE_DIR}/__init__.py" "from .${DOTS}.${WHEEL_TARGET}.${SUBMODULE} import *")
    endforeach()
  endif()

  # Only one wheel allowed per project.
  file(GLOB LOCAL_WHEEL_LIST "${CMAKE_CURRENT_BINARY_DIR}/*.wheel")
  list(LENGTH LOCAL_WHEEL_LIST LOCAL_WHEEL_LIST_LENGTH)
  if (LOCAL_WHEEL_LIST_LENGTH GREATER 1)
    message(FATAL_ERROR "You cannot create more than one wheel in the same binary dir.")
  elseif (LOCAL_WHEEL_LIST_LENGTH LESS 1)
    message(FATAL_ERROR "This should not happen.")
  endif()

  # Copy module + dependencies into build dir
  add_custom_target(${WHEEL_TARGET}-copy-files)
  _copy_target(${WHEEL_TARGET}-copy-files ${WHEEL_TARGET} "${WHEEL_PACKAGE_DIR}")
  add_dependencies(${WHEEL_TARGET}-copy-files ${WHEEL_TARGET})

  foreach (dep IN LISTS WHEEL_TARGET_DEPENDENCIES)
    if (TARGET ${dep})
      add_dependencies(${WHEEL_TARGET} ${dep})

      _copy_target(${WHEEL_TARGET}-copy-files ${dep} ${WHEEL_PACKAGE_DIR})
    else()
      message(FATAL_ERROR "Not a target ${dep}")
    endif()
  endforeach()

  if (WHEEL_LICENSE_PATH)
    add_custom_command(TARGET ${WHEEL_TARGET}-copy-files
      COMMAND ${CMAKE_COMMAND} -E copy "${WHEEL_LICENSE_PATH}" "${WHEEL_PACKAGE_DIR}/LICENSE.txt")
  endif()

  if (WHEEL_README_PATH)
    add_custom_command(TARGET ${WHEEL_TARGET}-copy-files
      COMMAND ${CMAKE_COMMAND} -E copy "${WHEEL_README_PATH}" "${WHEEL_PACKAGE_DIR}/README.txt")
  endif()

  if (WHEEL_DEPLOY_PATH)
    get_filename_component(WHEEL_PACKAGE_DIR_PARENT "${WHEEL_PACKAGE_DIR}" PATH)
    file(COPY "${WHEEL_DEPLOY_PATH}" DESTINATION "${WHEEL_PACKAGE_DIR_PARENT}/")
  endif()

  if (WHEEL_DEPLOY_FILES)
    foreach (file IN LISTS WHEEL_DEPLOY_FILES)
      add_custom_command(TARGET ${WHEEL_TARGET}-copy-files
        POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E echo "Copying file from ${file} to ${WHEEL_PACKAGE_DIR}"
        COMMAND ${CMAKE_COMMAND} -E copy "${file}" "${WHEEL_PACKAGE_DIR}/")
    endforeach()
  endif()

  set(SETUP_FILE "${CMAKE_CURRENT_BINARY_DIR}/setup.py")
  configure_file("${PY_WHEEL_SETUP_FILE}" "${SETUP_FILE}")

  add_custom_target(${WHEEL_TARGET}-setup-py
    COMMAND
      "${Python3_EXECUTABLE}" "-m" "pip" "wheel"
        "${CMAKE_CURRENT_BINARY_DIR}"
        "--no-deps"
        "-w" "${WHEEL_DEPLOY_DIRECTORY}")

  add_dependencies(${WHEEL_TARGET}-setup-py ${WHEEL_TARGET}-copy-files ${WHEEL_TARGET})

  add_dependencies(wheel ${WHEEL_TARGET}-setup-py)
endfunction()
