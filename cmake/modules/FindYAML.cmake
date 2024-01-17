include(FindPackageHandleStandardArgs)

if (NOT WIN32)
  find_package(PkgConfig)
  if (PKG_CONFIG_FOUND)
    pkg_check_modules(YAML yaml-0.1)
  endif ()
endif (NOT WIN32)

if ( NOT YAML_FOUND )
  find_path(YAML_INCLUDE_DIRS NAMES yaml.h)
  find_library(YAML_LIBRARIES NAMES yaml)

  if ( NOT "${YAML_LIBRARIES}" STREQUAL "")
    set (YAML_FOUND TRUE)
    set (YAML_LINK_LIBRARIES ${YAML_LINK_LIBRARIES} ${YAML_LIBRARIES})
  endif ()
endif ()

if ( YAML_INCLUDEDIR AND NOT YAML_INCLUDE_DIRS )
  set (YAML_INCLUDE_DIRS ${YAML_INCLUDEDIR})
endif ()

find_package_handle_standard_args(YAML DEFAULT_MSG YAML_LIBRARIES YAML_INCLUDE_DIRS)

if ( YAML_FOUND AND NOT TARGET yaml )
  add_library(yaml INTERFACE IMPORTED GLOBAL)
  set_target_properties(yaml
    PROPERTIES
      VERSION "${YAML_VERSION}"
      LOCATION "${YAML_LINK_LIBRARIES}"
      INTERFACE_INCLUDE_DIRECTORIES "${YAML_INCLUDE_DIRS}"
      INTERFACE_LINK_LIBRARIES "${YAML_LINK_LIBRARIES}")
endif ()
