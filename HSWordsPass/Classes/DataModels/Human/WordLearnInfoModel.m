#import "WordLearnInfoModel.h"


@interface WordLearnInfoModel ()

// Private interface goes here.

@end


@implementation WordLearnInfoModel

// Custom logic goes here.

- (void)setTotalRightsTimes:(int32_t)times completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    //__weak WordLearnInfoModel *weakSelf = self;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        WordLearnInfoModel *tWordLearn = [self inContext:localContext];
        tWordLearn.rightsValue = times;
    } completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

- (void)setTotalWrongsTimes:(int32_t)times completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    //__weak WordLearnInfoModel *weakSelf = self;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        WordLearnInfoModel *tWordLearn = [self inContext:localContext];
        tWordLearn.wrongsValue = times;
    } completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

- (void)setLearnedStatus:(WordLearnFileStatus)status completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    //__weak WordLearnInfoModel *weakSelf = self;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        WordLearnInfoModel *tWordLearn = [self inContext:localContext];
        tWordLearn.statusValue = status;
    } completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, nil, error);
        }
    }];
}


@end
