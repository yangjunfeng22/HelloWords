#import "_BookModel.h"

@interface BookModel : _BookModel {}
// Custom logic goes here.
- (NSString *)tName;

- (void)setBookVersion:(NSString *)version completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

@end
