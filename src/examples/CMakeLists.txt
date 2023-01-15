function(essentia_add_example example_src)
  string( REPLACE ".cpp" "" example ${example_src} )
  add_executable( ${example} ${example_src} )
  target_link_libraries(${example} PRIVATE essentia)
endfunction()

set(ESSENTIA_EXAMPLES_standard
  onset_detector.cpp
  standard_beatsmarker.cpp
  standard_chromacrosssimilarity.cpp
  standard_chromaprinter.cpp
  standard_coversongsimilarity.cpp
  standard_crosssimilaritymatrix.cpp
  standard_discontinuitydetector.cpp
  standard_extractor_la-cupula.cpp
  standard_fadedetection.cpp
  standard_gapsdetector.cpp
  standard_harmonicmodel.cpp
  standard_hpsmodel.cpp
  standard_hprmodel.cpp
  standard_humdetector.cpp
  standard_loudnessebur128.cpp
  standard_loudnessebur128_double_input.cpp
  standard_mfcc.cpp
  #standard_nnls.cpp
  standard_onsetrate.cpp
  standard_pca.cpp
  standard_pitchdemo.cpp
  standard_predominantmask.cpp
  standard_rhythmtransform.cpp
  standard_saturationdetector.cpp
  standard_sinemodel.cpp
  standard_sinesubtraction.cpp
  standard_snr.cpp
  standard_spectralcontrast.cpp
  standard_sprmodel.cpp
  standard_spsmodel.cpp
  standard_stft.cpp
  standard_stochasticmodel.cpp
  standard_vibrato.cpp
  standard_welch.cpp)

set(ESSENTIA_EXAMPLES_streaming
  streaming_beatsmarker.cpp
  streaming_beattracker_multifeature_mirex2013.cpp
  streaming_coversongsimilarity.cpp
  streaming_chromacrosssimilarity.cpp
  streaming_extractor_music.cpp
  streaming_extractor_freesound.cpp
  streaming_gfcc.cpp
  streaming_humdetector.cpp
  streaming_key.cpp
  streaming_md5.cpp
  streaming_mfcc.cpp
  streaming_onsetrate.cpp
  streaming_panning.cpp
  streaming_pitchyinfft.cpp
  streaming_predominantpitchmelodia.cpp
  streaming_rhythmextractor_multifeature.cpp
  streaming_spectrogram.cpp
  streaming_stft.cpp
  streaming_tuningfrequency.cpp
  streaming_vibrato.cpp
  streaming_yinprobabilistic.cpp)

# Setup target executable for each standard example.
foreach( example_src ${ESSENTIA_EXAMPLES_standard} )
  essentia_add_example(${example_src})
endforeach( example_src ${ESSENTIA_EXAMPLES_standard} )

# Setup target executable for each streaming example.
foreach( example_src ${ESSENTIA_EXAMPLES_streaming} )
  essentia_add_example(${example_src})
endforeach( example_src ${ESSENTIA_EXAMPLES_streaming} )

# Take care of additional dependencies.
target_sources(streaming_extractor_music
  PRIVATE
    music_extractor/extractor_utils.cpp
    music_extractor/extractor_utils.h)
    
target_sources(streaming_extractor_freesound
  PRIVATE
    music_extractor/extractor_utils.cpp
    music_extractor/extractor_utils.h)
    
target_sources(streaming_spectrogram
  PRIVATE
    music_extractor/extractor_utils.cpp
    music_extractor/extractor_utils.h)

# Tensorflow
if(ESSENTIA_USE_TENSORFLOW)
  essentia_add_example(streaming_tensorflowpredict.cpp)
  essentia_add_example(streaming_musicnn_predict.cpp)
  essentia_add_example(streaming_vggish_predict.cpp)
endif()

# Gaia SVM
if(ESSENTIA_USE_GAIA2)
  essentia_add_example(streaming_extractor_music_svm.cpp)
endif()
