# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENSE.rst or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindOnnxRuntime
-------

Finds the OnnxRuntime library, https://onnxruntime.ai.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``OnnxRuntime::onnxruntime``
  The OnnxRuntime library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``OnnxRuntime_FOUND``
  True if the system has the OnnxRuntime library.
``OnnxRuntime_VERSION``
  The version of the OnnxRuntime library which was found.
``OnnxRuntime_INCLUDE_DIRS``
  Include directories needed to use OnnxRuntime.
``OnnxRuntime_LIBRARIES``
  Libraries needed to link to OnnxRuntime.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``OnnxRuntime_INCLUDE_DIR``
  The directory containing ``onnxruntime_cxx_api.h``.
``OnnxRuntime_LIBRARY``
  The path to the OnnxRuntime library.

#]=======================================================================]

find_package(PkgConfig QUIET)

if (PKG_CONFIG_FOUND)
  pkg_check_modules(PC_OnnxRuntime libonnxruntime QUIET)
endif ()

find_path(OnnxRuntime_INCLUDE_DIR
  NAMES onnxruntime_cxx_api.h
  HINTS ${PC_OnnxRuntime_INCLUDE_DIRS}
  PATH_SUFFIXES onnxruntime
)

find_library(OnnxRuntime_LIBRARY
  NAMES
    onnxruntime
    libonnxruntime
  HINTS ${PC_OnnxRuntime_LIBRARY_DIRS}
)

set(OnnxRuntime_VERSION ${PC_OnnxRuntime_VERSION})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(OnnxRuntime
  REQUIRED_VARS
    OnnxRuntime_LIBRARY
    OnnxRuntime_INCLUDE_DIR
  VERSION_VAR
    OnnxRuntime_VERSION
)

if(OnnxRuntime_FOUND)
  set(OnnxRuntime_LIBRARIES ${OnnxRuntime_LIBRARY})
  set(OnnxRuntime_INCLUDE_DIRS ${OnnxRuntime_INCLUDE_DIR})
  set(OnnxRuntime_DEFINITIONS ${PC_OnnxRuntime_CFLAGS_OTHER})
endif()

if(OnnxRuntime_FOUND AND NOT TARGET OnnxRuntime::onnxruntime)
  add_library(OnnxRuntime::onnxruntime UNKNOWN IMPORTED)
  set_target_properties(OnnxRuntime::onnxruntime PROPERTIES
    IMPORTED_LOCATION "${OnnxRuntime_LIBRARY}"
    INTERFACE_COMPILE_OPTIONS "${PC_OnnxRuntime_CFLAGS_OTHER}"
    INTERFACE_INCLUDE_DIRECTORIES "${OnnxRuntime_INCLUDE_DIR}"
  )
endif()
