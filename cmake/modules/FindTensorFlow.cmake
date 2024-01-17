include(FindPackageHandleStandardArgs)

if (NOT WIN32)
    find_package(PkgConfig)
    if (PKG_CONFIG_FOUND)
         pkg_check_modules(TENSORFLOW libtensorflow)
    endif ()
endif (NOT WIN32)

if ( NOT TENSORFLOW_FOUND )
  find_path(TENSORFLOW_INCLUDE_DIRS NAMES tensorflow/c/c_api.h)
  find_library(TENSORFLOW_LIBRARIES NAMES tensorflow)

  if ( NOT "${TENSORFLOW_LIBRARIES}" STREQUAL "")
    set (TENSORFLOW_FOUND TRUE)
    set (TENSORFLOW_LINK_LIBRARIES ${TENSORFLOW_LINK_LIBRARIES} ${TENSORFLOW_LIBRARIES})
  endif ()
endif ()

find_package_handle_standard_args(TensorFlow DEFAULT_MSG TENSORFLOW_LIBRARIES TENSORFLOW_INCLUDE_DIRS)
