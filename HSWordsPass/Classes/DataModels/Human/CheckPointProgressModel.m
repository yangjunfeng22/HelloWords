#import "CheckPointProgressModel.h"


@interface CheckPointProgressModel ()

// Private interface goes here.

@end


@implementation CheckPointProgressModel

// Custom logic goes here.

- (void)setCheckPointVersion:(NSString *)version completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    //__weak WordLearnInfoModel *weakSelf = self;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        CheckPointProgressModel *tCpProgress = [self inContext:localContext];
        version ? tCpProgress.version = version:version;
    } completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

@end
