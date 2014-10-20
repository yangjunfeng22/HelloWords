#import "UserModel.h"


@interface UserModel ()

// Private interface goes here.

@end


@implementation UserModel

// Custom logic goes here.

- (void)setLoginedValue:(BOOL)value_
{
    [super setLoginedValue:value_];
    
    __weak UserModel *weakSelf = self;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        UserModel *tUser = [weakSelf inContext:localContext];
        tUser.loginedValue = value_;
    } completion:^(BOOL success, NSError *error) {
        
    }];
}

@end
