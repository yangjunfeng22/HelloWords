//
//  UserDAL.m
//  PinyinGame
//
//  Created by yang on 13-11-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UserDAL.h"
#import "UserModel.h"
#import "UserLaterStatuModel.h"
#import "URLUtility.h"
#import "Constants.h"

void (^parseLoginDataCompletion)(BOOL finished, id result, NSError *error);

@implementation UserDAL

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(void)dealloc
{

}

+ (NSString *)getLoginURLParamsWithApKey:(NSString *)apKey email:(NSString *)email password:(NSString *)password language:(NSString *)language productID:(NSString *)productID
{
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, password, language, productID, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"email", @"password", @"language", @"productID", nil]]];
}

+ (NSString *)getRegistURLParamsWithApKey:(NSString *)apKey email:(NSString *)email password:(NSString *)password language:(NSString *)language productID:(NSString *)productID mcKey:(NSString *)mcKey
{
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, password, language, productID, mcKey, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"email", @"password", @"language", @"comefrom", @"mckey", nil]]];
}

+ (NSString *)getPasswordBackURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID
{
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, language, productID, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"email", @"language", @"productID", nil]]];
}

#pragma mark - block
// 登陆/注册
+ (void)parseUserByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        
        id results = [resultData objectForKey:@"User"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        // 目前根据协议, 只有用户登陆才会返回有具体信息。
        if (success)
        {
            [self parseUserLogin:results completion:completion];
        }
        else
        {
            if (completion) {
                completion(success, nil, error);
            }
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:NSLocalizedString(@"数据封装出错!", @"") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (void)parseUserLogin:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        NSString *userID    = [resultData objectForKey:@"Uid"];
        NSString *userEmail = [resultData objectForKey:@"Email"];
        NSString *endDate   = [resultData objectForKey:@"Enddate"];
        NSString *nick      = [resultData objectForKey:@"Nickname"];
        NSString *picture   = [resultData objectForKey:@"Picture"];
        BOOL enabled        = [[resultData objectForKey:@"Enabled"] boolValue];
        
        kSetUDUserID(userID);
        kSetUDUserEamil(userEmail);
        
        [self saveUserInfoWithUserID:userID email:userEmail name:nick nick:nick enabled:enabled level:nil picture:picture laterLogin:[endDate integerValue] logined:YES completion:^(BOOL finished, id obj, NSError *error) {
            if (completion) {
                completion(finished, obj, error);
            }
        }];
    }
    else
    {
        NSError *error = [NSError errorWithDomain:NSLocalizedString(@"数据封装出错!", @"") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

// 找回密码
+ (void)parseUserFindPasswordData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        
        if (completion) {
            completion(success, nil, error);
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:NSLocalizedString(@"数据封装出错!", @"") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

#pragma mark - 数据的数据库操作
+ (void)saveUserInfoWithUserID:(NSString *)uID email:(NSString *)email name:(NSString *)name nick:(NSString *)nick enabled:(BOOL)enabled level:(NSString *)level picture:(NSString *)picture laterLogin:(NSInteger)laterLogin logined:(BOOL)logined completion:(void(^)(BOOL finished, id obj, NSError *error))completion
{
    UserModel *user = [self queryUserInfoWithUserID:uID];
    
    BOOL needUpdate = [user.userID isEqualToString:uID];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        UserModel *tUser = needUpdate ? [user inContext:localContext] : [UserModel createEntityInContext:localContext];
        uID   ? tUser.userID = uID:uID;
        email ? tUser.email = email:email;
        name  ? tUser.name = name:name;
        nick  ? tUser.nick = nick:nick;
        level ? tUser.level = level:level;
        picture ? tUser.picture = picture:picture;
        tUser.enabledValue = enabled;
        tUser.laterLoginValue = (int32_t)laterLogin;
        tUser.loginedValue = logined;
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion){
            completion(success, user, error);
        }
    }];
}

+ (UserModel *)queryUserInfoWithUserID:(NSString *)uID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", uID];
    UserModel *user = (UserModel *)[UserModel findFirstWithPredicate:predicate inContext:context];
    return user;
}

// 用户最近的学习状态
+ (void)saveUserLaterStatusWithUserID:(NSString *)uID categoryID:(NSString *)cID bookID:(NSString *)bID checkPointID:(NSString *)cpID nexCheckPointID:(NSString *)nexCpID timeStamp:(CGFloat)timeStamp completion:(void (^)(BOOL finished, id result, NSError *error))completion
{
    UserLaterStatuModel *user = [self queryUserLaterStatusInfoWithUserID:uID categoryID:cID bookID:bID];
    
    BOOL needUpdate = [user.userID isEqualToString:uID];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        UserLaterStatuModel *tUser = needUpdate ? [user inContext:localContext] : [UserLaterStatuModel createEntityInContext:localContext];

        uID ? tUser.userID = uID:uID;
        cID ? tUser.categoryID = cID:cID;
        bID ?  tUser.bookID = bID:bID;
        cpID ? tUser.checkPointID = cpID:cpID;
        nexCpID ? tUser.nexCheckPointID = nexCpID:nexCpID;
        tUser.timeStampValue = timeStamp;
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion) {
            completion(YES, nil, error);
        }
    }];
}

+ (UserLaterStatuModel *)queryUserLaterStatusInfoWithUserID:(NSString *)uID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", uID];
    
    UserLaterStatuModel *user = [UserLaterStatuModel findFirstWithPredicate:predicate sortedBy:@"timeStamp" ascending:NO inContext:context];
    return user;
}

+ (UserLaterStatuModel *)queryUserLaterStatusInfoWithUserID:(NSString *)uID categoryID:(NSString *)cID bookID:(NSString *)bID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND categoryID == %@ AND bookID == %@", uID, cID, bID];
    UserLaterStatuModel *user = (UserLaterStatuModel *)[UserLaterStatuModel findFirstWithPredicate:predicate inContext:context];
    return user;
}

+ (NSInteger)userLaterStatusCountWithUserID:(NSString *)uID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", uID];
    NSInteger count = [UserLaterStatuModel countOfEntitiesWithPredicate:predicate inContext:context];
    return count;
}

@end
