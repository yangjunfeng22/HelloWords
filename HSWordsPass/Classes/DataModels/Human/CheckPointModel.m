#import "CheckPointModel.h"
#import "CheckPointDAL.h"


@interface CheckPointModel ()

// Private interface goes here.

@end


@implementation CheckPointModel

// Custom logic goes here.
- (NSString *)nexCpID
{
    CheckPointModel *checkPoint = [CheckPointDAL queryNextCheckPointWithBookID:kBookID index:self.indexValue];
    return checkPoint.cpID;
}

- (NSString *)tName
{
    //WordTranslationModel *wordTran = [WordDAL queryWordTranslationWithWordID:self.wID language:currentLanguage()];
    //return wordTran.chinese;
    return nil;
}

@end
