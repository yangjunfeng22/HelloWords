#import "_WordModel.h"

typedef NS_ENUM(NSUInteger, PracticeResultType) {
    kPracticeResultTypeDefault = 0,
    kPracticeResultTypeRight = 1,
    kPracticeResultTypeWrong = 2
};

@class SentenceModel;

@interface WordModel : _WordModel {}

// Custom logic goes here.

@property PracticeResultType practicResult;

- (NSString *)tChinese;

- (NSString *)tProperty;

- (NSArray *)sentences;

- (SentenceModel *)sentence;

@end
