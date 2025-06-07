include(FindPackageHandleStandardArgs)

find_package(PkgConfig QUIET)
if (PKG_CONFIG_FOUND)
  pkg_check_modules(Gaia2 gaia2 QUIET)
endif ()

if ( NOT Gaia2_FOUND )
  find_path(Gaia2_INCLUDE_DIRS NAMES gaia2/gaia.h)
  find_library(Gaia2_LIBRARIES NAMES gaia2)
  find_library(Gaia2_LIBRARIES_DEBUG NAMES gaia2_d)

  if (Gaia2_LIBRARIES)
    set (Gaia2_FOUND TRUE)
    set (Gaia2_LINK_LIBRARIES ${Gaia2_LINK_LIBRARIES} ${Gaia2_LIBRARIES})
  elseif (Gaia2_LIBRARIES_DEBUG)
    set (Gaia2_FOUND TRUE)
    set (Gaia2_LINK_LIBRARIES ${Gaia2_LINK_LIBRARIES} ${Gaia2_LIBRARIES_DEBUG})
  endif ()
endif ()

if ( Gaia2_INCLUDE_DIRS )
  # Gaia headers do not use relative paths to include headers from its
  # sub-directories, so this needs to be fixed manually
  set(_Gaia2_INCLUDE_DIR "${Gaia2_INCLUDE_DIRS}")
  list(APPEND Gaia2_INCLUDE_DIRS "${_Gaia2_INCLUDE_DIR}/gaia2/algorithms")
  list(APPEND Gaia2_INCLUDE_DIRS "${_Gaia2_INCLUDE_DIR}/gaia2/metrics")
  list(APPEND Gaia2_INCLUDE_DIRS "${_Gaia2_INCLUDE_DIR}/gaia2/parser")
  set(_Gaia2_INCLUDE_DIR)
endif ()

find_package_handle_standard_args(Gaia2
  FOUND_VAR
    Gaia2_FOUND
  REQUIRED_VARS
    Gaia2_LINK_LIBRARIES
    Gaia2_INCLUDE_DIRS
  VERSION_VAR
    Gaia2_VERSION)
