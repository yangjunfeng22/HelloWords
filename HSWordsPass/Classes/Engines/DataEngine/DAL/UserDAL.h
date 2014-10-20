//
//  UserDAL.h
//  PinyinGame
//
//  Created by yang on 13-11-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;
@class UserLaterStatuModel;

@interface UserDAL : NSObject
@property (nonatomic, strong, readonly)NSError *error;

+ (NSString *)getLoginURLParamsWithApKey:(NSString *)apKey email:(NSString *)email password:(NSString *)password language:(NSString *)language productID:(NSString *)productID;

+ (NSString *)getRegistURLParamsWithApKey:(NSString *)apKey email:(NSString *)email password:(NSString *)password language:(NSString *)language productID:(NSString *)productID mcKey:(NSString *)mcKey;

+ (NSString *)getPasswordBackURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID;

#pragma mark - Block
+ (void)parseUserByData:(id)resultData completion:(void (^)(BOOL finished, id result, NSError *error))completion;

+ (void)parseUserFindPasswordData:(id)resultData completion:(void (^)(BOOL finished, id result, NSError *error))completion;

#pragma mark - 数据的数据库操作
+ (UserModel *)queryUserInfoWithUserID:(NSString *)uID;

// 用户最近的学习状态
+ (void)saveUserLaterStatusWithUserID:(NSString *)uID categoryID:(NSString *)cID bookID:(NSString *)bID checkPointID:(NSString *)cpID nexCheckPointID:(NSString *)nexCpID timeStamp:(CGFloat)timeStamp completion:(void (^)(BOOL finished, id result, NSError *error))completion;

+ (UserLaterStatuModel *)queryUserLaterStatusInfoWithUserID:(NSString *)uID;

+ (UserLaterStatuModel *)queryUserLaterStatusInfoWithUserID:(NSString *)uID categoryID:(NSString *)cID bookID:(NSString *)bID;


/**
 *  指定用户ID下面的状态数量
 *    -- 基本上只有一条数据
 *
 *  @param uID 用户ID
 *
 *  @return 数量
 */
+ (NSInteger)userLaterStatusCountWithUserID:(NSString *)uID;

@end
