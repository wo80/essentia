@echo off

::
:: A script to download and build Essentia dependencies with MSVC.
::

:: Check whether the script is called from the root directory.
if not exist "build-dependencies-msvc.bat" (cd "packaging")

:: The msvc directory will be the install prefix.
if not exist "msvc\" (mkdir "msvc")
cd "msvc"

set INSTALL_PREFIX=%cd%
set BUILD_TYPE="Release"

:: The directory where archives are downloaded and extracted to.
if not exist "download\" (mkdir "download")
cd "download"

::
:: Install Eigen3 - https://gitlab.com/libeigen/eigen
::

if not exist "eigen-3.4.0.tar.gz" (
  echo Downloading libeigen/eigen ...
  curl -L -o "eigen-3.4.0.tar.gz" "https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz"
)

if not exist "..\include\eigen3\" (
  if not exist "eigen-3.4.0\" (
    echo Extracting libeigen/eigen archive ...
    tar -xf "eigen-3.4.0.tar.gz"
  )
  cd "eigen-3.4.0"
  cmake -B build -DEIGEN_BUILD_DOC=OFF -DBUILD_TESTING=OFF -DCMAKE_Fortran_COMPILER="" -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX%
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
  cmake -B build -DBUILD_TESTS=OFF -DDISABLE_FORTRAN=ON -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX% -DENABLE_FLOAT=ON
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
  cmake -B build -DLIBSAMPLERATE_EXAMPLES=OFF -DBUILD_TESTING=OFF -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX%
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
  cmake -B build -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX%
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

if not exist "taglib-2.0.tar.gz" (
  echo Downloading taglib ...
  curl -L -o "taglib-2.0.tar.gz" "https://github.com/taglib/taglib/releases/download/v2.0/taglib-2.0.tar.gz"
)

if not exist "..\include\taglib\" (
  if not exist "taglib-2.0\" (
    echo Extracting taglib archive ...
    tar -xf "taglib-2.0.tar.gz"
  )
  cd "taglib-2.0"
  cmake -B build -DBUILD_EXAMPLES=OFF -DBUILD_BINDINGS=OFF -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX%
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
  cmake -B build -DBUILD_TESTING=OFF -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX%
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
  cmake -B build -DBUILD_TOOLS=OFF -DBUILD_TESTS=OFF -DCMAKE_INSTALL_PREFIX=%INSTALL_PREFIX%
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
:: Install FFmpeg - https://github.com/GyanD/codexffmpeg
::

if not exist "ffmpeg-6.1.1-full_build-shared.zip" (
  echo Downloading GyanD/codexffmpeg ...
  curl -L -o "ffmpeg-6.1.1-full_build-shared.zip" "https://github.com/GyanD/codexffmpeg/releases/download/6.1.1/ffmpeg-6.1.1-full_build-shared.zip"
)

if not exist "..\include\libavcodec\" (
  if not exist "ffmpeg-6.1.1-full_build-shared\" (
    echo Extracting GyanD/codexffmpeg archive ...
    tar -xf "ffmpeg-6.1.1-full_build-shared.zip"
  )
  cd "ffmpeg-6.1.1-full_build-shared"
  xcopy /s /y bin %INSTALL_PREFIX%\bin
  xcopy /s /y lib %INSTALL_PREFIX%\lib
  xcopy /s /y include %INSTALL_PREFIX%\include
  cd ..
) else (
  echo Already installed: GyanD/codexffmpeg
)

::
:: Install TensorFlow - https://www.tensorflow.org/install/lang_c
::

if not exist "libtensorflow-cpu-windows-x86_64-2.15.0.zip" (
  echo Downloading tensorflow-cpu ...
  curl -L -o "libtensorflow-cpu-windows-x86_64-2.15.0.zip" "https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-cpu-windows-x86_64-2.15.0.zip"
)

:: Need to set the variable outside the if-block below.
set TF_TAG=https://raw.githubusercontent.com/tensorflow/tensorflow/r2.15-66681ea34be

if not exist "..\include\tensorflow\c\tf_buffer.h" (
  if not exist "lib\tensorflow.dll" (
    echo Extracting tensorflow-cpu archive ...
    tar -xf "libtensorflow-cpu-windows-x86_64-2.15.0.zip"
  )
  echo Downloading missing tensorflow-cpu headers ...
  curl --create-dirs -o "include\tensorflow\c\tf_buffer.h" "%TF_TAG%/tensorflow/c/tf_buffer.h"
  curl --create-dirs -o "include\tensorflow\c\tf_tensor_helper.h" "%TF_TAG%/tensorflow/c/tf_tensor_helper.h"
  curl --create-dirs -o "include\tsl\c\tsl_status.h" "%TF_TAG%/third_party/xla/third_party/tsl/tsl/c/tsl_status.h"
  curl --create-dirs -o "include\tsl\platform\ctstring.h" "%TF_TAG%/third_party/xla/third_party/tsl/tsl/platform/ctstring.h"
  curl --create-dirs -o "include\tsl\platform\ctstring_internal.h" "%TF_TAG%/third_party/xla/third_party/tsl/tsl/platform/ctstring_internal.h"
)

if not exist "..\include\tensorflow\" (
  xcopy /s /y lib\tensorflow.dll %INSTALL_PREFIX%\bin
  xcopy /s /y lib\tensorflow.lib %INSTALL_PREFIX%\lib
  xcopy /s /y include %INSTALL_PREFIX%\include
) else (
  echo Already installed: tensorflow-cpu
)

cd ..\..\..
