# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENSE.rst or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindChromaprint
-------

Finds the Chromaprint library, https://github.com/acoustid/chromaprint.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``Chromaprint::chromaprint``
  The Chromaprint library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``Chromaprint_FOUND``
  True if the system has the Chromaprint library.
``Chromaprint_VERSION``
  The version of the Chromaprint library which was found.
``Chromaprint_INCLUDE_DIRS``
  Include directories needed to use Chromaprint.
``Chromaprint_LIBRARIES``
  Libraries needed to link to Chromaprint.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``Chromaprint_INCLUDE_DIR``
  The directory containing ``chromaprint.h``.
``Chromaprint_LIBRARY``
  The path to the Chromaprint library.

#]=======================================================================]

find_package(PkgConfig QUIET)

if (PKG_CONFIG_FOUND)
  pkg_check_modules(PC_Chromaprint libchromaprint QUIET)
endif ()

find_path(Chromaprint_INCLUDE_DIR
  NAMES chromaprint.h
  HINTS ${PC_Chromaprint_INCLUDE_DIRS}
)

find_library(Chromaprint_LIBRARY
  NAMES chromaprint
  HINTS ${PC_Chromaprint_LIBRARY_DIRS}
)

set(Chromaprint_VERSION ${PC_Chromaprint_VERSION})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(Chromaprint
  REQUIRED_VARS
    Chromaprint_LIBRARY
    Chromaprint_INCLUDE_DIR
  VERSION_VAR
    Chromaprint_VERSION
)

if(Chromaprint_FOUND)
  set(Chromaprint_LIBRARIES ${Chromaprint_LIBRARY})
  set(Chromaprint_INCLUDE_DIRS ${Chromaprint_INCLUDE_DIR})
  set(Chromaprint_DEFINITIONS ${PC_Chromaprint_CFLAGS_OTHER})
endif()

if(Chromaprint_FOUND AND NOT TARGET Chromaprint::chromaprint)
  add_library(Chromaprint::chromaprint UNKNOWN IMPORTED)
  set_target_properties(Chromaprint::chromaprint PROPERTIES
    IMPORTED_LOCATION "${Chromaprint_LIBRARY}"
    INTERFACE_COMPILE_OPTIONS "${PC_Chromaprint_CFLAGS_OTHER}"
    INTERFACE_INCLUDE_DIRECTORIES "${Chromaprint_INCLUDE_DIR}"
  )
endif()
