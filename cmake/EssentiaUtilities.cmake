macro(essentia_package_info name target)
  if(TARGET ${target})
    get_target_property(location ${target} LOCATION)
    if(${location} MATCHES "-NOTFOUND")
      get_target_property(location ${target} IMPORTED_LOCATION)
    endif()
    if(${location} MATCHES "-NOTFOUND")
      get_target_property(location ${target} INTERFACE_LINK_LIBRARIES)
    endif()
    if(${name}_CONFIG)
      message(STATUS "Found [config] ${name}: ${location} (found version \"${${name}_VERSION}\")")
    else()
      message(STATUS "Found [module] ${name}: ${location} (found version \"${${name}_VERSION}\")")
    endif()
  endif()
endmacro()

macro(essentia_check_set name)
  string(TOUPPER ${${name}} NAME_UPPER)

  if( "${NAME_UPPER}" STREQUAL "ON"   OR
      "${NAME_UPPER}" STREQUAL "Y"    OR
      "${NAME_UPPER}" STREQUAL "YES"  OR
      "${NAME_UPPER}" STREQUAL "TRUE" OR
      "${NAME_UPPER}" STREQUAL "ALL"  OR
      "${NAME_UPPER}" STREQUAL "1")
    set(${name} 1)
  endif()

  unset(NAME_UPPER CACHE)
  unset(NAME_UPPER)
endmacro()
