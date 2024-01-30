find_package(Python3 COMPONENTS Interpreter Development REQUIRED)

# Some RPATH setup for macOS
if (APPLE)
  set(CMAKE_MACOSX_RPATH ON)
  set(CMAKE_BUILD_WITH_INSTALL_RPATH ON)
  set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_RPATH};@loader_path")
endif()

# Guess python wheel filename infixes (abi + platform) to be used
# with binary python module dependency URLs.
#
# Example:
#   - "https://my.url/packages/pkg/1.0/pkg-1.0${PY_WHEEL_C_INFIX}.whl"
#
# See:
#   - https://www.python.org/dev/peps/pep-0427/#file-name-convention
#   - https://github.com/pypa/wheel/blob/master/src/wheel/bdist_wheel.py#L43
set(PY_WHEEL_C_ABI "cp${Python3_VERSION_MAJOR}${Python3_VERSION_MINOR}-cp${Python3_VERSION_MAJOR}${Python3_VERSION_MINOR}")

if (WIN32)
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(PY_WHEEL_PLATFORM "win_amd64")
  else()
    set(PY_WHEEL_PLATFORM "win_x86")
  endif()
elseif (APPLE)
  execute_process(
    COMMAND
      "${Python3_EXECUTABLE}"
        "-c" "import platform; print('_'.join(platform.mac_ver()[0].split('.')[:2]))"
    OUTPUT_VARIABLE MACOS_VER
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  set(PY_WHEEL_PLATFORM "macosx_${MACOS_VER}_x86_64")
else()
  if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(PY_WHEEL_PLATFORM "linux_x86_64")
  else()
    set(PY_WHEEL_PLATFORM "linux_i686")
  endif()
endif()

set(PY_WHEEL_C_INFIX "-${PY_WHEEL_C_ABI}-${PY_WHEEL_PLATFORM}")
