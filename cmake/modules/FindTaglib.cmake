# SPDX-FileCopyrightText: 2006 Laurent Montel <montel@kde.org>
# SPDX-FileCopyrightText: 2019 Heiko Becker <heirecka@exherbo.org>
# SPDX-FileCopyrightText: 2020 Elvis Angelaccio <elvis.angelaccio@kde.org>
#
# SPDX-License-Identifier: BSD-3-Clause

#[=======================================================================[.rst:
FindTaglib
----------

Try to find the Taglib library.

This will define the following variables:

``TAGLIB_FOUND``
      True if the system has the taglib library of at least the minimum
      version specified by the version parameter to find_package()
``TAGLIB_INCLUDE_DIRS``
      The taglib include dirs for use with target_include_directories
``TAGLIB_LIBRARIES``
      The taglib libraries for use with target_link_libraries()
``TAGLIB_VERSION``
      The version of taglib that was found

If ``TAGLIB_FOUND`` is TRUE, it will also define the following imported
target:

``Taglib::Taglib``
      The Taglib library

Since 5.72.0
#]=======================================================================]

find_package(PkgConfig QUIET)

pkg_check_modules(PC_TAGLIB QUIET taglib)

find_path(TAGLIB_INCLUDE_DIRS
    NAMES tag.h
    PATH_SUFFIXES taglib
    HINTS ${PC_TAGLIB_INCLUDEDIR}
)

find_library(TAGLIB_LIBRARIES
    NAMES tag
    HINTS ${PC_TAGLIB_LIBDIR}
)

set(TAGLIB_VERSION ${PC_TAGLIB_VERSION})

if (TAGLIB_INCLUDE_DIRS AND NOT TAGLIB_VERSION)
    if(EXISTS "${TAGLIB_INCLUDE_DIRS}/taglib.h")
        file(READ "${TAGLIB_INCLUDE_DIRS}/taglib.h" TAGLIB_H)

        string(REGEX MATCH "#define TAGLIB_MAJOR_VERSION[ ]+[0-9]+" TAGLIB_MAJOR_VERSION_MATCH ${TAGLIB_H})
        string(REGEX MATCH "#define TAGLIB_MINOR_VERSION[ ]+[0-9]+" TAGLIB_MINOR_VERSION_MATCH ${TAGLIB_H})
        string(REGEX MATCH "#define TAGLIB_PATCH_VERSION[ ]+[0-9]+" TAGLIB_PATCH_VERSION_MATCH ${TAGLIB_H})

        string(REGEX REPLACE ".*_MAJOR_VERSION[ ]+(.*)" "\\1" TAGLIB_MAJOR_VERSION "${TAGLIB_MAJOR_VERSION_MATCH}")
        string(REGEX REPLACE ".*_MINOR_VERSION[ ]+(.*)" "\\1" TAGLIB_MINOR_VERSION "${TAGLIB_MINOR_VERSION_MATCH}")
        string(REGEX REPLACE ".*_PATCH_VERSION[ ]+(.*)" "\\1" TAGLIB_PATCH_VERSION "${TAGLIB_PATCH_VERSION_MATCH}")

        set(TAGLIB_VERSION "${TAGLIB_MAJOR_VERSION}.${TAGLIB_MINOR_VERSION}.${TAGLIB_PATCH_VERSION}")
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Taglib
    FOUND_VAR
        TAGLIB_FOUND
    REQUIRED_VARS
        TAGLIB_LIBRARIES
        TAGLIB_INCLUDE_DIRS
    VERSION_VAR
        TAGLIB_VERSION
)

mark_as_advanced(TAGLIB_LIBRARIES TAGLIB_INCLUDE_DIRS)

if ( TAGLIB_FOUND AND NOT TARGET TagLib::TagLib )
  add_library(TagLib::TagLib INTERFACE IMPORTED GLOBAL)
  set_target_properties(TagLib::TagLib
    PROPERTIES
      VERSION "${TAGLIB_VERSION}"
      LOCATION "${TAGLIB_LIBRARIES}"
      INTERFACE_INCLUDE_DIRECTORIES "${TAGLIB_INCLUDE_DIRS}"
      INTERFACE_LINK_LIBRARIES "${TAGLIB_LIBRARIES}")
endif ()


if(NOT TARGET TagLib::tag)
  add_library(TagLib::tag ALIAS TagLib::TagLib)
endif()
