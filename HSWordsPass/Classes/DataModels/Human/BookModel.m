#import "BookModel.h"
#import "BookTranslationModel.h"
#import "BookDAL.h"
#import "SystemInfoHelper.h"

@interface BookModel ()

// Private interface goes here.

@end


@implementation BookModel

// Custom logic goes here.

- (NSString *)tName
{
    BOOL isZh = [currentLanguage() hasPrefix:@"zh"];
    BookTranslationModel *bookTran = [BookDAL queryWordBookTranslationWithBookID:self.bID language:currentLanguage()];
    
    NSString *bookName = isZh ? self.name:bookTran.name;
    return bookName;
}

- (void)setBookVersion:(NSString *)version completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    //__weak WordLearnInfoModel *weakSelf = self;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        BookModel *tBook = [self inContext:localContext];
        version ? tBook.version = version:version;
    } completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

@end
