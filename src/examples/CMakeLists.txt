function(essentia_add_example example)
  if(BUILD_EXAMPLES EQUAL 1 OR example IN_LIST BUILD_EXAMPLES)
    add_executable(${example} "${example}.cpp")
    target_link_libraries(${example} PRIVATE essentia)
    if(BUILD_SHARED_LIBS)
      target_compile_definitions(${example} PUBLIC ESSENTIA_EXPORTS=0)
    endif()
  endif()
endfunction()

essentia_check_set(BUILD_EXAMPLES)

set(ESSENTIA_EXAMPLES_standard
  onset_detector
  standard_beatsmarker
  standard_chromacrosssimilarity
  standard_chromaprinter
  standard_coversongsimilarity
  standard_crosssimilaritymatrix
  standard_discontinuitydetector
  standard_extractor_la-cupula
  standard_fadedetection
  standard_gapsdetector
  standard_harmonicmodel
  standard_hpsmodel
  standard_hprmodel
  standard_humdetector
  standard_loudnessebur128
  standard_loudnessebur128_double_input
  standard_mfcc
  #standard_nnls
  standard_onsetrate
  standard_pca
  standard_pitchdemo
  standard_predominantmask
  standard_rhythmtransform
  standard_saturationdetector
  standard_sinemodel
  standard_sinesubtraction
  standard_snr
  standard_spectralcontrast
  standard_sprmodel
  standard_spsmodel
  standard_stft
  standard_stochasticmodel
  standard_vibrato
  standard_welch)

set(ESSENTIA_EXAMPLES_streaming
  streaming_beatsmarker
  streaming_beattracker_multifeature_mirex2013
  streaming_coversongsimilarity
  streaming_chromacrosssimilarity
  streaming_extractor_music
  streaming_extractor_freesound
  streaming_gfcc
  streaming_humdetector
  streaming_key
  streaming_md5
  streaming_mfcc
  streaming_onsetrate
  streaming_panning
  streaming_pitchyinfft
  streaming_predominantpitchmelodia
  streaming_rhythmextractor_multifeature
  streaming_spectrogram
  streaming_stft
  streaming_tuningfrequency
  streaming_vibrato
  streaming_yinprobabilistic)

# Setup target executable for each standard example.
foreach( example ${ESSENTIA_EXAMPLES_standard} )
  essentia_add_example(${example})
endforeach()

# Setup target executable for each streaming example.
foreach( example ${ESSENTIA_EXAMPLES_streaming} )
  essentia_add_example(${example})
endforeach()

# Tensorflow
if(ESSENTIA_USE_TENSORFLOW)
  set(ESSENTIA_EXAMPLES_tf
    standard_tempocnn
    streaming_tensorflowpredict
    streaming_musicnn_predict
    streaming_vggish_predict)

  foreach(example ${ESSENTIA_EXAMPLES_tf})
    essentia_add_example(${example})
  endforeach()
endif()

# Gaia SVM
if(ESSENTIA_USE_GAIA2)
  essentia_add_example(streaming_extractor_music_svm)
endif()

# Take care of additional dependencies.
if(TARGET streaming_extractor_music)
  target_sources(streaming_extractor_music
    PRIVATE
      music_extractor/extractor_utils.cpp
      music_extractor/extractor_utils.h)
endif()

if(TARGET streaming_extractor_freesound)
  target_sources(streaming_extractor_freesound
    PRIVATE
      music_extractor/extractor_utils.cpp
      music_extractor/extractor_utils.h)
endif()

if(TARGET streaming_spectrogram)
  target_sources(streaming_spectrogram
    PRIVATE
      music_extractor/extractor_utils.cpp
      music_extractor/extractor_utils.h)
endif()

if(TARGET streaming_extractor_music_svm)
  target_sources(streaming_extractor_music_svm
    PRIVATE
      music_extractor/extractor_utils.cpp
      music_extractor/extractor_utils.h)
endif()
