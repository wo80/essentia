include(FindPackageHandleStandardArgs)

if (NOT WIN32)
    find_package(PkgConfig)
    if (PKG_CONFIG_FOUND)
         pkg_check_modules(PKG_LIBYAML libyaml)
    endif ()
endif (NOT WIN32)

find_path(YAML_INCLUDE_DIR yaml.h
    ${PKG_LIBYAML_INCLUDE_DIRS}
    /usr/include
    /usr/local/include
)

find_library(YAML_LIBRARIES
    NAMES
    yaml yaml.dll
    PATHS
    ${PKG_LIBYAML_LIBRARY_DIRS}
    /usr/lib
    /usr/local/lib
)

find_package_handle_standard_args(YAML DEFAULT_MSG YAML_LIBRARIES YAML_INCLUDE_DIR)
