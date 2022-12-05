include(FindPackageHandleStandardArgs)

if (NOT WIN32)
    find_package(PkgConfig)
    if (PKG_CONFIG_FOUND)
         pkg_check_modules(PKG_LIBTENSORFLOW libtensorflow)
    endif ()
endif (NOT WIN32)

find_path(TensorFlow_INCLUDE_DIR tensorflow/c/c_api.h
    ${PKG_LIBTENSORFLOW_INCLUDE_DIRS}
    /usr/include
    /usr/local/include
)

find_library(TensorFlow_LIBRARY
    NAMES
    tensorflow tensorflow.dll
    PATHS
    ${PKG_LIBTENSORFLOW_LIBRARY_DIRS}
    /usr/lib
    /usr/local/lib
)

find_package_handle_standard_args(TensorFlow DEFAULT_MSG TensorFlow_LIBRARY TensorFlow_INCLUDE_DIR)
