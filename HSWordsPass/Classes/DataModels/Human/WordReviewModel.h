#import "_WordReviewModel.h"


typedef NS_ENUM(NSUInteger, NewWordStatus) {
    NewWordStatusAdd = 0,
    NewWordStatusSync = 1,
    NewWordStatusRemoved = 2
};

@class WordModel;

@interface WordReviewModel : _WordReviewModel {}
// Custom logic goes here.

@property (readonly) WordModel *word;

@end
