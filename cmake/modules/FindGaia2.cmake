include(FindPackageHandleStandardArgs)

if (NOT WIN32)
    find_package(PkgConfig)
    if (PKG_CONFIG_FOUND)
         pkg_check_modules(PKG_LIBGAIA2 libgaia2)
    endif ()
endif (NOT WIN32)

find_path(GAIA2_INCLUDE_DIR gaia2/gaia.h
    ${PKG_LIBGAIA2_INCLUDE_DIRS}
    /usr/include
    /usr/local/include
)

find_library(GAIA2_LIBRARIES
    NAMES
    gaia2 gaia2.dll
    PATHS
    ${PKG_LIBGAIA2_LIBRARY_DIRS}
    /usr/lib
    /usr/local/lib
)

find_package_handle_standard_args(Gaia2 DEFAULT_MSG GAIA2_LIBRARIES GAIA2_INCLUDE_DIR)
