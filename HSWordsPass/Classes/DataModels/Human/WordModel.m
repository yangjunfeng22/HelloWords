#import "WordModel.h"
#import "WordTranslationModel.h"
#import "SentenceModel.h"
#import "WordNet.h"
#import "WordDAL.h"
#import "SystemInfoHelper.h"
#import "CheckPointDAL.h"
#import "CheckPoint_WordModel.h"

@interface WordModel ()
{
    WordNet *wordNet;
}

// Private interface goes here.

@end


@implementation WordModel
@synthesize practicResult;

// Custom logic goes here.

- (NSString *)tChinese
{
    WordTranslationModel *wordTran = [WordDAL queryWordTranslationWithWordID:self.wID language:currentLanguage()];
    return wordTran.chinese;
}

- (NSString *)tProperty
{
    WordTranslationModel *wordTran = [WordDAL queryWordTranslationWithWordID:self.wID language:currentLanguage()];
    return wordTran.property;
}

- (NSArray *)sentences
{
    NSArray *arrSentence = [WordDAL querySentencesWithWordID:self.wID];
    return arrSentence;
}

- (SentenceModel *)sentence
{
    NSArray *arrSentence = [WordDAL querySentencesWithWordID:self.wID];
    NSInteger count = [arrSentence count];
    NSInteger factor = arc4random()%count;

    SentenceModel *sentence = count > 0 ? (SentenceModel *)[arrSentence objectAtIndex:factor]:nil;
    return sentence;
}

@end
