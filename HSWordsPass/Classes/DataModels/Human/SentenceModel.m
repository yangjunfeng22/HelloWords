#import "SentenceModel.h"
#import "SentenceTranslationModel.h"
#import "WordDAL.h"
#import "CheckPoint_WordModel.h"
#import "SystemInfoHelper.h"


@interface SentenceModel ()

// Private interface goes here.

@end


@implementation SentenceModel

// Custom logic goes here.
- (NSString *)tChinese
{
    SentenceTranslationModel *chineseTran = [WordDAL querySentenceTranslationWithSentenceID:self.sID language:currentLanguage()];
    return chineseTran.chinese;
}

@end
