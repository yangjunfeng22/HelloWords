#import "BookCategoryModel.h"
#import "BookCategoryTransModel.h"
#import "BookDAL.h"
#import "SystemInfoHelper.h"

@interface BookCategoryModel ()

// Private interface goes here.

@end


@implementation BookCategoryModel

// Custom logic goes here.
- (NSString *)tName
{
    BOOL isZh = [currentLanguage() hasPrefix:@"zh"];
    BookCategoryTransModel *categoryTran = [BookDAL queryBookCategoryTranslationWithCategoryID:self.cID language:currentLanguage()];
    
    NSString *bookName = isZh ? self.name:categoryTran.name;
    return bookName;
}

@end
