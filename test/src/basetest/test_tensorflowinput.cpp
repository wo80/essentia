/*
 * Copyright (C) 2006-2021  Music Technology Group - Universitat Pompeu Fabra
 *
 * This file is part of Essentia
 *
 * Essentia is free software: you can redistribute it and/or modify it under
 * the terms of the GNU Affero General Public License as published by the Free
 * Software Foundation (FSF), either version 3 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
 * details.
 *
 * You should have received a copy of the Affero GNU General Public License
 * version 3 along with this program.  If not, see http://www.gnu.org/licenses/
 */

#include <memory>
#include "essentia_gtest.h"
#include "essentiamath.h"
#include "network.h"
#include "vectorinput.h"
using namespace std;
using namespace essentia;


namespace {

// A 440 Hz tone puts energy in a narrow part of the spectrum, so a working mel
// band pipeline spreads clearly different values across the bands.
vector<Real> toneFrame(int frameSize) {
  vector<Real> frame(frameSize);
  for (int i = 0; i < frameSize; i++) {
    frame[i] = (Real)(0.5 * sin(2.0 * M_PI * 440.0 * i / 16000.0));
  }
  return frame;
}

vector<Real> computeBands(const string& algorithmName, int frameSize) {
  unique_ptr<standard::Algorithm> algorithm(
    standard::AlgorithmFactory::create(algorithmName));

  vector<Real> frame = toneFrame(frameSize);
  vector<Real> bands;

  algorithm->input("frame").set(frame);
  algorithm->output("bands").set(bands);
  algorithm->compute();

  return bands;
}

// Every band being finite only proves the pipeline ran to completion: a stage
// silently producing nothing still yields a finite constant once the log
// compression is applied. Requiring the bands to differ from one another is
// what distinguishes a computed mel spectrum from a correctly sized blank.
void expectMelBands(const vector<Real>& bands, int expectedBandCount) {
  ASSERT_EQ(expectedBandCount, (int)bands.size());

  Real minimum = bands[0];
  Real maximum = bands[0];

  for (int i = 0; i < (int)bands.size(); i++) {
    ASSERT_TRUE(std::isfinite(bands[i])) << "band " << i << " is not finite";
    if (bands[i] < minimum) minimum = bands[i];
    if (bands[i] > maximum) maximum = bands[i];
  }

  EXPECT_GT(maximum - minimum, (Real)0.0)
    << "all " << bands.size() << " bands carry the value " << minimum
    << "; the mel band pipeline produced no spectral detail";
}

} // namespace


TEST(TensorflowInput, MusiCNNComputesLogMelBands) {
  expectMelBands(computeBands("TensorflowInputMusiCNN", 512), 96);
}

TEST(TensorflowInput, VGGishComputesLogMelBands) {
  expectMelBands(computeBands("TensorflowInputVGGish", 400), 64);
}

TEST(TensorflowInput, TempoCNNComputesMelBands) {
  expectMelBands(computeBands("TensorflowInputTempoCNN", 1024), 40);
}

TEST(TensorflowInput, FSDSINetComputesLogMelBands) {
  expectMelBands(computeBands("TensorflowInputFSDSINet", 660), 96);
}

// The algorithms are registered in both factories, so the streaming wrappers
// need to survive the build configuration just as the standard ones do.
TEST(TensorflowInput, MusiCNNComputesLogMelBandsWhenStreamed) {
  const int frameCount = 3;
  vector<vector<Real> > frames(frameCount, toneFrame(512));

  streaming::VectorInput<vector<Real> >* input =
    new streaming::VectorInput<vector<Real> >(&frames);
  streaming::Algorithm* algorithm =
    streaming::AlgorithmFactory::create("TensorflowInputMusiCNN");

  Pool pool;
  input->output("data") >> algorithm->input("frame");
  algorithm->output("bands") >> PC(pool, "bands");

  scheduler::Network(input).run();

  const vector<vector<Real> >& bands =
    pool.value<vector<vector<Real> > >("bands");

  ASSERT_EQ(frameCount, (int)bands.size());
  for (int i = 0; i < frameCount; i++) {
    expectMelBands(bands[i], 96);
  }
}
