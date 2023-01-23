target_include_directories(essentia PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/cephes/bessel)
target_sources(essentia
  PRIVATE
    cephes/bessel/gamma.cpp
    cephes/bessel/hyperg.cpp
    cephes/bessel/iv.cpp
    cephes/bessel/polevl.cpp
    cephes/bessel/bessel.h)

target_include_directories(essentia PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/nnls)
target_sources(essentia PRIVATE nnls/nnls.c nnls/nnls.h)

target_include_directories(essentia PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/spline)
target_sources(essentia PRIVATE spline/splineutil.cpp spline/splineutil.h)

if(ESSENTIA_USE_KISSFFT)
  message("Using internal KissFFT.")
  target_include_directories(essentia PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/kiss_fft)
  target_sources(essentia
    PRIVATE
      kiss_fft/kiss_fft.c
      kiss_fft/kiss_fft.h
      kiss_fft/tools/kiss_fftr.c
      kiss_fft/tools/kiss_fftr.h)
endif()