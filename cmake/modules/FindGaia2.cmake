# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENSE.rst or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindGaia2
-------

Finds the Gaia2 library, https://github.com/MTG/gaia.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``Gaia2::gaia2``
  The Gaia2 library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``Gaia2_FOUND``
  True if the system has the Gaia2 library.
``Gaia2_VERSION``
  The version of the Gaia2 library which was found.
``Gaia2_INCLUDE_DIRS``
  Include directories needed to use Gaia2.
``Gaia2_LIBRARIES``
  Libraries needed to link to Gaia2.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``Gaia2_INCLUDE_DIR``
  The directory containing ``gaia2.h``.
``Gaia2_LIBRARY``
  The path to the Gaia2 library.

#]=======================================================================]

find_package(PkgConfig QUIET)

if (PKG_CONFIG_FOUND)
  pkg_check_modules(PC_Gaia2 libgaia2 QUIET)
endif ()

find_path(Gaia2_INCLUDE_DIR
  NAMES gaia2/gaia.h
  HINTS ${PC_Gaia2_INCLUDE_DIRS}
)

find_library(Gaia2_LIBRARY_RELEASE
  NAMES gaia2
  HINTS ${PC_Gaia2_LIBRARY_DIRS}
)
find_library(Gaia2_LIBRARY_DEBUG
  NAMES gaia2_d
  HINTS ${PC_Gaia2_LIBRARY_DIRS}
)

include(SelectLibraryConfigurations)
select_library_configurations(Gaia2)

set(Gaia2_VERSION ${PC_Gaia2_VERSION})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(Gaia2
  REQUIRED_VARS
    Gaia2_LIBRARY
    Gaia2_INCLUDE_DIR
  VERSION_VAR
    Gaia2_VERSION
)

if(Gaia2_FOUND)
  # Gaia headers do not use relative paths to include headers from its
  # sub-directories, so this needs to be fixed manually
  set(gaia_include_dir "${Gaia2_INCLUDE_DIR}")
  list(APPEND Gaia2_INCLUDE_DIR "${gaia_include_dir}/gaia2/algorithms")
  list(APPEND Gaia2_INCLUDE_DIR "${gaia_include_dir}/gaia2/metrics")
  list(APPEND Gaia2_INCLUDE_DIR "${gaia_include_dir}/gaia2/parser")
  set(gaia_include_dir)

  set(Gaia2_LIBRARIES ${Gaia2_LIBRARY})
  set(Gaia2_INCLUDE_DIRS ${Gaia2_INCLUDE_DIR})
  set(Gaia2_DEFINITIONS ${PC_Gaia2_CFLAGS_OTHER})
endif()

if(Gaia2_FOUND AND NOT TARGET Gaia2::gaia2)
  if (NOT TARGET Gaia2::gaia2)
    add_library(Gaia2::gaia2 UNKNOWN IMPORTED)
  endif()
  if (Gaia2_LIBRARY_RELEASE)
    set_property(TARGET Gaia2::gaia2 APPEND PROPERTY
      IMPORTED_CONFIGURATIONS RELEASE
    )
    set_target_properties(Gaia2::gaia2 PROPERTIES
      IMPORTED_LOCATION_RELEASE "${Gaia2_LIBRARY_RELEASE}"
    )
  endif()
  if (Gaia2_LIBRARY_DEBUG)
    set_property(TARGET Gaia2::gaia2 APPEND PROPERTY
      IMPORTED_CONFIGURATIONS DEBUG
    )
    set_target_properties(Gaia2::gaia2 PROPERTIES
      IMPORTED_LOCATION_DEBUG "${Gaia2_LIBRARY_DEBUG}"
    )
  endif()
  set_target_properties(Gaia2::gaia2 PROPERTIES
    INTERFACE_COMPILE_OPTIONS "${PC_Gaia2_CFLAGS_OTHER}"
    INTERFACE_INCLUDE_DIRECTORIES "${Gaia2_INCLUDE_DIR}"
  )
endif()