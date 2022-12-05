include(FindPackageHandleStandardArgs)

if (NOT WIN32)
    find_package(PkgConfig)
    if (PKG_CONFIG_FOUND)
         pkg_check_modules(PKG_LIBSAMPLERATE libsamplerate)
    endif ()
endif (NOT WIN32)

find_path(SAMPLERATE_INCLUDE_DIR samplerate.h
    ${PKG_LIBSAMPLERATE_INCLUDE_DIRS}
    /usr/include
    /usr/local/include
)

find_library(SAMPLERATE_LIBRARIES
    NAMES
    samplerate samplerate.dll
    PATHS
    ${PKG_LIBSAMPLERATE_LIBRARY_DIRS}
    /usr/lib
    /usr/local/lib
)

find_package_handle_standard_args(SampleRate DEFAULT_MSG SAMPLERATE_LIBRARIES SAMPLERATE_INCLUDE_DIR)
