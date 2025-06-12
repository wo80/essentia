# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENSE.rst or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindVampSdk
-------

Finds the Vamp SDK library, https://github.com/vamp-plugins/vamp-plugin-sdk.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``VampSdk::vamp``
  The Vamp SDK library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``VampSdk_FOUND``
  True if the system has the Vamp SDK library.
``VampSdk_VERSION``
  The version of the Vamp SDK library which was found.
``VampSdk_INCLUDE_DIRS``
  Include directories needed to use Vamp SDK.
``VampSdk_LIBRARIES``
  Libraries needed to link to Vamp SDK.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``VampSdk_INCLUDE_DIR``
  The directory containing ``vamp.h``.
``VampSdk_LIBRARY``
  The path to the Vamp SDK library.

#]=======================================================================]

find_package(PkgConfig QUIET)

if (PKG_CONFIG_FOUND)
  pkg_check_modules(PC_VampSdk vamp-sdk QUIET)
endif ()

find_path(VampSdk_INCLUDE_DIR
  NAMES vamp-sdk.h
  PATH_SUFFIXES vamp-sdk
  HINTS ${PC_VampSdk_INCLUDE_DIRS}
)

find_library(VampSdk_LIBRARY
  NAMES vamp-sdk libvamp-sdk VampPluginSDK
  HINTS ${PC_VampSdk_LIBRARY_DIRS}
)

set(VampSdk_VERSION ${PC_VampSdk_VERSION})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(VampSdk
  REQUIRED_VARS
    VampSdk_LIBRARY
    VampSdk_INCLUDE_DIR
  VERSION_VAR
    VampSdk_VERSION
)

if(VampSdk_FOUND)
  set(VampSdk_LIBRARIES ${VampSdk_LIBRARY})
  set(VampSdk_INCLUDE_DIRS ${VampSdk_INCLUDE_DIR})
  set(VampSdk_DEFINITIONS ${PC_VampSdk_CFLAGS_OTHER})
endif()

if(VampSdk_FOUND AND NOT TARGET VampSdk::vamp)
  add_library(VampSdk::vamp UNKNOWN IMPORTED)
  set_target_properties(VampSdk::vamp PROPERTIES
    IMPORTED_LOCATION "${VampSdk_LIBRARY}"
    INTERFACE_COMPILE_OPTIONS "${PC_VampSdk_CFLAGS_OTHER}"
    INTERFACE_INCLUDE_DIRECTORIES "${VampSdk_INCLUDE_DIR}"
  )
endif()
