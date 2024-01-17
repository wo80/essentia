include(FindPackageHandleStandardArgs)

if (NOT WIN32)
    find_package(PkgConfig)
    if (PKG_CONFIG_FOUND)
         pkg_check_modules(VAMPSDK vamp-sdk)
    endif ()
endif (NOT WIN32)

if ( VAMPSDK_INCLUDEDIR AND NOT VAMPSDK_INCLUDE_DIRS )
  set (VAMPSDK_INCLUDE_DIRS ${VAMPSDK_INCLUDEDIR})
endif ()

if ( NOT VAMPSDK_FOUND )
  find_path(VAMPSDK_INCLUDE_DIRS NAMES vamp-sdk.h PATH_SUFFIXES vamp-sdk)
  find_library(VAMPSDK_LIBRARIES NAMES libvamp-sdk VampPluginSDK)

  if ( NOT "${VAMPSDK_LIBRARIES}" STREQUAL "")
    set (VAMPSDK_FOUND TRUE)
    set (VAMPSDK_LINK_LIBRARIES ${VAMPSDK_LINK_LIBRARIES} ${VAMPSDK_LIBRARIES})
  endif ()
endif ()

find_package_handle_standard_args(VampSdk DEFAULT_MSG VAMPSDK_LIBRARIES VAMPSDK_INCLUDE_DIRS)
