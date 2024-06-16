#include "essentia_algorithms_reg_2.h"
#include "algorithmfactory.h"
#include "algorithms/audioproblems/clickdetector.h"
#include "algorithms/audioproblems/discontinuitydetector.h"
#include "algorithms/audioproblems/falsestereodetector.h"
#include "algorithms/audioproblems/gapsdetector.h"
#include "algorithms/audioproblems/humdetector.h"
#include "algorithms/audioproblems/noiseburstdetector.h"
#include "algorithms/audioproblems/saturationdetector.h"
#include "algorithms/audioproblems/snr.h"
#include "algorithms/audioproblems/startstopcut.h"
#include "algorithms/audioproblems/truepeakdetector.h"
#include "algorithms/complex/cartesiantopolar.h"
#include "algorithms/complex/magnitude.h"
#include "algorithms/complex/polartocartesian.h"
#include "algorithms/experimental/beatogram.h"
#include "algorithms/experimental/meter.h"
#include "algorithms/extractor/barkextractor.h"
#include "algorithms/extractor/extractor.h"
#include "algorithms/extractor/freesoundextractor.h"
#include "algorithms/extractor/keyextractor.h"
#include "algorithms/extractor/levelextractor.h"
#include "algorithms/extractor/lowlevelspectraleqloudextractor.h"
#include "algorithms/extractor/lowlevelspectralextractor.h"
#include "algorithms/extractor/musicextractor.h"
#if ENABLE_GAIA2
#include "algorithms/extractor/musicextractorsvm.h"
#endif
#include "algorithms/extractor/rhythmdescriptors.h"
#include "algorithms/extractor/tonalextractor.h"
#include "algorithms/extractor/tuningfrequencyextractor.h"
#include "algorithms/filters/allpass.h"
#include "algorithms/filters/bandpass.h"
#include "algorithms/filters/bandreject.h"
#include "algorithms/filters/dcremoval.h"
#include "algorithms/filters/equalloudness.h"
#include "algorithms/filters/highpass.h"
#include "algorithms/filters/iir.h"
#include "algorithms/filters/lowpass.h"
#include "algorithms/filters/medianfilter.h"
#include "algorithms/filters/movingaverage.h"
#include "algorithms/highlevel/chromacrosssimilarity.h"
#if ENABLE_CHROMAPRINT
#include "algorithms/highlevel/chromaprinter.h"
#endif
#include "algorithms/highlevel/coversongsimilarity.h"
#include "algorithms/highlevel/crosssimilaritymatrix.h"
#include "algorithms/highlevel/danceability.h"
#include "algorithms/highlevel/dynamiccomplexity.h"
#include "algorithms/highlevel/fadedetection.h"
#if ENABLE_GAIA2
#include "algorithms/highlevel/gaiatransform.h"
#endif
#include "algorithms/highlevel/intensity.h"
#include "algorithms/highlevel/pca.h"
#include "algorithms/highlevel/sbic.h"
#include "algorithms/io/audioonsetsmarker.h"
#if ENABLE_AUDIOLOADER
#include "algorithms/io/audioloader.h"
#include "algorithms/io/easyloader.h"
#include "algorithms/io/eqloudloader.h"
#include "algorithms/io/monoloader.h"
#endif
#if ENABLE_AUDIOWRITER
#include "algorithms/io/audiowriter.h"
#include "algorithms/io/monowriter.h"
#endif
#include "algorithms/io/fileoutputproxy.h"
#if ENABLE_TAGLIB
#include "algorithms/io/metadatareader.h"
#endif
#if ENABLE_YAML
#include "algorithms/io/yamlinput.h"
#endif
#include "algorithms/io/yamloutput.h"
#include "algorithms/rhythm/beatsloudness.h"
#include "algorithms/rhythm/beattrackerdegara.h"
#include "algorithms/rhythm/beattrackermultifeature.h"
#include "algorithms/rhythm/bpmhistogram.h"
#include "algorithms/rhythm/bpmhistogramdescriptors.h"
#include "algorithms/rhythm/bpmrubato.h"
#include "algorithms/rhythm/harmonicbpm.h"
#include "algorithms/rhythm/loopbpmconfidence.h"
#include "algorithms/rhythm/loopbpmestimator.h"
#include "algorithms/rhythm/noveltycurve.h"
#include "algorithms/rhythm/noveltycurvefixedbpmestimator.h"
#include "algorithms/rhythm/onsetdetection.h"
#include "algorithms/rhythm/onsetdetectionglobal.h"
#include "algorithms/rhythm/onsetrate.h"
#include "algorithms/rhythm/onsets.h"
#include "algorithms/rhythm/percivalbpmestimator.h"
#include "algorithms/rhythm/percivalenhanceharmonics.h"
#include "algorithms/rhythm/percivalevaluatepulsetrains.h"
#include "algorithms/rhythm/rhythmextractor.h"
#include "algorithms/rhythm/rhythmextractor2013.h"
#include "algorithms/rhythm/rhythmtransform.h"
#include "algorithms/rhythm/singlebeatloudness.h"
#include "algorithms/rhythm/superfluxextractor.h"
#include "algorithms/rhythm/superfluxnovelty.h"
#include "algorithms/rhythm/superfluxpeaks.h"
#if ENABLE_TENSORFLOW
#include "algorithms/rhythm/tempocnn.h"
#endif
#include "algorithms/rhythm/temposcalebands.h"
#include "algorithms/rhythm/tempotap.h"
#include "algorithms/rhythm/tempotapdegara.h"
#include "algorithms/rhythm/tempotapmaxagreement.h"
#include "algorithms/rhythm/tempotapticks.h"
#include "algorithms/sfx/aftermaxtobeforemaxenergyratio.h"
#include "algorithms/sfx/derivativesfx.h"
#include "algorithms/sfx/flatnesssfx.h"
#include "algorithms/sfx/logattacktime.h"
#include "algorithms/sfx/maxtototal.h"
#include "algorithms/sfx/mintototal.h"
#include "algorithms/sfx/pitchsalience.h"
#include "algorithms/sfx/strongdecay.h"
#include "algorithms/sfx/tctototal.h"
#include "algorithms/spectral/barkbands.h"
#include "algorithms/spectral/bfcc.h"
#include "algorithms/spectral/energyband.h"
#include "algorithms/spectral/energybandratio.h"
#include "algorithms/spectral/erbbands.h"
#include "algorithms/spectral/flatnessdb.h"
#include "algorithms/spectral/flux.h"
#include "algorithms/spectral/frequencybands.h"
#include "algorithms/spectral/gfcc.h"
#include "algorithms/spectral/hfc.h"
#include "algorithms/spectral/hpcp.h"
#include "algorithms/spectral/logspectrum.h"
#include "algorithms/spectral/maxmagfreq.h"
#include "algorithms/spectral/melbands.h"
#include "algorithms/spectral/mfcc.h"
#include "algorithms/spectral/panning.h"
#include "algorithms/spectral/rolloff.h"
#include "algorithms/spectral/spectralcentroidtime.h"
#include "algorithms/spectral/spectralcomplexity.h"
#include "algorithms/spectral/spectralcontrast.h"
#include "algorithms/spectral/spectralpeaks.h"
#include "algorithms/spectral/spectralwhitening.h"
#include "algorithms/spectral/spectrumtocent.h"
#include "algorithms/spectral/strongpeak.h"
#if ENABLE_TENSORFLOW
#include "algorithms/spectral/tensorflowinputfsdsinet.h"
#include "algorithms/spectral/tensorflowinputmusicnn.h"
#include "algorithms/spectral/tensorflowinputtempocnn.h"
#include "algorithms/spectral/tensorflowinputvggish.h"
#include "algorithms/machinelearning/tensorflowpredict.h"
#include "algorithms/machinelearning/tensorflowpredict2d.h"
#include "algorithms/machinelearning/tensorflowpredictcrepe.h"
#include "algorithms/machinelearning/tensorflowpredicteffnetdiscogs.h"
#include "algorithms/machinelearning/tensorflowpredictfsdsinet.h"
#include "algorithms/machinelearning/tensorflowpredictmaest.h"
#include "algorithms/machinelearning/tensorflowpredictmusicnn.h"
#include "algorithms/machinelearning/tensorflowpredicttempocnn.h"
#include "algorithms/machinelearning/tensorflowpredictvggish.h"
#endif
#include "algorithms/spectral/triangularbands.h"
#include "algorithms/spectral/triangularbarkbands.h"
#include "algorithms/standard/autocorrelation.h"
#include "algorithms/standard/binaryoperator.h"
#include "algorithms/standard/binaryoperatorstream.h"
#include "algorithms/standard/bpf.h"
#include "algorithms/standard/chromagram.h"
#include "algorithms/standard/clipper.h"
#include "algorithms/standard/constantq.h"
#include "algorithms/standard/crosscorrelation.h"
#include "algorithms/standard/cubicspline.h"
#include "algorithms/standard/dct.h"
#include "algorithms/standard/derivative.h"
#include "algorithms/standard/envelope.h"
#if ENABLE_FFTW
#include "algorithms/standard/fftw.h"
#include "algorithms/standard/fftwcomplex.h"
#include "algorithms/standard/ifftw.h"
#include "algorithms/standard/ifftwcomplex.h"
#elif ENABLE_KISS
#include "algorithms/standard/fftk.h"
#include "algorithms/standard/fftkcomplex.h"
#include "algorithms/standard/ifftk.h"
#include "algorithms/standard/ifftkcomplex.h"
#elif ENABLE_VDSP
#include "algorithms/standard/iffta.h"
#include "algorithms/standard/ifftacomplex.h"
#include "algorithms/standard/ffta.h"
#include "algorithms/standard/fftacomplex.h"
#endif
#include "algorithms/standard/framecutter.h"
#include "algorithms/standard/frametoreal.h"
#include "algorithms/standard/idct.h"
#include "algorithms/standard/maxfilter.h"
#include "algorithms/standard/minmax.h"
#include "algorithms/standard/monomixer.h"
#include "algorithms/standard/multiplexer.h"
#include "algorithms/standard/noiseadder.h"
#include "algorithms/standard/nsgconstantq.h"
#include "algorithms/standard/nsgconstantqstreaming.h"
#include "algorithms/standard/nsgiconstantq.h"
#include "algorithms/standard/overlapadd.h"
#include "algorithms/standard/peakdetection.h"
#include "algorithms/standard/pooltotensor.h"
#include "algorithms/standard/powerspectrum.h"
#include "algorithms/standard/realaccumulator.h"
#include "algorithms/standard/replaygain.h"
#if ENABLE_SAMPLERATE
#include "algorithms/standard/resample.h"
#endif
#include "algorithms/standard/scale.h"
#include "algorithms/standard/silencerate.h"
#include "algorithms/standard/slicer.h"
#include "algorithms/standard/spectrum.h"
#include "algorithms/standard/spectrumCQ.h"
#include "algorithms/standard/spline.h"
#include "algorithms/standard/startstopsilence.h"
#include "algorithms/standard/stereodemuxer.h"
#include "algorithms/standard/stereomuxer.h"
#include "algorithms/standard/stereotrimmer.h"
#include "algorithms/standard/tensornormalize.h"
#include "algorithms/standard/tensortopool.h"
#include "algorithms/standard/tensortovectorreal.h"
#include "algorithms/standard/tensortranspose.h"
#include "algorithms/standard/trimmer.h"
#include "algorithms/standard/unaryoperator.h"
#include "algorithms/standard/unaryoperatorstream.h"
#include "algorithms/standard/vectorrealaccumulator.h"
#include "algorithms/standard/vectorrealtotensor.h"
#include "algorithms/standard/viterbi.h"
#include "algorithms/standard/warpedautocorrelation.h"
#include "algorithms/standard/welch.h"
#include "algorithms/standard/windowing.h"
#include "algorithms/stats/centralmoments.h"
#include "algorithms/stats/centroid.h"
#include "algorithms/stats/crest.h"
#include "algorithms/stats/decrease.h"
#include "algorithms/stats/distributionshape.h"
#include "algorithms/stats/energy.h"
#include "algorithms/stats/entropy.h"
#include "algorithms/stats/flatness.h"
#include "algorithms/stats/geometricmean.h"
#include "algorithms/stats/histogram.h"
#include "algorithms/stats/instantpower.h"
#include "algorithms/stats/mean.h"
#include "algorithms/stats/median.h"
#include "algorithms/stats/poolaggregator.h"
#include "algorithms/stats/powermean.h"
#include "algorithms/stats/rawmoments.h"
#include "algorithms/stats/rms.h"
#include "algorithms/stats/singlegaussian.h"
#include "algorithms/stats/variance.h"
#include "algorithms/synthesis/harmonicmask.h"
#include "algorithms/synthesis/harmonicmodelanal.h"
#include "algorithms/synthesis/hprmodelanal.h"
#include "algorithms/synthesis/hpsmodelanal.h"
#include "algorithms/synthesis/resamplefft.h"
#include "algorithms/synthesis/sinemodelanal.h"
#include "algorithms/synthesis/sinemodelsynth.h"
#include "algorithms/synthesis/sinesubtraction.h"
#include "algorithms/synthesis/sprmodelanal.h"
#include "algorithms/synthesis/sprmodelsynth.h"
#include "algorithms/synthesis/spsmodelanal.h"
#include "algorithms/synthesis/spsmodelsynth.h"
#include "algorithms/synthesis/stochasticmodelanal.h"
#include "algorithms/synthesis/stochasticmodelsynth.h"
#include "algorithms/temporal/duration.h"
#include "algorithms/temporal/effectiveduration.h"
#include "algorithms/temporal/larm.h"
#include "algorithms/temporal/leq.h"
#include "algorithms/temporal/loudness.h"
#include "algorithms/temporal/loudnessebur128.h"
#include "algorithms/temporal/loudnessebur128filter.h"
#include "algorithms/temporal/loudnessvickers.h"
#include "algorithms/temporal/lpc.h"
#include "algorithms/temporal/zerocrossingrate.h"
#include "algorithms/tonal/chordsdescriptors.h"
#include "algorithms/tonal/chordsdetection.h"
#include "algorithms/tonal/chordsdetectionbeats.h"
#include "algorithms/tonal/dissonance.h"
#include "algorithms/tonal/harmonicpeaks.h"
#include "algorithms/tonal/highresolutionfeatures.h"
#include "algorithms/tonal/inharmonicity.h"
#include "algorithms/tonal/key.h"
#include "algorithms/tonal/multipitchklapuri.h"
#include "algorithms/tonal/multipitchmelodia.h"
#include "algorithms/tonal/nnlschroma.h"
#include "algorithms/tonal/oddtoevenharmonicenergyratio.h"
#include "algorithms/tonal/pitchcontours.h"
#include "algorithms/tonal/pitchcontoursegmentation.h"
#include "algorithms/tonal/pitchcontoursmelody.h"
#include "algorithms/tonal/pitchcontoursmonomelody.h"
#include "algorithms/tonal/pitchcontoursmultimelody.h"
#if ENABLE_TENSORFLOW
#include "algorithms/tonal/pitchcrepe.h"
#endif
#include "algorithms/tonal/pitchfilter.h"
#include "algorithms/tonal/pitchmelodia.h"
#include "algorithms/tonal/pitchsaliencefunction.h"
#include "algorithms/tonal/pitchsaliencefunctionpeaks.h"
#include "algorithms/tonal/pitchyin.h"
#include "algorithms/tonal/pitchyinfft.h"
#include "algorithms/tonal/pitchyinprobabilistic.h"
#include "algorithms/tonal/pitchyinprobabilities.h"
#include "algorithms/tonal/pitchyinprobabilitieshmm.h"
#include "algorithms/tonal/predominantpitchmelodia.h"
#include "algorithms/tonal/tonicindianartmusic.h"
#include "algorithms/tonal/tristimulus.h"
#include "algorithms/tonal/tuningfrequency.h"
#include "algorithms/tonal/vibrato.h"

namespace essentia {
namespace standard {

ESSENTIA_API void registerAlgorithm() {
    AlgorithmFactory::Registrar<ClickDetector> regClickDetector;
    AlgorithmFactory::Registrar<DiscontinuityDetector> regDiscontinuityDetector;
    AlgorithmFactory::Registrar<FalseStereoDetector> regFalseStereoDetector;
    AlgorithmFactory::Registrar<GapsDetector> regGapsDetector;
    AlgorithmFactory::Registrar<HumDetector> regHumDetector;
    AlgorithmFactory::Registrar<NoiseBurstDetector> regNoiseBurstDetector;
    AlgorithmFactory::Registrar<SaturationDetector> regSaturationDetector;
    AlgorithmFactory::Registrar<SNR> regSNR;
    AlgorithmFactory::Registrar<StartStopCut> regStartStopCut;
    AlgorithmFactory::Registrar<TruePeakDetector> regTruePeakDetector;
    AlgorithmFactory::Registrar<CartesianToPolar> regCartesianToPolar;
    AlgorithmFactory::Registrar<Magnitude> regMagnitude;
    AlgorithmFactory::Registrar<PolarToCartesian> regPolarToCartesian;
    AlgorithmFactory::Registrar<Beatogram> regBeatogram;
    AlgorithmFactory::Registrar<Meter> regMeter;
    AlgorithmFactory::Registrar<Extractor> regExtractor;
    AlgorithmFactory::Registrar<FreesoundExtractor> regFreesoundExtractor;
    AlgorithmFactory::Registrar<KeyExtractor> regKeyExtractor;
    AlgorithmFactory::Registrar<LevelExtractor> regLevelExtractor;
    AlgorithmFactory::Registrar<LowLevelSpectralEqloudExtractor> regLowLevelSpectralEqloudExtractor;
    AlgorithmFactory::Registrar<LowLevelSpectralExtractor> regLowLevelSpectralExtractor;
    AlgorithmFactory::Registrar<MusicExtractor> regMusicExtractor;
#if ENABLE_GAIA2
    AlgorithmFactory::Registrar<MusicExtractorSVM> regMusicExtractorSVM;
#endif
    AlgorithmFactory::Registrar<RhythmDescriptors> regRhythmDescriptors;
    AlgorithmFactory::Registrar<TonalExtractor> regTonalExtractor;
    AlgorithmFactory::Registrar<TuningFrequencyExtractor> regTuningFrequencyExtractor;
    AlgorithmFactory::Registrar<AllPass> regAllPass;
    AlgorithmFactory::Registrar<BandPass> regBandPass;
    AlgorithmFactory::Registrar<BandReject> regBandReject;
    AlgorithmFactory::Registrar<DCRemoval> regDCRemoval;
    AlgorithmFactory::Registrar<EqualLoudness> regEqualLoudness;
    AlgorithmFactory::Registrar<HighPass> regHighPass;
    AlgorithmFactory::Registrar<IIR> regIIR;
    AlgorithmFactory::Registrar<LowPass> regLowPass;
    AlgorithmFactory::Registrar<MedianFilter> regMedianFilter;
    AlgorithmFactory::Registrar<MovingAverage> regMovingAverage;
    AlgorithmFactory::Registrar<ChromaCrossSimilarity> regChromaCrossSimilarity;
#if ENABLE_CHROMAPRINT
    AlgorithmFactory::Registrar<Chromaprinter> regChromaprinter;
#endif
    AlgorithmFactory::Registrar<CoverSongSimilarity> regCoverSongSimilarity;
    AlgorithmFactory::Registrar<CrossSimilarityMatrix> regCrossSimilarityMatrix;
    AlgorithmFactory::Registrar<Danceability> regDanceability;
    AlgorithmFactory::Registrar<DynamicComplexity> regDynamicComplexity;
    AlgorithmFactory::Registrar<FadeDetection> regFadeDetection;
#if ENABLE_GAIA2
    AlgorithmFactory::Registrar<GaiaTransform> regGaiaTransform;
#endif
    AlgorithmFactory::Registrar<Intensity> regIntensity;
    AlgorithmFactory::Registrar<PCA> regPCA;
    AlgorithmFactory::Registrar<SBic> regSBic;
    AlgorithmFactory::Registrar<AudioOnsetsMarker> regAudioOnsetsMarker;
#if ENABLE_AUDIOLOADER
    AlgorithmFactory::Registrar<AudioLoader> regAudioLoader;
    AlgorithmFactory::Registrar<EasyLoader> regEasyLoader;
    AlgorithmFactory::Registrar<EqloudLoader> regEqloudLoader;
    AlgorithmFactory::Registrar<MonoLoader> regMonoLoader;
#endif
#if ENABLE_AUDIOWRITER
    AlgorithmFactory::Registrar<AudioWriter> regAudioWriter;
    AlgorithmFactory::Registrar<MonoWriter> regMonoWriter;
#endif
#if ENABLE_TAGLIB
    AlgorithmFactory::Registrar<MetadataReader> regMetadataReader;
#endif
#if ENABLE_YAML
    AlgorithmFactory::Registrar<YamlInput> regYamlInput;
#endif
    AlgorithmFactory::Registrar<YamlOutput> regYamlOutput;
    AlgorithmFactory::Registrar<BeatsLoudness> regBeatsLoudness;
    AlgorithmFactory::Registrar<BeatTrackerDegara> regBeatTrackerDegara;
    AlgorithmFactory::Registrar<BeatTrackerMultiFeature> regBeatTrackerMultiFeature;
    AlgorithmFactory::Registrar<BpmHistogram> regBpmHistogram;
    AlgorithmFactory::Registrar<BpmHistogramDescriptors> regBpmHistogramDescriptors;
    AlgorithmFactory::Registrar<BpmRubato> regBpmRubato;
    AlgorithmFactory::Registrar<HarmonicBpm> regHarmonicBpm;
    AlgorithmFactory::Registrar<LoopBpmConfidence> regLoopBpmConfidence;
    AlgorithmFactory::Registrar<LoopBpmEstimator> regLoopBpmEstimator;
    AlgorithmFactory::Registrar<NoveltyCurve> regNoveltyCurve;
    AlgorithmFactory::Registrar<NoveltyCurveFixedBpmEstimator> regNoveltyCurveFixedBpmEstimator;
    AlgorithmFactory::Registrar<OnsetDetection> regOnsetDetection;
    AlgorithmFactory::Registrar<OnsetDetectionGlobal> regOnsetDetectionGlobal;
    AlgorithmFactory::Registrar<OnsetRate> regOnsetRate;
    AlgorithmFactory::Registrar<Onsets> regOnsets;
    AlgorithmFactory::Registrar<PercivalBpmEstimator> regPercivalBpmEstimator;
    AlgorithmFactory::Registrar<PercivalEnhanceHarmonics> regPercivalEnhanceHarmonics;
    AlgorithmFactory::Registrar<PercivalEvaluatePulseTrains> regPercivalEvaluatePulseTrains;
    AlgorithmFactory::Registrar<RhythmExtractor> regRhythmExtractor;
    AlgorithmFactory::Registrar<RhythmExtractor2013> regRhythmExtractor2013;
    AlgorithmFactory::Registrar<RhythmTransform> regRhythmTransform;
    AlgorithmFactory::Registrar<SingleBeatLoudness> regSingleBeatLoudness;
    AlgorithmFactory::Registrar<SuperFluxExtractor> regSuperFluxExtractor;
    AlgorithmFactory::Registrar<SuperFluxNovelty> regSuperFluxNovelty;
    AlgorithmFactory::Registrar<SuperFluxPeaks> regSuperFluxPeaks;
#if ENABLE_TENSORFLOW
    AlgorithmFactory::Registrar<TempoCNN> regTempoCNN;
#endif
    AlgorithmFactory::Registrar<TempoScaleBands> regTempoScaleBands;
    AlgorithmFactory::Registrar<TempoTap> regTempoTap;
    AlgorithmFactory::Registrar<TempoTapDegara> regTempoTapDegara;
    AlgorithmFactory::Registrar<TempoTapMaxAgreement> regTempoTapMaxAgreement;
    AlgorithmFactory::Registrar<TempoTapTicks> regTempoTapTicks;
    AlgorithmFactory::Registrar<AfterMaxToBeforeMaxEnergyRatio> regAfterMaxToBeforeMaxEnergyRatio;
    AlgorithmFactory::Registrar<DerivativeSFX> regDerivativeSFX;
    AlgorithmFactory::Registrar<FlatnessSFX> regFlatnessSFX;
    AlgorithmFactory::Registrar<LogAttackTime> regLogAttackTime;
    AlgorithmFactory::Registrar<MaxToTotal> regMaxToTotal;
    AlgorithmFactory::Registrar<MinToTotal> regMinToTotal;
    AlgorithmFactory::Registrar<PitchSalience> regPitchSalience;
    AlgorithmFactory::Registrar<StrongDecay> regStrongDecay;
    AlgorithmFactory::Registrar<TCToTotal> regTCToTotal;
    AlgorithmFactory::Registrar<BarkBands> regBarkBands;
    AlgorithmFactory::Registrar<BFCC> regBFCC;
    AlgorithmFactory::Registrar<EnergyBand> regEnergyBand;
    AlgorithmFactory::Registrar<EnergyBandRatio> regEnergyBandRatio;
    AlgorithmFactory::Registrar<ERBBands> regERBBands;
    AlgorithmFactory::Registrar<FlatnessDB> regFlatnessDB;
    AlgorithmFactory::Registrar<Flux> regFlux;
    AlgorithmFactory::Registrar<FrequencyBands> regFrequencyBands;
    AlgorithmFactory::Registrar<GFCC> regGFCC;
    AlgorithmFactory::Registrar<HFC> regHFC;
    AlgorithmFactory::Registrar<HPCP> regHPCP;
    AlgorithmFactory::Registrar<LogSpectrum> regLogSpectrum;
    AlgorithmFactory::Registrar<MaxMagFreq> regMaxMagFreq;
    AlgorithmFactory::Registrar<MelBands> regMelBands;
    AlgorithmFactory::Registrar<MFCC> regMFCC;
    AlgorithmFactory::Registrar<Panning> regPanning;
    AlgorithmFactory::Registrar<RollOff> regRollOff;
    AlgorithmFactory::Registrar<SpectralCentroidTime> regSpectralCentroidTime;
    AlgorithmFactory::Registrar<SpectralComplexity> regSpectralComplexity;
    AlgorithmFactory::Registrar<SpectralContrast> regSpectralContrast;
    AlgorithmFactory::Registrar<SpectralPeaks> regSpectralPeaks;
    AlgorithmFactory::Registrar<SpectralWhitening> regSpectralWhitening;
    AlgorithmFactory::Registrar<SpectrumToCent> regSpectrumToCent;
    AlgorithmFactory::Registrar<StrongPeak> regStrongPeak;
#if ENABLE_TENSORFLOW
    AlgorithmFactory::Registrar<TensorflowInputFSDSINet> regTensorflowInputFSDSINet;
    AlgorithmFactory::Registrar<TensorflowInputMusiCNN> regTensorflowInputMusiCNN;
    AlgorithmFactory::Registrar<TensorflowInputTempoCNN> regTensorflowInputTempoCNN;
    AlgorithmFactory::Registrar<TensorflowInputVGGish> regTensorflowInputVGGish;
    AlgorithmFactory::Registrar<TensorflowPredict> regTensorflowPredict;
    AlgorithmFactory::Registrar<TensorflowPredict2D> regTensorflowPredict2D;
    AlgorithmFactory::Registrar<TensorflowPredictCREPE> regTensorflowPredictCREPE;
    AlgorithmFactory::Registrar<TensorflowPredictEffnetDiscogs> regTensorflowPredictEffnetDiscogs;
    AlgorithmFactory::Registrar<TensorflowPredictFSDSINet> regTensorflowPredictFSDSINet;
    AlgorithmFactory::Registrar<TensorflowPredictMAEST> regTensorflowPredictMAEST;
    AlgorithmFactory::Registrar<TensorflowPredictMusiCNN> regTensorflowPredictMusiCNN;
    AlgorithmFactory::Registrar<TensorflowPredictTempoCNN> regTensorflowPredictTempoCNN;
    AlgorithmFactory::Registrar<TensorflowPredictVGGish> regTensorflowPredictVGGish;
#endif
    AlgorithmFactory::Registrar<TriangularBands> regTriangularBands;
    AlgorithmFactory::Registrar<TriangularBarkBands> regTriangularBarkBands;
    AlgorithmFactory::Registrar<AutoCorrelation> regAutoCorrelation;
    AlgorithmFactory::Registrar<BinaryOperator> regBinaryOperator;
    AlgorithmFactory::Registrar<BinaryOperatorStream> regBinaryOperatorStream;
    AlgorithmFactory::Registrar<BPF> regBPF;
    AlgorithmFactory::Registrar<Chromagram> regChromagram;
    AlgorithmFactory::Registrar<Clipper> regClipper;
    AlgorithmFactory::Registrar<ConstantQ> regConstantQ;
    AlgorithmFactory::Registrar<CrossCorrelation> regCrossCorrelation;
    AlgorithmFactory::Registrar<CubicSpline> regCubicSpline;
    AlgorithmFactory::Registrar<DCT> regDCT;
    AlgorithmFactory::Registrar<Derivative> regDerivative;
    AlgorithmFactory::Registrar<Envelope> regEnvelope;
#if ENABLE_FFTW
    AlgorithmFactory::Registrar<FFTW> regFFTW;
    AlgorithmFactory::Registrar<FFTWComplex> regFFTWComplex;
    AlgorithmFactory::Registrar<IFFTW> regIFFTW;
    AlgorithmFactory::Registrar<IFFTWComplex> regIFFTWComplex;
#elif ENABLE_KISS
    AlgorithmFactory::Registrar<FFTK> regFFTK;
    AlgorithmFactory::Registrar<FFTKComplex> regFFTKComplex;
    AlgorithmFactory::Registrar<IFFTK> regIFFTK;
    AlgorithmFactory::Registrar<IFFTKComplex> regIFFTKComplex;
#elif ENABLE_VDSP
    AlgorithmFactory::Registrar<FFTA> regFFTA;
    AlgorithmFactory::Registrar<FFTAComplex> regFFTAComplex;
    AlgorithmFactory::Registrar<IFFTA> regIFFTA;
    AlgorithmFactory::Registrar<IFFTAComplex> regIFFTAComplex;
#endif
    AlgorithmFactory::Registrar<FrameCutter> regFrameCutter;
    AlgorithmFactory::Registrar<FrameToReal> regFrameToReal;
    AlgorithmFactory::Registrar<IDCT> regIDCT;
    AlgorithmFactory::Registrar<MaxFilter> regMaxFilter;
    AlgorithmFactory::Registrar<MinMax> regMinMax;
    AlgorithmFactory::Registrar<MonoMixer> regMonoMixer;
    AlgorithmFactory::Registrar<Multiplexer> regMultiplexer;
    AlgorithmFactory::Registrar<NoiseAdder> regNoiseAdder;
    AlgorithmFactory::Registrar<NSGConstantQ> regNSGConstantQ;
    AlgorithmFactory::Registrar<NSGIConstantQ> regNSGIConstantQ;
    AlgorithmFactory::Registrar<OverlapAdd> regOverlapAdd;
    AlgorithmFactory::Registrar<PeakDetection> regPeakDetection;
    AlgorithmFactory::Registrar<PowerSpectrum> regPowerSpectrum;
    AlgorithmFactory::Registrar<ReplayGain> regReplayGain;
#if ENABLE_SAMPLERATE
    AlgorithmFactory::Registrar<Resample> regResample;
#endif
    AlgorithmFactory::Registrar<Scale> regScale;
    AlgorithmFactory::Registrar<SilenceRate> regSilenceRate;
    AlgorithmFactory::Registrar<Slicer> regSlicer;
    AlgorithmFactory::Registrar<Spectrum> regSpectrum;
    AlgorithmFactory::Registrar<SpectrumCQ> regSpectrumCQ;
    AlgorithmFactory::Registrar<Spline> regSpline;
    AlgorithmFactory::Registrar<StartStopSilence> regStartStopSilence;
    AlgorithmFactory::Registrar<StereoDemuxer> regStereoDemuxer;
    AlgorithmFactory::Registrar<StereoMuxer> regStereoMuxer;
    AlgorithmFactory::Registrar<StereoTrimmer> regStereoTrimmer;
    AlgorithmFactory::Registrar<TensorNormalize> regTensorNormalize;
    AlgorithmFactory::Registrar<TensorTranspose> regTensorTranspose;
    AlgorithmFactory::Registrar<Trimmer> regTrimmer;
    AlgorithmFactory::Registrar<UnaryOperator> regUnaryOperator;
    AlgorithmFactory::Registrar<UnaryOperatorStream> regUnaryOperatorStream;
    AlgorithmFactory::Registrar<Viterbi> regViterbi;
    AlgorithmFactory::Registrar<WarpedAutoCorrelation> regWarpedAutoCorrelation;
    AlgorithmFactory::Registrar<Welch> regWelch;
    AlgorithmFactory::Registrar<Windowing> regWindowing;
    AlgorithmFactory::Registrar<CentralMoments> regCentralMoments;
    AlgorithmFactory::Registrar<Centroid> regCentroid;
    AlgorithmFactory::Registrar<Crest> regCrest;
    AlgorithmFactory::Registrar<Decrease> regDecrease;
    AlgorithmFactory::Registrar<DistributionShape> regDistributionShape;
    AlgorithmFactory::Registrar<Energy> regEnergy;
    AlgorithmFactory::Registrar<Entropy> regEntropy;
    AlgorithmFactory::Registrar<Flatness> regFlatness;
    AlgorithmFactory::Registrar<GeometricMean> regGeometricMean;
    AlgorithmFactory::Registrar<Histogram> regHistogram;
    AlgorithmFactory::Registrar<InstantPower> regInstantPower;
    AlgorithmFactory::Registrar<Mean> regMean;
    AlgorithmFactory::Registrar<Median> regMedian;
    AlgorithmFactory::Registrar<PoolAggregator> regPoolAggregator;
    AlgorithmFactory::Registrar<PowerMean> regPowerMean;
    AlgorithmFactory::Registrar<RawMoments> regRawMoments;
    AlgorithmFactory::Registrar<RMS> regRMS;
    AlgorithmFactory::Registrar<SingleGaussian> regSingleGaussian;
    AlgorithmFactory::Registrar<Variance> regVariance;
    AlgorithmFactory::Registrar<HarmonicMask> regHarmonicMask;
    AlgorithmFactory::Registrar<HarmonicModelAnal> regHarmonicModelAnal;
    AlgorithmFactory::Registrar<HprModelAnal> regHprModelAnal;
    AlgorithmFactory::Registrar<HpsModelAnal> regHpsModelAnal;
    AlgorithmFactory::Registrar<ResampleFFT> regResampleFFT;
    AlgorithmFactory::Registrar<SineModelAnal> regSineModelAnal;
    AlgorithmFactory::Registrar<SineModelSynth> regSineModelSynth;
    AlgorithmFactory::Registrar<SineSubtraction> regSineSubtraction;
    AlgorithmFactory::Registrar<SprModelAnal> regSprModelAnal;
    AlgorithmFactory::Registrar<SprModelSynth> regSprModelSynth;
    AlgorithmFactory::Registrar<SpsModelAnal> regSpsModelAnal;
    AlgorithmFactory::Registrar<SpsModelSynth> regSpsModelSynth;
    AlgorithmFactory::Registrar<StochasticModelAnal> regStochasticModelAnal;
    AlgorithmFactory::Registrar<StochasticModelSynth> regStochasticModelSynth;
    AlgorithmFactory::Registrar<Duration> regDuration;
    AlgorithmFactory::Registrar<EffectiveDuration> regEffectiveDuration;
    AlgorithmFactory::Registrar<Larm> regLarm;
    AlgorithmFactory::Registrar<Leq> regLeq;
    AlgorithmFactory::Registrar<Loudness> regLoudness;
    AlgorithmFactory::Registrar<LoudnessEBUR128> regLoudnessEBUR128;
    AlgorithmFactory::Registrar<LoudnessVickers> regLoudnessVickers;
    AlgorithmFactory::Registrar<LPC> regLPC;
    AlgorithmFactory::Registrar<ZeroCrossingRate> regZeroCrossingRate;
    AlgorithmFactory::Registrar<ChordsDescriptors> regChordsDescriptors;
    AlgorithmFactory::Registrar<ChordsDetection> regChordsDetection;
    AlgorithmFactory::Registrar<ChordsDetectionBeats> regChordsDetectionBeats;
    AlgorithmFactory::Registrar<Dissonance> regDissonance;
    AlgorithmFactory::Registrar<HarmonicPeaks> regHarmonicPeaks;
    AlgorithmFactory::Registrar<HighResolutionFeatures> regHighResolutionFeatures;
    AlgorithmFactory::Registrar<Inharmonicity> regInharmonicity;
    AlgorithmFactory::Registrar<Key> regKey;
    AlgorithmFactory::Registrar<MultiPitchKlapuri> regMultiPitchKlapuri;
    AlgorithmFactory::Registrar<MultiPitchMelodia> regMultiPitchMelodia;
    AlgorithmFactory::Registrar<NNLSChroma> regNNLSChroma;
    AlgorithmFactory::Registrar<OddToEvenHarmonicEnergyRatio> regOddToEvenHarmonicEnergyRatio;
    AlgorithmFactory::Registrar<PitchContours> regPitchContours;
    AlgorithmFactory::Registrar<PitchContourSegmentation> regPitchContourSegmentation;
    AlgorithmFactory::Registrar<PitchContoursMelody> regPitchContoursMelody;
    AlgorithmFactory::Registrar<PitchContoursMonoMelody> regPitchContoursMonoMelody;
    AlgorithmFactory::Registrar<PitchContoursMultiMelody> regPitchContoursMultiMelody;
#if ENABLE_TENSORFLOW
    AlgorithmFactory::Registrar<PitchCREPE> regPitchCREPE;
#endif
    AlgorithmFactory::Registrar<PitchFilter> regPitchFilter;
    AlgorithmFactory::Registrar<PitchMelodia> regPitchMelodia;
    AlgorithmFactory::Registrar<PitchSalienceFunction> regPitchSalienceFunction;
    AlgorithmFactory::Registrar<PitchSalienceFunctionPeaks> regPitchSalienceFunctionPeaks;
    AlgorithmFactory::Registrar<PitchYin> regPitchYin;
    AlgorithmFactory::Registrar<PitchYinFFT> regPitchYinFFT;
    AlgorithmFactory::Registrar<PitchYinProbabilistic> regPitchYinProbabilistic;
    AlgorithmFactory::Registrar<PitchYinProbabilities> regPitchYinProbabilities;
    AlgorithmFactory::Registrar<PitchYinProbabilitiesHMM> regPitchYinProbabilitiesHMM;
    AlgorithmFactory::Registrar<PredominantPitchMelodia> regPredominantPitchMelodia;
    AlgorithmFactory::Registrar<TonicIndianArtMusic> regTonicIndianArtMusic;
    AlgorithmFactory::Registrar<Tristimulus> regTristimulus;
    AlgorithmFactory::Registrar<TuningFrequency> regTuningFrequency;
    AlgorithmFactory::Registrar<Vibrato> regVibrato;
}}}



namespace essentia {
namespace streaming {

ESSENTIA_API void registerAlgorithm() {
    AlgorithmFactory::Registrar<ClickDetector, essentia::standard::ClickDetector> regClickDetector;
    AlgorithmFactory::Registrar<DiscontinuityDetector, essentia::standard::DiscontinuityDetector> regDiscontinuityDetector;
    AlgorithmFactory::Registrar<FalseStereoDetector, essentia::standard::FalseStereoDetector> regFalseStereoDetector;
    AlgorithmFactory::Registrar<GapsDetector, essentia::standard::GapsDetector> regGapsDetector;
    AlgorithmFactory::Registrar<HumDetector, essentia::standard::HumDetector> regHumDetector;
    AlgorithmFactory::Registrar<NoiseBurstDetector, essentia::standard::NoiseBurstDetector> regNoiseBurstDetector;
    AlgorithmFactory::Registrar<SaturationDetector, essentia::standard::SaturationDetector> regSaturationDetector;
    AlgorithmFactory::Registrar<SNR, essentia::standard::SNR> regSNR;
    AlgorithmFactory::Registrar<StartStopCut, essentia::standard::StartStopCut> regStartStopCut;
    AlgorithmFactory::Registrar<TruePeakDetector, essentia::standard::TruePeakDetector> regTruePeakDetector;
    AlgorithmFactory::Registrar<CartesianToPolar, essentia::standard::CartesianToPolar> regCartesianToPolar;
    AlgorithmFactory::Registrar<Magnitude, essentia::standard::Magnitude> regMagnitude;
    AlgorithmFactory::Registrar<PolarToCartesian, essentia::standard::PolarToCartesian> regPolarToCartesian;
    AlgorithmFactory::Registrar<Beatogram, essentia::standard::Beatogram> regBeatogram;
    AlgorithmFactory::Registrar<Meter, essentia::standard::Meter> regMeter;
    AlgorithmFactory::Registrar<BarkExtractor> regBarkExtractor;
    AlgorithmFactory::Registrar<KeyExtractor, essentia::standard::KeyExtractor> regKeyExtractor;
    AlgorithmFactory::Registrar<LevelExtractor, essentia::standard::LevelExtractor> regLevelExtractor;
    AlgorithmFactory::Registrar<LowLevelSpectralEqloudExtractor, essentia::standard::LowLevelSpectralEqloudExtractor> regLowLevelSpectralEqloudExtractor;
    AlgorithmFactory::Registrar<LowLevelSpectralExtractor, essentia::standard::LowLevelSpectralExtractor> regLowLevelSpectralExtractor;
    AlgorithmFactory::Registrar<RhythmDescriptors, essentia::standard::RhythmDescriptors> regRhythmDescriptors;
    AlgorithmFactory::Registrar<TonalExtractor, essentia::standard::TonalExtractor> regTonalExtractor;
    AlgorithmFactory::Registrar<TuningFrequencyExtractor, essentia::standard::TuningFrequencyExtractor> regTuningFrequencyExtractor;
    AlgorithmFactory::Registrar<AllPass, essentia::standard::AllPass> regAllPass;
    AlgorithmFactory::Registrar<BandPass, essentia::standard::BandPass> regBandPass;
    AlgorithmFactory::Registrar<BandReject, essentia::standard::BandReject> regBandReject;
    AlgorithmFactory::Registrar<DCRemoval, essentia::standard::DCRemoval> regDCRemoval;
    AlgorithmFactory::Registrar<EqualLoudness, essentia::standard::EqualLoudness> regEqualLoudness;
    AlgorithmFactory::Registrar<HighPass, essentia::standard::HighPass> regHighPass;
    AlgorithmFactory::Registrar<IIR, essentia::standard::IIR> regIIR;
    AlgorithmFactory::Registrar<LowPass, essentia::standard::LowPass> regLowPass;
    AlgorithmFactory::Registrar<MedianFilter, essentia::standard::MedianFilter> regMedianFilter;
    AlgorithmFactory::Registrar<MovingAverage, essentia::standard::MovingAverage> regMovingAverage;
    AlgorithmFactory::Registrar<ChromaCrossSimilarity, essentia::standard::ChromaCrossSimilarity> regChromaCrossSimilarity;
#if ENABLE_CHROMAPRINT
    AlgorithmFactory::Registrar<Chromaprinter, essentia::standard::Chromaprinter> regChromaprinter;
#endif
    AlgorithmFactory::Registrar<CoverSongSimilarity, essentia::standard::CoverSongSimilarity> regCoverSongSimilarity;
    AlgorithmFactory::Registrar<Danceability, essentia::standard::Danceability> regDanceability;
    AlgorithmFactory::Registrar<DynamicComplexity, essentia::standard::DynamicComplexity> regDynamicComplexity;
    AlgorithmFactory::Registrar<FadeDetection, essentia::standard::FadeDetection> regFadeDetection;
    AlgorithmFactory::Registrar<SBic, essentia::standard::SBic> regSBic;
    AlgorithmFactory::Registrar<AudioOnsetsMarker, essentia::standard::AudioOnsetsMarker> regAudioOnsetsMarker;
#if ENABLE_AUDIOLOADER
    AlgorithmFactory::Registrar<AudioLoader, essentia::standard::AudioLoader> regAudioLoader;
    AlgorithmFactory::Registrar<EasyLoader, essentia::standard::EasyLoader> regEasyLoader;
#endif
#if ENABLE_AUDIOWRITER
    AlgorithmFactory::Registrar<EqloudLoader, essentia::standard::EqloudLoader> regEqloudLoader;
    AlgorithmFactory::Registrar<MonoLoader, essentia::standard::MonoLoader> regMonoLoader;
    AlgorithmFactory::Registrar<AudioWriter, essentia::standard::AudioWriter> regAudioWriter;
    AlgorithmFactory::Registrar<MonoWriter, essentia::standard::MonoWriter> regMonoWriter;
#endif
    AlgorithmFactory::Registrar<FileOutputProxy> regFileOutputProxy;
#if ENABLE_TAGLIB
    AlgorithmFactory::Registrar<MetadataReader, essentia::standard::MetadataReader> regMetadataReader;
#endif
    AlgorithmFactory::Registrar<BeatsLoudness, essentia::standard::BeatsLoudness> regBeatsLoudness;
    AlgorithmFactory::Registrar<BeatTrackerDegara, essentia::standard::BeatTrackerDegara> regBeatTrackerDegara;
    AlgorithmFactory::Registrar<BeatTrackerMultiFeature, essentia::standard::BeatTrackerMultiFeature> regBeatTrackerMultiFeature;
    AlgorithmFactory::Registrar<BpmHistogram, essentia::standard::BpmHistogram> regBpmHistogram;
    AlgorithmFactory::Registrar<BpmHistogramDescriptors, essentia::standard::BpmHistogramDescriptors> regBpmHistogramDescriptors;
    AlgorithmFactory::Registrar<BpmRubato, essentia::standard::BpmRubato> regBpmRubato;
    AlgorithmFactory::Registrar<HarmonicBpm, essentia::standard::HarmonicBpm> regHarmonicBpm;
    AlgorithmFactory::Registrar<LoopBpmConfidence, essentia::standard::LoopBpmConfidence> regLoopBpmConfidence;
    AlgorithmFactory::Registrar<LoopBpmEstimator, essentia::standard::LoopBpmEstimator> regLoopBpmEstimator;
    AlgorithmFactory::Registrar<NoveltyCurve, essentia::standard::NoveltyCurve> regNoveltyCurve;
    AlgorithmFactory::Registrar<OnsetDetection, essentia::standard::OnsetDetection> regOnsetDetection;
    AlgorithmFactory::Registrar<OnsetDetectionGlobal, essentia::standard::OnsetDetectionGlobal> regOnsetDetectionGlobal;
    AlgorithmFactory::Registrar<OnsetRate, essentia::standard::OnsetRate> regOnsetRate;
    AlgorithmFactory::Registrar<Onsets, essentia::standard::Onsets> regOnsets;
    AlgorithmFactory::Registrar<PercivalBpmEstimator, essentia::standard::PercivalBpmEstimator> regPercivalBpmEstimator;
    AlgorithmFactory::Registrar<PercivalEnhanceHarmonics, essentia::standard::PercivalEnhanceHarmonics> regPercivalEnhanceHarmonics;
    AlgorithmFactory::Registrar<PercivalEvaluatePulseTrains, essentia::standard::PercivalEvaluatePulseTrains> regPercivalEvaluatePulseTrains;
    AlgorithmFactory::Registrar<RhythmExtractor, essentia::standard::RhythmExtractor> regRhythmExtractor;
    AlgorithmFactory::Registrar<RhythmExtractor2013, essentia::standard::RhythmExtractor2013> regRhythmExtractor2013;
    AlgorithmFactory::Registrar<RhythmTransform, essentia::standard::RhythmTransform> regRhythmTransform;
    AlgorithmFactory::Registrar<SingleBeatLoudness, essentia::standard::SingleBeatLoudness> regSingleBeatLoudness;
    AlgorithmFactory::Registrar<SuperFluxExtractor, essentia::standard::SuperFluxExtractor> regSuperFluxExtractor;
    AlgorithmFactory::Registrar<SuperFluxNovelty, essentia::standard::SuperFluxNovelty> regSuperFluxNovelty;
    AlgorithmFactory::Registrar<SuperFluxPeaks, essentia::standard::SuperFluxPeaks> regSuperFluxPeaks;
#if ENABLE_TENSORFLOW
    AlgorithmFactory::Registrar<TempoCNN, essentia::standard::TempoCNN> regTempoCNN;
#endif
    AlgorithmFactory::Registrar<TempoScaleBands, essentia::standard::TempoScaleBands> regTempoScaleBands;
    AlgorithmFactory::Registrar<TempoTap, essentia::standard::TempoTap> regTempoTap;
    AlgorithmFactory::Registrar<TempoTapDegara, essentia::standard::TempoTapDegara> regTempoTapDegara;
    AlgorithmFactory::Registrar<TempoTapMaxAgreement, essentia::standard::TempoTapMaxAgreement> regTempoTapMaxAgreement;
    AlgorithmFactory::Registrar<TempoTapTicks, essentia::standard::TempoTapTicks> regTempoTapTicks;
    AlgorithmFactory::Registrar<AfterMaxToBeforeMaxEnergyRatio, essentia::standard::AfterMaxToBeforeMaxEnergyRatio> regAfterMaxToBeforeMaxEnergyRatio;
    AlgorithmFactory::Registrar<DerivativeSFX, essentia::standard::DerivativeSFX> regDerivativeSFX;
    AlgorithmFactory::Registrar<FlatnessSFX, essentia::standard::FlatnessSFX> regFlatnessSFX;
    AlgorithmFactory::Registrar<LogAttackTime, essentia::standard::LogAttackTime> regLogAttackTime;
    AlgorithmFactory::Registrar<MaxToTotal, essentia::standard::MaxToTotal> regMaxToTotal;
    AlgorithmFactory::Registrar<MinToTotal, essentia::standard::MinToTotal> regMinToTotal;
    AlgorithmFactory::Registrar<PitchSalience, essentia::standard::PitchSalience> regPitchSalience;
    AlgorithmFactory::Registrar<StrongDecay, essentia::standard::StrongDecay> regStrongDecay;
    AlgorithmFactory::Registrar<TCToTotal, essentia::standard::TCToTotal> regTCToTotal;
    AlgorithmFactory::Registrar<BarkBands, essentia::standard::BarkBands> regBarkBands;
    AlgorithmFactory::Registrar<BFCC, essentia::standard::BFCC> regBFCC;
    AlgorithmFactory::Registrar<EnergyBand, essentia::standard::EnergyBand> regEnergyBand;
    AlgorithmFactory::Registrar<EnergyBandRatio, essentia::standard::EnergyBandRatio> regEnergyBandRatio;
    AlgorithmFactory::Registrar<ERBBands, essentia::standard::ERBBands> regERBBands;
    AlgorithmFactory::Registrar<FlatnessDB, essentia::standard::FlatnessDB> regFlatnessDB;
    AlgorithmFactory::Registrar<Flux, essentia::standard::Flux> regFlux;
    AlgorithmFactory::Registrar<FrequencyBands, essentia::standard::FrequencyBands> regFrequencyBands;
    AlgorithmFactory::Registrar<GFCC, essentia::standard::GFCC> regGFCC;
    AlgorithmFactory::Registrar<HFC, essentia::standard::HFC> regHFC;
    AlgorithmFactory::Registrar<HPCP, essentia::standard::HPCP> regHPCP;
    AlgorithmFactory::Registrar<LogSpectrum, essentia::standard::LogSpectrum> regLogSpectrum;
    AlgorithmFactory::Registrar<MaxMagFreq, essentia::standard::MaxMagFreq> regMaxMagFreq;
    AlgorithmFactory::Registrar<MelBands, essentia::standard::MelBands> regMelBands;
    AlgorithmFactory::Registrar<MFCC, essentia::standard::MFCC> regMFCC;
    AlgorithmFactory::Registrar<Panning, essentia::standard::Panning> regPanning;
    AlgorithmFactory::Registrar<RollOff, essentia::standard::RollOff> regRollOff;
    AlgorithmFactory::Registrar<SpectralCentroidTime, essentia::standard::SpectralCentroidTime> regSpectralCentroidTime;
    AlgorithmFactory::Registrar<SpectralComplexity, essentia::standard::SpectralComplexity> regSpectralComplexity;
    AlgorithmFactory::Registrar<SpectralContrast, essentia::standard::SpectralContrast> regSpectralContrast;
    AlgorithmFactory::Registrar<SpectralPeaks, essentia::standard::SpectralPeaks> regSpectralPeaks;
    AlgorithmFactory::Registrar<SpectralWhitening, essentia::standard::SpectralWhitening> regSpectralWhitening;
    AlgorithmFactory::Registrar<SpectrumToCent, essentia::standard::SpectrumToCent> regSpectrumToCent;
    AlgorithmFactory::Registrar<StrongPeak, essentia::standard::StrongPeak> regStrongPeak;
#if ENABLE_TENSORFLOW
    AlgorithmFactory::Registrar<TensorflowInputFSDSINet, essentia::standard::TensorflowInputFSDSINet> regTensorflowInputFSDSINet;
    AlgorithmFactory::Registrar<TensorflowInputMusiCNN, essentia::standard::TensorflowInputMusiCNN> regTensorflowInputMusiCNN;
    AlgorithmFactory::Registrar<TensorflowInputTempoCNN, essentia::standard::TensorflowInputTempoCNN> regTensorflowInputTempoCNN;
    AlgorithmFactory::Registrar<TensorflowInputVGGish, essentia::standard::TensorflowInputVGGish> regTensorflowInputVGGish;
    AlgorithmFactory::Registrar<TensorflowPredict, essentia::standard::TensorflowPredict> regTensorflowPredict;
    AlgorithmFactory::Registrar<TensorflowPredict2D, essentia::standard::TensorflowPredict2D> regTensorflowPredict2D;
    AlgorithmFactory::Registrar<TensorflowPredictCREPE, essentia::standard::TensorflowPredictCREPE> regTensorflowPredictCREPE;
    AlgorithmFactory::Registrar<TensorflowPredictEffnetDiscogs, essentia::standard::TensorflowPredictEffnetDiscogs> regTensorflowPredictEffnetDiscogs;
    AlgorithmFactory::Registrar<TensorflowPredictFSDSINet, essentia::standard::TensorflowPredictFSDSINet> regTensorflowPredictFSDSINet;
    AlgorithmFactory::Registrar<TensorflowPredictMAEST, essentia::standard::TensorflowPredictMAEST> regTensorflowPredictMAEST;
    AlgorithmFactory::Registrar<TensorflowPredictMusiCNN, essentia::standard::TensorflowPredictMusiCNN> regTensorflowPredictMusiCNN;
    AlgorithmFactory::Registrar<TensorflowPredictTempoCNN, essentia::standard::TensorflowPredictTempoCNN> regTensorflowPredictTempoCNN;
    AlgorithmFactory::Registrar<TensorflowPredictVGGish, essentia::standard::TensorflowPredictVGGish> regTensorflowPredictVGGish;
#endif
    AlgorithmFactory::Registrar<TriangularBands, essentia::standard::TriangularBands> regTriangularBands;
    AlgorithmFactory::Registrar<TriangularBarkBands, essentia::standard::TriangularBarkBands> regTriangularBarkBands;
    AlgorithmFactory::Registrar<AutoCorrelation, essentia::standard::AutoCorrelation> regAutoCorrelation;
    AlgorithmFactory::Registrar<BinaryOperator, essentia::standard::BinaryOperator> regBinaryOperator;
    AlgorithmFactory::Registrar<BinaryOperatorStream, essentia::standard::BinaryOperatorStream> regBinaryOperatorStream;
    AlgorithmFactory::Registrar<BPF, essentia::standard::BPF> regBPF;
    AlgorithmFactory::Registrar<Chromagram, essentia::standard::Chromagram> regChromagram;
    AlgorithmFactory::Registrar<Clipper, essentia::standard::Clipper> regClipper;
    AlgorithmFactory::Registrar<ConstantQ, essentia::standard::ConstantQ> regConstantQ;
    AlgorithmFactory::Registrar<CrossCorrelation, essentia::standard::CrossCorrelation> regCrossCorrelation;
    AlgorithmFactory::Registrar<CubicSpline, essentia::standard::CubicSpline> regCubicSpline;
    AlgorithmFactory::Registrar<DCT, essentia::standard::DCT> regDCT;
    AlgorithmFactory::Registrar<Derivative, essentia::standard::Derivative> regDerivative;
    AlgorithmFactory::Registrar<Envelope, essentia::standard::Envelope> regEnvelope;
#if ENABLE_FFTW
    AlgorithmFactory::Registrar<FFTW, essentia::standard::FFTW> regFFTW;
    AlgorithmFactory::Registrar<FFTWComplex, essentia::standard::FFTWComplex> regFFTWComplex;
    AlgorithmFactory::Registrar<IFFTW, essentia::standard::IFFTW> regIFFTW;
    AlgorithmFactory::Registrar<IFFTWComplex, essentia::standard::IFFTWComplex> regIFFTWComplex;
#elif ENABLE_KISS
    AlgorithmFactory::Registrar<FFTK, essentia::standard::FFTK> regFFTK;
    AlgorithmFactory::Registrar<FFTKComplex, essentia::standard::FFTKComplex> regFFTKComplex;
    AlgorithmFactory::Registrar<IFFTK, essentia::standard::IFFTK> regIFFTK;
    AlgorithmFactory::Registrar<IFFTKComplex, essentia::standard::IFFTKComplex> regIFFTKComplex;
#elif ENABLE_VDSP
    AlgorithmFactory::Registrar<FFTA, essentia::standard::FFTA> regFFTA;
    AlgorithmFactory::Registrar<FFTAComplex, essentia::standard::FFTAComplex> regFFTAComplex;
    AlgorithmFactory::Registrar<IFFTA, essentia::standard::IFFTA> regIFFTA;
    AlgorithmFactory::Registrar<IFFTAComplex, essentia::standard::IFFTAComplex> regIFFTAComplex;
#endif
    AlgorithmFactory::Registrar<FrameCutter, essentia::standard::FrameCutter> regFrameCutter;
    AlgorithmFactory::Registrar<FrameToReal, essentia::standard::FrameToReal> regFrameToReal;
    AlgorithmFactory::Registrar<IDCT, essentia::standard::IDCT> regIDCT;
    AlgorithmFactory::Registrar<MaxFilter, essentia::standard::MaxFilter> regMaxFilter;
    AlgorithmFactory::Registrar<MinMax, essentia::standard::MinMax> regMinMax;
    AlgorithmFactory::Registrar<MonoMixer, essentia::standard::MonoMixer> regMonoMixer;
    AlgorithmFactory::Registrar<Multiplexer, essentia::standard::Multiplexer> regMultiplexer;
    AlgorithmFactory::Registrar<NoiseAdder, essentia::standard::NoiseAdder> regNoiseAdder;
    AlgorithmFactory::Registrar<NSGConstantQ, essentia::standard::NSGConstantQ> regNSGConstantQ;
    AlgorithmFactory::Registrar<NSGConstantQStreaming> regNSGConstantQStreaming;
    AlgorithmFactory::Registrar<NSGIConstantQ, essentia::standard::NSGIConstantQ> regNSGIConstantQ;
    AlgorithmFactory::Registrar<OverlapAdd, essentia::standard::OverlapAdd> regOverlapAdd;
    AlgorithmFactory::Registrar<PeakDetection, essentia::standard::PeakDetection> regPeakDetection;
    AlgorithmFactory::Registrar<PoolToTensor> regPoolToTensor;
    AlgorithmFactory::Registrar<PowerSpectrum, essentia::standard::PowerSpectrum> regPowerSpectrum;
    AlgorithmFactory::Registrar<RealAccumulator> regRealAccumulator;
    AlgorithmFactory::Registrar<ReplayGain, essentia::standard::ReplayGain> regReplayGain;
#if ENABLE_SAMPLERATE
    AlgorithmFactory::Registrar<Resample, essentia::standard::Resample> regResample;
#endif
    AlgorithmFactory::Registrar<Scale, essentia::standard::Scale> regScale;
    AlgorithmFactory::Registrar<SilenceRate, essentia::standard::SilenceRate> regSilenceRate;
    AlgorithmFactory::Registrar<Slicer, essentia::standard::Slicer> regSlicer;
    AlgorithmFactory::Registrar<Spectrum, essentia::standard::Spectrum> regSpectrum;
    AlgorithmFactory::Registrar<SpectrumCQ, essentia::standard::SpectrumCQ> regSpectrumCQ;
    AlgorithmFactory::Registrar<Spline, essentia::standard::Spline> regSpline;
    AlgorithmFactory::Registrar<StartStopSilence, essentia::standard::StartStopSilence> regStartStopSilence;
    AlgorithmFactory::Registrar<StereoDemuxer, essentia::standard::StereoDemuxer> regStereoDemuxer;
    AlgorithmFactory::Registrar<StereoMuxer, essentia::standard::StereoMuxer> regStereoMuxer;
    AlgorithmFactory::Registrar<StereoTrimmer, essentia::standard::StereoTrimmer> regStereoTrimmer;
    AlgorithmFactory::Registrar<TensorNormalize, essentia::standard::TensorNormalize> regTensorNormalize;
    AlgorithmFactory::Registrar<TensorToPool> regTensorToPool;
    AlgorithmFactory::Registrar<TensorToVectorReal> regTensorToVectorReal;
    AlgorithmFactory::Registrar<TensorTranspose, essentia::standard::TensorTranspose> regTensorTranspose;
    AlgorithmFactory::Registrar<Trimmer, essentia::standard::Trimmer> regTrimmer;
    AlgorithmFactory::Registrar<UnaryOperator, essentia::standard::UnaryOperator> regUnaryOperator;
    AlgorithmFactory::Registrar<UnaryOperatorStream, essentia::standard::UnaryOperatorStream> regUnaryOperatorStream;
    AlgorithmFactory::Registrar<VectorRealAccumulator> regVectorRealAccumulator;
    AlgorithmFactory::Registrar<VectorRealToTensor> regVectorRealToTensor;
    AlgorithmFactory::Registrar<Viterbi, essentia::standard::Viterbi> regViterbi;
    AlgorithmFactory::Registrar<WarpedAutoCorrelation, essentia::standard::WarpedAutoCorrelation> regWarpedAutoCorrelation;
    AlgorithmFactory::Registrar<Welch, essentia::standard::Welch> regWelch;
    AlgorithmFactory::Registrar<Windowing, essentia::standard::Windowing> regWindowing;
    AlgorithmFactory::Registrar<CentralMoments, essentia::standard::CentralMoments> regCentralMoments;
    AlgorithmFactory::Registrar<Centroid, essentia::standard::Centroid> regCentroid;
    AlgorithmFactory::Registrar<Crest, essentia::standard::Crest> regCrest;
    AlgorithmFactory::Registrar<Decrease, essentia::standard::Decrease> regDecrease;
    AlgorithmFactory::Registrar<DistributionShape, essentia::standard::DistributionShape> regDistributionShape;
    AlgorithmFactory::Registrar<Energy, essentia::standard::Energy> regEnergy;
    AlgorithmFactory::Registrar<Entropy, essentia::standard::Entropy> regEntropy;
    AlgorithmFactory::Registrar<Flatness, essentia::standard::Flatness> regFlatness;
    AlgorithmFactory::Registrar<GeometricMean, essentia::standard::GeometricMean> regGeometricMean;
    AlgorithmFactory::Registrar<Histogram, essentia::standard::Histogram> regHistogram;
    AlgorithmFactory::Registrar<InstantPower, essentia::standard::InstantPower> regInstantPower;
    AlgorithmFactory::Registrar<Mean, essentia::standard::Mean> regMean;
    AlgorithmFactory::Registrar<Median, essentia::standard::Median> regMedian;
    AlgorithmFactory::Registrar<PoolAggregator, essentia::standard::PoolAggregator> regPoolAggregator;
    AlgorithmFactory::Registrar<PowerMean, essentia::standard::PowerMean> regPowerMean;
    AlgorithmFactory::Registrar<RawMoments, essentia::standard::RawMoments> regRawMoments;
    AlgorithmFactory::Registrar<RMS, essentia::standard::RMS> regRMS;
    AlgorithmFactory::Registrar<SingleGaussian, essentia::standard::SingleGaussian> regSingleGaussian;
    AlgorithmFactory::Registrar<Variance, essentia::standard::Variance> regVariance;
    AlgorithmFactory::Registrar<HarmonicMask, essentia::standard::HarmonicMask> regHarmonicMask;
    AlgorithmFactory::Registrar<HarmonicModelAnal, essentia::standard::HarmonicModelAnal> regHarmonicModelAnal;
    AlgorithmFactory::Registrar<HprModelAnal, essentia::standard::HprModelAnal> regHprModelAnal;
    AlgorithmFactory::Registrar<HpsModelAnal, essentia::standard::HpsModelAnal> regHpsModelAnal;
    AlgorithmFactory::Registrar<ResampleFFT, essentia::standard::ResampleFFT> regResampleFFT;
    AlgorithmFactory::Registrar<SineModelAnal, essentia::standard::SineModelAnal> regSineModelAnal;
    AlgorithmFactory::Registrar<SineModelSynth, essentia::standard::SineModelSynth> regSineModelSynth;
    AlgorithmFactory::Registrar<SineSubtraction, essentia::standard::SineSubtraction> regSineSubtraction;
    AlgorithmFactory::Registrar<SprModelAnal, essentia::standard::SprModelAnal> regSprModelAnal;
    AlgorithmFactory::Registrar<SprModelSynth, essentia::standard::SprModelSynth> regSprModelSynth;
    AlgorithmFactory::Registrar<SpsModelAnal, essentia::standard::SpsModelAnal> regSpsModelAnal;
    AlgorithmFactory::Registrar<SpsModelSynth, essentia::standard::SpsModelSynth> regSpsModelSynth;
    AlgorithmFactory::Registrar<StochasticModelAnal, essentia::standard::StochasticModelAnal> regStochasticModelAnal;
    AlgorithmFactory::Registrar<StochasticModelSynth, essentia::standard::StochasticModelSynth> regStochasticModelSynth;
    AlgorithmFactory::Registrar<Duration, essentia::standard::Duration> regDuration;
    AlgorithmFactory::Registrar<EffectiveDuration, essentia::standard::EffectiveDuration> regEffectiveDuration;
    AlgorithmFactory::Registrar<Larm, essentia::standard::Larm> regLarm;
    AlgorithmFactory::Registrar<Leq, essentia::standard::Leq> regLeq;
    AlgorithmFactory::Registrar<Loudness, essentia::standard::Loudness> regLoudness;
    AlgorithmFactory::Registrar<LoudnessEBUR128, essentia::standard::LoudnessEBUR128> regLoudnessEBUR128;
    AlgorithmFactory::Registrar<LoudnessEBUR128Filter> regLoudnessEBUR128Filter;
    AlgorithmFactory::Registrar<LoudnessVickers, essentia::standard::LoudnessVickers> regLoudnessVickers;
    AlgorithmFactory::Registrar<LPC, essentia::standard::LPC> regLPC;
    AlgorithmFactory::Registrar<ZeroCrossingRate, essentia::standard::ZeroCrossingRate> regZeroCrossingRate;
    AlgorithmFactory::Registrar<ChordsDescriptors, essentia::standard::ChordsDescriptors> regChordsDescriptors;
    AlgorithmFactory::Registrar<ChordsDetection, essentia::standard::ChordsDetection> regChordsDetection;
    AlgorithmFactory::Registrar<Dissonance, essentia::standard::Dissonance> regDissonance;
    AlgorithmFactory::Registrar<HarmonicPeaks, essentia::standard::HarmonicPeaks> regHarmonicPeaks;
    AlgorithmFactory::Registrar<HighResolutionFeatures, essentia::standard::HighResolutionFeatures> regHighResolutionFeatures;
    AlgorithmFactory::Registrar<Inharmonicity, essentia::standard::Inharmonicity> regInharmonicity;
    AlgorithmFactory::Registrar<Key, essentia::standard::Key> regKey;
    AlgorithmFactory::Registrar<MultiPitchMelodia, essentia::standard::MultiPitchMelodia> regMultiPitchMelodia;
    AlgorithmFactory::Registrar<NNLSChroma, essentia::standard::NNLSChroma> regNNLSChroma;
    AlgorithmFactory::Registrar<OddToEvenHarmonicEnergyRatio, essentia::standard::OddToEvenHarmonicEnergyRatio> regOddToEvenHarmonicEnergyRatio;
    AlgorithmFactory::Registrar<PitchContours, essentia::standard::PitchContours> regPitchContours;
    AlgorithmFactory::Registrar<PitchContoursMelody, essentia::standard::PitchContoursMelody> regPitchContoursMelody;
    AlgorithmFactory::Registrar<PitchContoursMonoMelody, essentia::standard::PitchContoursMonoMelody> regPitchContoursMonoMelody;
    AlgorithmFactory::Registrar<PitchContoursMultiMelody, essentia::standard::PitchContoursMultiMelody> regPitchContoursMultiMelody;
#if ENABLE_TENSORFLOW
    AlgorithmFactory::Registrar<PitchCREPE, essentia::standard::PitchCREPE> regPitchCREPE;
#endif
    AlgorithmFactory::Registrar<PitchFilter, essentia::standard::PitchFilter> regPitchFilter;
    AlgorithmFactory::Registrar<PitchMelodia, essentia::standard::PitchMelodia> regPitchMelodia;
    AlgorithmFactory::Registrar<PitchSalienceFunction, essentia::standard::PitchSalienceFunction> regPitchSalienceFunction;
    AlgorithmFactory::Registrar<PitchSalienceFunctionPeaks, essentia::standard::PitchSalienceFunctionPeaks> regPitchSalienceFunctionPeaks;
    AlgorithmFactory::Registrar<PitchYin, essentia::standard::PitchYin> regPitchYin;
    AlgorithmFactory::Registrar<PitchYinFFT, essentia::standard::PitchYinFFT> regPitchYinFFT;
    AlgorithmFactory::Registrar<PitchYinProbabilistic, essentia::standard::PitchYinProbabilistic> regPitchYinProbabilistic;
    AlgorithmFactory::Registrar<PitchYinProbabilities, essentia::standard::PitchYinProbabilities> regPitchYinProbabilities;
    AlgorithmFactory::Registrar<PitchYinProbabilitiesHMM, essentia::standard::PitchYinProbabilitiesHMM> regPitchYinProbabilitiesHMM;
    AlgorithmFactory::Registrar<PredominantPitchMelodia, essentia::standard::PredominantPitchMelodia> regPredominantPitchMelodia;
    AlgorithmFactory::Registrar<Tristimulus, essentia::standard::Tristimulus> regTristimulus;
    AlgorithmFactory::Registrar<TuningFrequency, essentia::standard::TuningFrequency> regTuningFrequency;
    AlgorithmFactory::Registrar<Vibrato, essentia::standard::Vibrato> regVibrato;
}}}
