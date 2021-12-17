// Copyright (c) 2020 Facebook, Inc. and its affiliates.
// All rights reserved.
//
// This source code is licensed under the BSD-style license found in the
// LICENSE file in the root directory of this source tree.


#import "Predictor.h"
#import <Libtorch-Lite/Libtorch-Lite.h>
#import <AVFoundation/AVAudioRecorder.h>
#import <AVFoundation/AVAudioSettings.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioToolbox.h>


@implementation Predictor {
    @protected torch::jit::mobile::Module vad;
    @protected torch::jit::mobile::Module featureExtractor;
    @protected torch::jit::mobile::Module model;
}

- (nullable instancetype)initWithVadPath:(NSString*)vadPath
                    featureExtractorPath:(NSString*)featureExtractorPath
                               modelPath:(NSString*)modelPath {
    self = [super init];
    if (self) {
        try {
            auto qengines = at::globalContext().supportedQEngines();
            if (std::find(qengines.begin(), qengines.end(), at::QEngine::QNNPACK) != qengines.end()) {
                at::globalContext().setQEngine(at::QEngine::QNNPACK);
            }
            vad = torch::jit::_load_for_mobile(vadPath.UTF8String);
            featureExtractor = torch::jit::_load_for_mobile(featureExtractorPath.UTF8String);
            model = torch::jit::_load_for_mobile(modelPath.UTF8String);
        }
        catch (const std::exception& exception) {
            NSLog(@"%s", exception.what());
            return nil;
        }
    }
    return self;
}

- (NSNumber*)recognizeVAD:(void*)buffer bufLength:(int)bufLength {
    try {
        at::Tensor tensorInputs = torch::from_blob((void*)buffer, {1, bufLength}, at::kFloat);
        
        float* floatInput = tensorInputs.data_ptr<float>();
        if (!floatInput) {
            return nil;
        }

        c10::InferenceMode guard;

        auto result = vad.forward({ tensorInputs });
        auto tensor = result.toTensor();
        float *floatBuffer = tensor.data_ptr<float>();
        return @(floatBuffer[1]);
    }
    catch (const std::exception& exception) {
        NSLog(@"%s", exception.what());
    }
    return nil;
}

- (NSNumber*)recognizeKeyPhrase: (void*)buffer bufLength: (int)bufLength {
    try {
        at::Tensor tensorInputs = torch::from_blob((void*)buffer, {1, bufLength}, at::kFloat);

        float* floatInput = tensorInputs.data_ptr<float>();
        if (!floatInput) {
            return nil;
        }

        c10::InferenceMode guard;

        auto feResult = featureExtractor.forward({ tensorInputs });
        auto feTensor = feResult.toTensor();
        auto modelResult = model.forward({ feTensor });
        auto modelTensor = modelResult.toTensor();
        float *floatBuffer = modelTensor.sigmoid().data_ptr<float>();
        return @(floatBuffer[0]);
    }
    catch (const std::exception& exception) {
        NSLog(@"%s", exception.what());
    }
    return nil;
}

@end
