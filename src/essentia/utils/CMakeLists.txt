target_sources(essentia
  PRIVATE
    asciidag.cpp
    asciidagparser.cpp
    jsonconvert.cpp
    ringbufferimpl.h
    synth_utils.cpp
    asciidag.h
    asciidagparser.h
    atomic.h
    betools.h
    bpfutil.h
    bpmutil.h
    jsonconvert.h
    metadatautils.h
    output.h
    peak.h
    synth_utils.h
)

if(ESSENTIA_USE_FFMPEG)
  target_sources(essentia
    PRIVATE
      audiocontext.cpp
      ffmpegapi.h
      audiocontext.h
  )
endif()


if(ESSENTIA_USE_YAML)
  target_sources(essentia
    PRIVATE
      yamlast.cpp
      yamlast.h
  )
endif()

target_include_directories(essentia
  PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

add_subdirectory(extractor_freesound)
add_subdirectory(extractor_music)
