//
//  CheckPointDAL.h
//  HSWordsPass
//
//  Created by yang on 14-9-5.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CheckPointModel;
@class CheckPointProgressModel;

@interface CheckPointDAL : NSObject

+ (NSString *)getCheckPointRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email bookID:(NSString *)bookID language:(NSString *)language productID:(NSString *)productID;

+ (NSString *)getCheckPointTranslationRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email checkPointID:(NSString *)cpID language:(NSString *)language productID:(NSString *)productID;

+ (NSString *)getCheckPointProgressRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email bookID:(NSString *)bID records:(NSString *)records language:(NSString *)language productID:(NSString *)productID;

+ (NSString *)getCheckPointVersionRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email checkPointID:(NSString *)cpID productID:(NSString *)productID;

+ (NSString *)getDownloadCheckPointDataURLParamsWithApKey:(NSString *)apKey email:(NSString *)email bookID:(NSString *)bID checkPointID:(NSString *)cpID productID:(NSString *)productID version:(NSString *)version;

/**
 *  解关卡的数据
 *
 *  @param resultData 网络请求的结果：json格式的数据
 *  @param completion 结束后的block回调
 */
+ (void)parseCheckPointByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

/**
 *  解关卡进度的数据
 *
 *  @param resultData 网络请求的结果：json格式的数据
 *  @param completion 回调
 */
+ (void)parseCheckPointProgressByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

/**
 *  解关卡版本数据
 *
 *  @param resultData 返回数据
 *  @param completion 回调
 */
+ (void)parseCheckPointVersionByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

/**
 *  解析关卡词列表下载所需的链接
 *
 *  @param resultData 下载的链接地址
 *  @param completion block回调
 */
+ (void)parseCheckPointDownloadByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

#pragma mark - 数据库操作
+ (void)saveCheckPointProgressWithUserID:(NSString *)uID CheckPointID:(NSString *)cpID bookID:(NSString *)bID version:(NSString *)version progress:(CGFloat)progress status:(NSInteger)status completion:(void (^)(BOOL, id, NSError *))completion;
/**
 *  查询指定Book下面的所有的关卡
 *
 *  @param bID book的ID
 *
 *  @return 返回所有的值
 */
+ (NSArray *)queryCheckPointsWithBookID:(NSString *)bID;

/**
 *  返回指定的关卡，功能之一是提供一个关卡的名字
 *
 *  @param bID  所属的book的ID
 *  @param cpID 关卡本身的ID
 *
 *  @return 返回该指定的关卡
 */
+ (CheckPointModel *)queryCheckPointWithBookID:(NSString *)bID checkPointID:(NSString *)cpID;

+ (CheckPointModel *)queryNextCheckPointWithBookID:(NSString *)bID index:(NSInteger)index;

+ (CheckPointModel *)queryCheckPointWithBookID:(NSString *)bID index:(NSInteger)index;

/**
 *  提供指定book的所有关卡的数量
 *
 *  @param bID book的ID
 *
 *  @return 数量
 */
+ (NSInteger)checkPointCountWithBookID:(NSString *)bID;

/**
 *  获取单个关卡的进度信息
 *   -- 每个关卡加载的时候根据本身所携带的用户ID、书本ID和关卡ID来加载当前关卡的信息。
 *
 *  @param uID  用户ID
 *  @param bID  书本ID
 *  @param cpID 关卡ID
 *
 *  @return 关卡进度信息
 */
+ (CheckPointProgressModel *)queryCheckPointProgressWithUserID:(NSString *)uID bookID:(NSString *)bID checkPointID:(NSString *)cpID;
/**
 *  获取单个关卡的进度信息
 *   -- 每个关卡加载的时候根据本身所携带的用户ID和关卡ID来加载当前关卡的信息。
 *
 *
 *  @param uID  用户ID
 *  @param cpID 关卡ID
 *
 *  @return 单个的关卡信息。
 */
//+ (CheckPointProgressModel *)queryCheckPointProgressWithUserID:(NSString *)uID checkPointID:(NSString *)cpID;


+ (NSInteger)countOfCheckPointProgressWithUserID:(NSString *)uID bookID:(NSString *)bID;


+ (NSArray *)queryAllCheckPointProgressWithUserID:(NSString *)uID bookID:(NSString *)bID;

/**
 *  获取该用户下面所有的关卡的进度信息
 *
 *  @param uID 用户ID
 *
 *  @return 返回的信息
 */
+ (NSArray *)queryAllCheckPointProgressWithUserID:(NSString *)uID;

@end
