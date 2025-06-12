# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENSE.rst or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindFFTW3f
-------

Finds the FFTW3f library, https://fftw.org.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``FFTW3::fftw3f``
  The FFTW3f library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``FFTW3f_FOUND``
  True if the system has the FFTW3f library.
``FFTW3f_VERSION``
  The version of the FFTW3f library which was found.
``FFTW3f_INCLUDE_DIRS``
  Include directories needed to use FFTW3f.
``FFTW3f_LIBRARIES``
  Libraries needed to link to FFTW3f.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``FFTW3f_INCLUDE_DIR``
  The directory containing ``fftw3f.h``.
``FFTW3f_LIBRARY``
  The path to the FFTW3f library.

#]=======================================================================]

find_package(PkgConfig QUIET)

if (PKG_CONFIG_FOUND)
  pkg_check_modules(PC_FFTW3f fftw3f QUIET)
endif ()

find_path(FFTW3f_INCLUDE_DIR
  NAMES fftw3.h
  HINTS ${PC_FFTW3f_INCLUDE_DIRS}
)

find_library(FFTW3f_LIBRARY
  NAMES libfftw3f fftw3f
  HINTS ${PC_FFTW3f_LIBRARY_DIRS}
)

set(FFTW3f_VERSION ${PC_FFTW3f_VERSION})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(FFTW3f
  REQUIRED_VARS
    FFTW3f_LIBRARY
    FFTW3f_INCLUDE_DIR
  VERSION_VAR
    FFTW3f_VERSION
)

if(FFTW3f_FOUND)
  set(FFTW3f_LIBRARIES ${FFTW3f_LIBRARY})
  set(FFTW3f_INCLUDE_DIRS ${FFTW3f_INCLUDE_DIR})
  set(FFTW3f_DEFINITIONS ${PC_FFTW3f_CFLAGS_OTHER})
endif()

if(FFTW3f_FOUND AND NOT TARGET FFTW3::fftw3f)
  add_library(FFTW3::fftw3f UNKNOWN IMPORTED)
  set_target_properties(FFTW3::fftw3f PROPERTIES
    IMPORTED_LOCATION "${FFTW3f_LIBRARY}"
    INTERFACE_COMPILE_OPTIONS "${PC_FFTW3f_CFLAGS_OTHER}"
    INTERFACE_INCLUDE_DIRECTORIES "${FFTW3f_INCLUDE_DIR}"
  )
endif()
