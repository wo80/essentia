include(FindPackageHandleStandardArgs)

if (NOT WIN32)
    find_package(PkgConfig)
    if (PKG_CONFIG_FOUND)
         pkg_check_modules(PKG_LIBCHROMAPRINT libchromaprint)
    endif ()
endif (NOT WIN32)

find_path(CHROMAPRINT_INCLUDE_DIR chromaprint.h
    ${PKG_LIBCHROMAPRINT_INCLUDE_DIRS}
    /usr/include
    /usr/local/include
)

find_library(CHROMAPRINT_LIBRARIES
    NAMES
    chromaprint chromaprint.dll
    PATHS
    ${PKG_LIBCHROMAPRINT_LIBRARY_DIRS}
    /usr/lib
    /usr/local/lib
)

find_package_handle_standard_args(Chromaprint DEFAULT_MSG CHROMAPRINT_LIBRARIES CHROMAPRINT_INCLUDE_DIR)
