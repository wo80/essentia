@echo off

::
:: A script to download and build Essentia dependencies with MSVC.
::
:: Optional parameters:
::
:: --prefix     = The install prefix (the directory has to exist)
:: --build-type = CMake build type (Debug, Release, RelWithDebInfo or MinSizeRel)
:: --static     = Flag to enable static build
:: --shared     = List of shared dependencies, ignoring the '--static' flag, separated by a colon,
::                for example  '--shared ffmpeg:fftw'. Only FFmpeg and FFTW supported for now.
:: --with-gaia  = Flag to enable Gaia build
:: --with-tensorflow  = Flag to download and install TensorFlow
::

:: Check if tools are available.
for %%x in (cmake curl tar) do (
  where /q %%x
  if ERRORLEVEL 1 (
    echo The application "%%x" is missing. Ensure it is installed and placed in your PATH.
    goto error
  )
)

:: Check whether the script is called from the root directory.
if not exist "build-dependencies-msvc.bat" (cd "packaging")

:: Abort if we're not in the correct directory.
if not exist "build-dependencies-msvc.bat" (goto error)

:: The msvc directory will be the install prefix.
if not exist "msvc\" (mkdir "msvc")
cd "msvc"

:: Default build options
set INSTALL_PREFIX=
set BUILD_TYPE=Debug
set SHARED_LIBS=YES
set WITH_GAIA=NO
set WITH_TENSORFLOW=NO

:: Parse commandline arguments

setlocal EnableDelayedExpansion

set OPT=

for %%A in (%*) do (
  if /I %%A==--static (
    set SHARED_LIBS=NO
  ) else ( if /I %%A==--with-gaia (
    set WITH_GAIA=YES
  ) else ( if /I %%A==--with-tensorflow (
    set WITH_TENSORFLOW=YES
  ) else ( if /I %%A==--build-type (
    set OPT=1
  ) else ( if /I %%A==--prefix (
    set OPT=2
  ) else ( if /I %%A==--shared (
    set OPT=3
  ) else ( if !OPT!==1 (
    set BUILD_TYPE=%%A
    set OPT=0
  ) else ( if !OPT!==2 (
    set INSTALL_PREFIX=%%A
    set OPT=0
  ) else ( if !OPT!==3 (
    set SHARED_LIB_NAMES=%%A
    set OPT=0
  )))))))))
)

if "%INSTALL_PREFIX%" == "" (
  set INSTALL_PREFIX=%cd%
)

:: Abort if install prefix doesn't exist.
if not exist "%INSTALL_PREFIX%" (
  echo Invalid install prefix - directory does not exist
  goto error
)

:: Set default shared lib value for FFmpeg and FFTW.
set ffmpeg_shared=%SHARED_LIBS%
set fftw_shared=%SHARED_LIBS%

:: Update shared lib values.
if not "%SHARED_LIB_NAMES%" == "" (
  if not "!SHARED_LIB_NAMES:ffmpeg=!"=="%SHARED_LIB_NAMES%" (
    set ffmpeg_shared=YES
  )
  if not "!SHARED_LIB_NAMES:fftw=!"=="%SHARED_LIB_NAMES%" (
    set fftw_shared=YES
  )
)

:: Check build type
for %%A in (Debug Release RelWithDebInfo MinSizeRel) do (
  if %BUILD_TYPE%==%%A (goto valid)
)

echo Invalid build type: %BUILD_TYPE%. Using default (Debug)
set BUILD_TYPE=Debug

:valid

:: The directory where archives are downloaded and extracted to.
if not exist "download\" (mkdir "download")
cd "download"

::
:: Install Eigen3 - https://gitlab.com/libeigen/eigen
::

if not exist "eigen-5.0.1.tar.gz" (
  echo Downloading libeigen/eigen ...
  curl -L -o "eigen-5.0.1.tar.gz" "https://gitlab.com/libeigen/eigen/-/archive/5.0.1/eigen-5.0.1.tar.gz"
  if ERRORLEVEL 1 (
    echo Failed to download libeigen/eigen ...
    goto error
  )
)

if not exist "%INSTALL_PREFIX%\include\eigen3\" (
  if not exist "eigen-5.0.1\" (
    echo Extracting libeigen/eigen archive ...
    tar -xf "eigen-5.0.1.tar.gz"
  )
  cd "eigen-5.0.1"
  cmake -B build -DEIGEN_BUILD_DOC=NO -DBUILD_TESTING=NO -DEIGEN_BUILD_BLAS=NO -DEIGEN_BUILD_LAPACK=NO -DCMAKE_Fortran_COMPILER="" -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX%
  cmake --build build --config %BUILD_TYPE%
  cmake --install build --config %BUILD_TYPE%
  cd ..
) else (
  echo Already installed: libeigen/eigen
)

::
:: Install FFTW - https://www.fftw.org
::

if not exist "fftw-3.3.10.tar.gz" (
  echo Downloading fftw ...
  curl -L -o "fftw-3.3.10.tar.gz" "https://www.fftw.org/fftw-3.3.10.tar.gz"
)

if not exist "%INSTALL_PREFIX%\include\fftw3.h" (
  if not exist "fftw-3.3.10\" (
    echo Extracting fftw archive ...
    tar -xf "fftw-3.3.10.tar.gz"
  )
  cd "fftw-3.3.10"
  cmake -B build -DBUILD_TESTS=NO -DDISABLE_FORTRAN=YES -DBUILD_SHARED_LIBS=%fftw_shared% -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DENABLE_FLOAT=YES -DCMAKE_POLICY_VERSION_MINIMUM=3.5
  cmake --build build --config %BUILD_TYPE% --parallel
  cmake --install build --config %BUILD_TYPE%
  cd ..
) else (
  echo Already installed: fftw
)

::
:: Install libsamplerate - https://github.com/libsndfile/libsamplerate
::

if not exist "libsamplerate-master.zip" (
  echo Downloading libsndfile/libsamplerate ...
  curl -L -o "libsamplerate-master.zip" "https://github.com/libsndfile/libsamplerate/archive/refs/heads/master.zip"
)

if not exist "%INSTALL_PREFIX%\include\samplerate.h" (
  if not exist "libsamplerate\" (
    echo Extracting libsndfile/libsamplerate archive ...
    tar -xf "libsamplerate-master.zip"
    rename "libsamplerate-master" "libsamplerate"
  )
  cd "libsamplerate"
  cmake -B build -DLIBSAMPLERATE_EXAMPLES=NO -DBUILD_TESTING=NO -DBUILD_SHARED_LIBS=%SHARED_LIBS% -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DCMAKE_POLICY_VERSION_MINIMUM=3.5
  cmake --build build --config %BUILD_TYPE%
  cmake --install build --config %BUILD_TYPE%
  cd ..
) else (
  echo Already installed: libsndfile/libsamplerate
)

::
:: Install zlib (TagLib dependency) - https://github.com/madler/zlib
::

if not exist "zlib-1.3.1.tar.gz" (
  echo Downloading madler/zlib ...
  curl -L -o "zlib-1.3.1.tar.gz" "https://github.com/madler/zlib/releases/download/v1.3.1/zlib-1.3.1.tar.gz"
)

if not exist "%INSTALL_PREFIX%\include\zlib.h" (
  if not exist "zlib-1.3.1\" (
    echo Extracting madler/zlib archive ...
    tar -xf "zlib-1.3.1.tar.gz"
  )
  cd "zlib-1.3.1"
  cmake -B build -DZLIB_BUILD_EXAMPLES=NO -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX%
  cmake --build build --config %BUILD_TYPE% --parallel
  cmake --install build --config %BUILD_TYPE%
  cd ..
) else (
  echo Already installed: madler/zlib
)

::
:: Install utf8cpp (TagLib dependency) - https://github.com/nemtrif/utfcpp
::

if not exist "v4.0.9.tar.gz" (
  echo Downloading utf8cpp ...
  curl -L -o "v4.0.9.tar.gz" "https://github.com/nemtrif/utfcpp/archive/refs/tags/v4.0.9.tar.gz"
)

if not exist "%INSTALL_PREFIX%\include\utf8cpp\" (
  if not exist "utfcpp-4.0.9\" (
    echo Extracting utf8cpp archive ...
    tar -xf "v4.0.9.tar.gz"
  )
  cd "utfcpp-4.0.9"
  cmake -B build
  cmake --build build --config %BUILD_TYPE%
  cmake --install build --config %BUILD_TYPE% --prefix %INSTALL_PREFIX%
  cd ..
) else (
  echo Already installed: utf8cpp
)

::
:: Install TagLib - https://github.com/taglib/taglib
::

if not exist "taglib-2.1.1.tar.gz" (
  echo Downloading taglib ...
  curl -L -o "taglib-2.1.1.tar.gz" "https://github.com/taglib/taglib/releases/download/v2.1.1/taglib-2.1.1.tar.gz"
)

if not exist "%INSTALL_PREFIX%\include\taglib\" (
  if not exist "taglib-2.1.1\" (
    echo Extracting taglib archive ...
    tar -xf "taglib-2.1.1.tar.gz"
  )
  cd "taglib-2.1.1"
  cmake -B build -DWITH_ZLIB=NO -DBUILD_EXAMPLES=NO -DBUILD_BINDINGS=NO -DBUILD_TESTING=NO -DBUILD_SHARED_LIBS=%SHARED_LIBS% -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX%
  cmake --build build --config %BUILD_TYPE% --parallel
  cmake --install build --config %BUILD_TYPE%
  cd ..
) else (
  echo Already installed: taglib
)

::
:: Install YAML - https://github.com/yaml/libyaml
::

if not exist "libyaml-master.zip" (
  echo Downloading yaml/libyaml ...
  curl -L -o "libyaml-master.zip" "https://github.com/yaml/libyaml/archive/refs/heads/master.zip"
)

if not exist "%INSTALL_PREFIX%\include\yaml.h" (
  if not exist "libyaml\" (
    echo Extracting yaml/libyaml archive ...
    tar -xf "libyaml-master.zip"
    rename "libyaml-master" "libyaml"
  )
  cd "libyaml"
  cmake -B build -DBUILD_TESTING=NO -DBUILD_SHARED_LIBS=%SHARED_LIBS% -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DCMAKE_POLICY_VERSION_MINIMUM=3.5
  cmake --build build --config %BUILD_TYPE%
  cmake --install build --config %BUILD_TYPE%
  cd ..
) else (
  echo Already installed: yaml/libyaml
)

::
:: Install Chromaprint - https://github.com/acoustid/chromaprint
::

if not exist "chromaprint-master.zip" (
  echo Downloading acoustid/chromaprint ...
  curl -L -o "chromaprint-master.zip" "https://github.com/acoustid/chromaprint/archive/refs/heads/master.zip"
)

if not exist "%INSTALL_PREFIX%\include\chromaprint.h" (
  if not exist "chromaprint\" (
    echo Extracting acoustid/chromaprint archive ...
    tar -xf "chromaprint-master.zip"
    rename "chromaprint-master" "chromaprint"
  )
  cd "chromaprint"
  cmake -B build -DBUILD_TOOLS=NO -DBUILD_TESTS=NO -DBUILD_SHARED_LIBS=%SHARED_LIBS% -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX%
  cmake --build build --config %BUILD_TYPE%
  cmake --install build --config %BUILD_TYPE%
  cd ..
) else (
  echo Already installed: acoustid/chromaprint
)

::
:: Install Vamp plugin SDK - https://github.com/vamp-plugins/vamp-plugin-sdk
::

if not exist "vamp-plugin-sdk-master.zip" (
  echo Downloading vamp-plugins/vamp-plugin-sdk ...
  curl -L -o "vamp-plugin-sdk-master.zip" "https://github.com/vamp-plugins/vamp-plugin-sdk/archive/refs/heads/master.zip"
)

if not exist "%INSTALL_PREFIX%\include\vamp\" (
  if not exist "vamp-plugin-sdk-master\" (
    echo Extracting vamp-plugins/vamp-plugin-sdk archive ...
    tar -xf "vamp-plugin-sdk-master.zip"
  )
  cd "vamp-plugin-sdk-master"
  cmake -B build -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX%
  cmake --build build --config %BUILD_TYPE%
  cmake --install build --config %BUILD_TYPE%
  cd ..
) else (
  echo Already installed: vamp-plugins/vamp-plugin-sdk
)

::
:: Install FFmpeg - https://github.com/wo80/ffmpeg-audio-only
::

if %ffmpeg_shared%==YES (
  set ffmpeg_type=shared
) else (
  set ffmpeg_type=static
)

if not exist "ffmpeg-8.0.1-win64-%ffmpeg_type%.zip" (
  echo Downloading wo80/ffmpeg-audio-only ...
  curl -L -o "ffmpeg-8.0.1-win64-%ffmpeg_type%.zip" "https://github.com/wo80/ffmpeg-audio-only/releases/download/v8.0.1/ffmpeg-8.0.1-win64-%ffmpeg_type%.zip"
)

if not exist "%INSTALL_PREFIX%\include\libavcodec\" (
  if not exist "ffmpeg-8.0.1-win64-%ffmpeg_type%\" (
    echo Extracting wo80/ffmpeg-audio-only archive ...
    tar -xf "ffmpeg-8.0.1-win64-%ffmpeg_type%.zip"
  )
  cd "ffmpeg-8.0.1-win64-%ffmpeg_type%"
  xcopy /s /y bin %INSTALL_PREFIX%\bin
  xcopy /s /y lib %INSTALL_PREFIX%\lib
  xcopy /s /y include %INSTALL_PREFIX%\include
  cd ..
) else (
  echo Already installed: wo80/ffmpeg-audio-only
)

::
:: Install TensorFlow - https://www.tensorflow.org/install/lang_c
::

if %WITH_TENSORFLOW%==NO (goto tf_end)

if not exist "libtensorflow-cpu-windows-x86_64.zip" (
  echo Downloading tensorflow-cpu ...
  curl -L -o "libtensorflow-cpu-windows-x86_64.zip" "https://storage.googleapis.com/tensorflow/versions/2.16.2/libtensorflow-cpu-windows-x86_64.zip"
)

if not exist "%INSTALL_PREFIX%\include\tensorflow\c\tf_buffer.h" (
  if not exist "lib\tensorflow.dll" (
    echo Extracting tensorflow-cpu archive ...
    tar -xf "libtensorflow-cpu-windows-x86_64.zip"
  )
)

if not exist "%INSTALL_PREFIX%\include\tensorflow\" (
  xcopy /s /y lib\tensorflow.dll %INSTALL_PREFIX%\bin
  xcopy /s /y lib\tensorflow.lib %INSTALL_PREFIX%\lib
  xcopy /s /y include %INSTALL_PREFIX%\include
) else (
  echo Already installed: tensorflow-cpu
)

:tf_end

if %WITH_GAIA%==NO (goto gaia_end)

::
:: Install Qt5
::

if not exist "qtbase.7z" (
  echo Downloading Qt5 ...
  curl -L -o "qtbase.7z" "https://github.com/wo80/qt-msvc-build/releases/download/v5.15.18/qt-5.15.18-msvc2022-x64.7z"
)

if not exist "%INSTALL_PREFIX%\Qt5\include\QtCore\" (
  if not exist "Qt5\" (
    echo Extracting Qt5 archive ...
    7z x -y qtbase.7z -oQt5
  )
  xcopy /s /y Qt5\ %INSTALL_PREFIX%\Qt5\
) else (
  echo Already installed: Qt5
)

::
:: Install Gaia - https://github.com/wo80/gaia/tree/cmake
::

if not exist "gaia-cmake.zip" (
  echo Downloading wo80/gaia ...
  curl -L -o "gaia-cmake.zip" "https://github.com/wo80/gaia/archive/refs/heads/cmake.zip"
)

if %SHARED_LIBS%==YES (
  set gaia_static_deps=NO
) else (
  set gaia_static_deps=YES
)

if not exist "%INSTALL_PREFIX%\include\gaia2\gaia.h" (
  if not exist "gaia-cmake\" (
    echo Extracting wo80/gaia archive ...
    tar -xf "gaia-cmake.zip"
  )
  cd "gaia-cmake"
  cmake -B build -DBUILD_TOOLS=NO -DBUILD_TESTS=NO -DENABLE_STATIC_DEPENDENCIES=%gaia_static_deps% -DBUILD_SHARED_LIBS=%SHARED_LIBS% -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DCMAKE_PREFIX_PATH=%INSTALL_PREFIX%\Qt5
  cmake --build build --config %BUILD_TYPE%
  cmake --install build --config %BUILD_TYPE%
  cd ..
) else (
  echo Already installed: wo80/gaia
)

:gaia_end

:: Change back to Essentia root directory
cd ..\..\..

goto done

:error

echo An error occurred.
exit /b %ERRORLEVEL%

:done

echo Done.
