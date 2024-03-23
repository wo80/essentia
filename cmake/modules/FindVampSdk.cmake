include(FindPackageHandleStandardArgs)

find_package(PkgConfig QUIET)
if (PKG_CONFIG_FOUND)
  pkg_check_modules(VAMPSDK vamp-sdk QUIET)
endif ()

if ( VAMPSDK_INCLUDEDIR AND NOT VAMPSDK_INCLUDE_DIRS )
  set (VAMPSDK_INCLUDE_DIRS ${VAMPSDK_INCLUDEDIR})
endif ()

if ( NOT VAMPSDK_FOUND )
  find_path(VAMPSDK_INCLUDE_DIRS NAMES vamp-sdk.h PATH_SUFFIXES vamp-sdk)
  find_library(VAMPSDK_LIBRARIES NAMES vamp-sdk libvamp-sdk VampPluginSDK)

  if ( NOT "${VAMPSDK_LIBRARIES}" STREQUAL "")
    set (VAMPSDK_FOUND TRUE)
    set (VAMPSDK_LINK_LIBRARIES ${VAMPSDK_LINK_LIBRARIES} ${VAMPSDK_LIBRARIES})
  endif ()
endif ()

find_package_handle_standard_args(VampSdk
  FOUND_VAR
    VAMPSDK_FOUND
  REQUIRED_VARS
    VAMPSDK_LINK_LIBRARIES
    VAMPSDK_INCLUDE_DIRS
  VERSION_VAR
    VAMPSDK_VERSION)
