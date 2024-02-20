include(FindPackageHandleStandardArgs)

if (NOT WIN32)
    find_package(PkgConfig)
    if (PKG_CONFIG_FOUND)
         pkg_check_modules(GAIA2 libgaia2)
    endif ()
endif (NOT WIN32)

if ( NOT GAIA2_FOUND )
  find_path(GAIA2_INCLUDE_DIRS NAMES gaia2/gaia.h)
  find_library(GAIA2_LIBRARIES NAMES gaia2)

  if ( NOT "${GAIA2_LIBRARIES}" STREQUAL "")
    set (GAIA2_FOUND TRUE)
    set (GAIA2_LINK_LIBRARIES ${GAIA2_LINK_LIBRARIES} ${GAIA2_LIBRARIES})
  endif ()
endif ()

find_package_handle_standard_args(Gaia2 DEFAULT_MSG GAIA2_LIBRARIES GAIA2_INCLUDE_DIRS)
