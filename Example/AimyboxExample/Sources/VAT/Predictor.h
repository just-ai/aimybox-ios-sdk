#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Predictor : NSObject
- (nullable instancetype)initWithVadPath:(NSString*)vadPath
                    featureExtractorPath:(NSString*)featureExtractorPath
                               modelPath:(NSString*)modelPath
    NS_SWIFT_NAME(init(vadPath:featureExtractorPath:modelPath))
    NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (nullable NSNumber*)recognizeVAD: (void*)buffer bufLength: (int)bufLength
    NS_SWIFT_NAME(recognizeVAD(wavBuffer:bufLength));
- (nullable NSNumber*)recognizeKeyPhrase: (void*)buffer bufLength: (int)bufLength
    NS_SWIFT_NAME(recognizeKeyPhrase(buffer:bufLength));
@end

NS_ASSUME_NONNULL_END
