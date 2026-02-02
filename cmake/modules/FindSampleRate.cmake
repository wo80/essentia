# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENSE.rst or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindSampleRate
-------

Finds the SampleRate library, https://github.com/libsndfile/libsamplerate.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``SampleRate::samplerate``
  The SampleRate library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``SampleRate_FOUND``
  True if the system has the SampleRate library.
``SampleRate_VERSION``
  The version of the SampleRate library which was found.
``SampleRate_INCLUDE_DIRS``
  Include directories needed to use SampleRate.
``SampleRate_LIBRARIES``
  Libraries needed to link to SampleRate.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``SampleRate_INCLUDE_DIR``
  The directory containing ``samplerate.h``.
``SampleRate_LIBRARY``
  The path to the SampleRate library.

#]=======================================================================]

find_package(PkgConfig QUIET)

if (PKG_CONFIG_FOUND)
  pkg_check_modules(PC_SampleRate samplerate QUIET)
endif ()

find_path(SampleRate_INCLUDE_DIR
  NAMES samplerate.h
  HINTS ${PC_SampleRate_INCLUDE_DIRS}
)

find_library(SampleRate_LIBRARY
  NAMES samplerate
  HINTS ${PC_SampleRate_LIBRARY_DIRS}
)

set(SampleRate_VERSION ${PC_SampleRate_VERSION})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(SampleRate
  REQUIRED_VARS
    SampleRate_LIBRARY
    SampleRate_INCLUDE_DIR
  VERSION_VAR
    SampleRate_VERSION
)

if(SampleRate_FOUND)
  set(SampleRate_LIBRARIES ${SampleRate_LIBRARY})
  set(SampleRate_INCLUDE_DIRS ${SampleRate_INCLUDE_DIR})
  set(SampleRate_DEFINITIONS ${PC_SampleRate_CFLAGS_OTHER})
endif()

if(SampleRate_FOUND AND NOT TARGET SampleRate::samplerate)
  add_library(SampleRate::samplerate UNKNOWN IMPORTED)
  set_target_properties(SampleRate::samplerate PROPERTIES
    IMPORTED_LOCATION "${SampleRate_LIBRARY}"
    INTERFACE_COMPILE_OPTIONS "${PC_SampleRate_CFLAGS_OTHER}"
    INTERFACE_INCLUDE_DIRECTORIES "${SampleRate_INCLUDE_DIR}"
  )
endif()
