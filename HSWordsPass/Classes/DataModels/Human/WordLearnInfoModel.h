#import "_WordLearnInfoModel.h"

typedef NS_ENUM(NSUInteger, WordLearnFileStatus) {
    WordLearnFileStatusUnFile = 0,
    WordLearnFileStatusFiled = 1
};


@interface WordLearnInfoModel : _WordLearnInfoModel {}
// Custom logic goes here.
- (void)setTotalRightsTimes:(int32_t)times completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

- (void)setTotalWrongsTimes:(int32_t)times completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

- (void)setLearnedStatus:(WordLearnFileStatus)status completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

@end
