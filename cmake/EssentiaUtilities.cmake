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
