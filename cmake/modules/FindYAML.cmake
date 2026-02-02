# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENSE.rst or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindYaml
-------

Finds the yaml library, https://github.com/yaml/libyaml.

Imported Targets
^^^^^^^^^^^^^^^^

This module provides the following imported targets, if found:

``yaml``
  The yaml library

Result Variables
^^^^^^^^^^^^^^^^

This will define the following variables:

``yaml_FOUND``
  True if the system has the yaml library.
``yaml_VERSION``
  The version of the yaml library which was found.
``yaml_INCLUDE_DIRS``
  Include directories needed to use yaml.
``yaml_LIBRARIES``
  Libraries needed to link to yaml.

Cache Variables
^^^^^^^^^^^^^^^

The following cache variables may also be set:

``yaml_INCLUDE_DIR``
  The directory containing ``yaml.h``.
``yaml_LIBRARY``
  The path to the Yaml library.

#]=======================================================================]

find_package(PkgConfig QUIET)

if (PKG_CONFIG_FOUND)
  pkg_check_modules(PC_YAML yaml-0.1 QUIET)
endif ()

find_path(yaml_INCLUDE_DIR
  NAMES yaml.h
  HINTS ${PC_YAML_INCLUDE_DIRS}
)

find_library(yaml_LIBRARY
  NAMES yaml
  HINTS ${PC_YAML_LIBRARY_DIRS}
)

set(yaml_VERSION ${PC_YAML_VERSION})

include(FindPackageHandleStandardArgs)

find_package_handle_standard_args(Yaml
  REQUIRED_VARS
    yaml_LIBRARY
    yaml_INCLUDE_DIR
  VERSION_VAR
    yaml_VERSION
)

if(Yaml_FOUND)
  set(yaml_FOUND TRUE)
  set(yaml_LIBRARIES ${yaml_LIBRARY})
  set(yaml_INCLUDE_DIRS ${yaml_INCLUDE_DIR})
  set(yaml_DEFINITIONS ${PC_YAML_CFLAGS_OTHER})
endif()

if(yaml_FOUND AND NOT TARGET yaml)
  add_library(yaml UNKNOWN IMPORTED)
  set_target_properties(yaml PROPERTIES
    IMPORTED_LOCATION "${yaml_LIBRARY}"
    INTERFACE_COMPILE_OPTIONS "${PC_YAML_CFLAGS_OTHER}"
    INTERFACE_INCLUDE_DIRECTORIES "${yaml_INCLUDE_DIR}"
  )
endif()
