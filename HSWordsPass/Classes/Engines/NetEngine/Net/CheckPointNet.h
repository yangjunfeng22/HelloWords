//
//  CheckPointNet.h
//  HSWordsPass
//
//  Created by yang on 14-9-5.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloadDelegate;

@interface CheckPointNet : NSObject
@property (weak, nonatomic) id<DownloadDelegate>delegate;

/**
 *  开始获取词书数据的请求
 *
 *  @param email      传递当前用户的email，以便跟踪哪个用户下载数据了。
 *  @param completion 完成的block。
 */
- (void)startCheckPointRequestWithUserEmail:(NSString *)email bookID:(NSString *)bookID completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  开始同步关卡进度的数据
 *
 *  @param email      用户email
 *  @param records    关卡进度记录
 *  @param completion 完成的回调
 */
- (void)startSynchronousCheckPointProgressWithEmail:(NSString *)email bookID:(NSString *)bID records:(NSString *)records completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  获取关卡的版本数据,
 *   -- 本地数据库中会保存一份，
 *   -- 如果服务器端的版本与本地的不一致，那么去更新相应的数据。
 *   -- 如果是关卡-词对应关系有更改，那么先删除所有的本地的对应关系，然后重新去加载新的对应关系。
 *
 *  @param email      email
 *  @param cpID       关卡ID
 *  @param completion 回调
 */
- (void)getCheckPointVersionWithEmail:(NSString *)email cpID:(NSString *)cpID completion:(void (^)(BOOL finished, id result, NSError *error))completion;


/**
 *  获取关卡的下载链接
 *
 *  @param email      用户email
 *  @param cpID       关卡ID
 *  @param completion 完成的block。
 */
- (void)getCheckPointDataDonwloadInfoWithEmail:(NSString *)email bookID:(NSString *)bID checkPointID:(NSString *)cpID completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  下载关卡所需的数据
 *
 *  @param email      用户email
 *  @param cpID       关卡ID
 *  @param completion 回调的block
 */
- (void)downloadCheckPointDataWithEmail:(NSString *)email bookID:(NSString *)bID checkPointID:(NSString *)cpID completion:(void (^)(BOOL finished, id result, NSError *error))completion;


/**
 *  取消该请求
 */
- (void)cancelRequest;

/**
 *  取消下载
 */
- (void)cancelDownload;

/**
 *  请求是否已取消
 *
 *  @return 是否已取消
 */
- (BOOL)isRequestCanceled;

/**
 *  下载是否已取消
 *
 *  @return 是否已取消
 */
- (BOOL)isDownloadCanceled;

@end

@protocol DownloadDelegate <NSObject>

@optional
- (void)downloadProgress:(float)progress;

@end