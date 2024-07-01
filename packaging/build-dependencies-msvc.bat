@echo off

::
:: A script to download and build Essentia dependencies with MSVC.
::
:: Optional parameters:
::
:: --static     = Flag to enable static build
:: --build-type = CMake build type (Debug, Release, RelWithDebInfo or MinSizeRel)
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
set SHARED_LIBS=YES
set BUILD_TYPE=Debug

:: Parse commandline arguments

setlocal EnableDelayedExpansion

set HAS_BUILD_TYPE=0

for %%A in (%*) do (
  if /I %%A==--static (
    set SHARED_LIBS=NO
  ) else ( if /I %%A==--build-type (
    set HAS_BUILD_TYPE=1
  ) else ( if !HAS_BUILD_TYPE!==1 (
    set BUILD_TYPE=%%A
  )))
)

for %%A in (Debug Release RelWithDebInfo MinSizeRel) do (
  if %BUILD_TYPE%==%%A (goto valid)
)

echo Invalid build type: %BUILD_TYPE%. Using default (Debug)
set BUILD_TYPE=Debug

:valid

set INSTALL_PREFIX=%cd%

:: The directory where archives are downloaded and extracted to.
if not exist "download\" (mkdir "download")
cd "download"

::
:: Install Eigen3 - https://gitlab.com/libeigen/eigen
::

if not exist "eigen-3.4.0.tar.gz" (
  echo Downloading libeigen/eigen ...
  curl -L -o "eigen-3.4.0.tar.gz" "https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz"
  if ERRORLEVEL 1 (
    echo Failed to download libeigen/eigen ...
    goto error
  )
)

if not exist "..\include\eigen3\" (
  if not exist "eigen-3.4.0\" (
    echo Extracting libeigen/eigen archive ...
    tar -xf "eigen-3.4.0.tar.gz"
  )
  cd "eigen-3.4.0"
  cmake -B build -DEIGEN_BUILD_DOC=NO -DBUILD_TESTING=NO -DCMAKE_Fortran_COMPILER="" -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX%
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

if not exist "..\include\fftw3.h" (
  if not exist "fftw-3.3.10\" (
    echo Extracting fftw archive ...
    tar -xf "fftw-3.3.10.tar.gz"
  )
  cd "fftw-3.3.10"
  cmake -B build -DBUILD_TESTS=NO -DDISABLE_FORTRAN=YES -DBUILD_SHARED_LIBS=%SHARED_LIBS% -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DENABLE_FLOAT=YES
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

if not exist "..\include\samplerate.h" (
  if not exist "libsamplerate\" (
    echo Extracting libsndfile/libsamplerate archive ...
    tar -xf "libsamplerate-master.zip"
    rename "libsamplerate-master" "libsamplerate"
  )
  cd "libsamplerate"
  cmake -B build -DLIBSAMPLERATE_EXAMPLES=NO -DBUILD_TESTING=NO -DBUILD_SHARED_LIBS=%SHARED_LIBS% -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX%
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

if not exist "..\include\zlib.h" (
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

if not exist "v4.0.5.tar.gz" (
  echo Downloading utf8cpp ...
  curl -L -o "v4.0.5.tar.gz" "https://github.com/nemtrif/utfcpp/archive/refs/tags/v4.0.5.tar.gz"
)

if not exist "..\include\utf8cpp\" (
  if not exist "utfcpp-4.0.5\" (
    echo Extracting utf8cpp archive ...
    tar -xf "v4.0.5.tar.gz"
  )
  cd "utfcpp-4.0.5"
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

if not exist "taglib-2.0.1.tar.gz" (
  echo Downloading taglib ...
  curl -L -o "taglib-2.0.1.tar.gz" "https://github.com/taglib/taglib/releases/download/v2.0.1/taglib-2.0.1.tar.gz"
)

if not exist "..\include\taglib\" (
  if not exist "taglib-2.0.1\" (
    echo Extracting taglib archive ...
    tar -xf "taglib-2.0.1.tar.gz"
  )
  cd "taglib-2.0.1"
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

if not exist "..\include\yaml.h" (
  if not exist "libyaml\" (
    echo Extracting yaml/libyaml archive ...
    tar -xf "libyaml-master.zip"
    rename "libyaml-master" "libyaml"
  )
  cd "libyaml"
  cmake -B build -DBUILD_TESTING=NO -DBUILD_SHARED_LIBS=%SHARED_LIBS% -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX%
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

if not exist "..\include\chromaprint.h" (
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

if not exist "..\include\vamp\" (
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

if %SHARED_LIBS%==YES (
  set ffmpeg_type=shared
) else (
  set ffmpeg_type=static
)

if not exist "ffmpeg-7.0.1-win64-%ffmpeg_type%.zip" (
  echo Downloading wo80/ffmpeg-audio-only ...
  curl -L -o "ffmpeg-7.0.1-win64-%ffmpeg_type%.zip" "https://github.com/wo80/ffmpeg-audio-only/releases/download/v7.0.1/ffmpeg-7.0.1-win64-%ffmpeg_type%.zip"
)

if not exist "..\include\libavcodec\" (
  if not exist "ffmpeg-7.0.1-win64-%ffmpeg_type%\" (
    echo Extracting wo80/ffmpeg-audio-only archive ...
    tar -xf "ffmpeg-7.0.1-win64-%ffmpeg_type%.zip"
  )
  cd "ffmpeg-7.0.1-win64-%ffmpeg_type%"
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

if not exist "libtensorflow-cpu-windows-x86_64.zip" (
  echo Downloading tensorflow-cpu ...
  curl -L -o "libtensorflow-cpu-windows-x86_64.zip" "https://storage.googleapis.com/tensorflow/versions/2.16.1/libtensorflow-cpu-windows-x86_64.zip"
)

if not exist "..\include\tensorflow\c\tf_buffer.h" (
  if not exist "lib\tensorflow.dll" (
    echo Extracting tensorflow-cpu archive ...
    tar -xf "libtensorflow-cpu-windows-x86_64.zip"
  )
)

if not exist "..\include\tensorflow\" (
  xcopy /s /y lib\tensorflow.dll %INSTALL_PREFIX%\bin
  xcopy /s /y lib\tensorflow.lib %INSTALL_PREFIX%\lib
  xcopy /s /y include %INSTALL_PREFIX%\include
) else (
  echo Already installed: tensorflow-cpu
)

:: Change back to Essentia root directory
cd ..\..\..

goto done

:error

echo An error occurred.
exit /b %ERRORLEVEL%

:done

echo Done.
