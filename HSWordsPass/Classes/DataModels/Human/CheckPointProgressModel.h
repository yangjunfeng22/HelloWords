#import "_CheckPointProgressModel.h"

@interface CheckPointProgressModel : _CheckPointProgressModel {}
// Custom logic goes here.
- (void)setCheckPointVersion:(NSString *)version completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

@end
