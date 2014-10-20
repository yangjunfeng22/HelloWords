//
//  WordNet.h
//  HSWordsPass
//
//  Created by yang on 14-9-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordNet : NSObject

/**
 *  开始关卡-词关系的请求
 *
 *  @param email      email
 *  @param cpID       关卡ID
 *  @param completion 回调
 */
- (void)startCheckPointWordsLinkedRequestWithEmail:(NSString *)email checkPointID:(NSString *)cpID completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  开始获取词数据的请求
 *
 *  @param email      传递当前用户的email，以便跟踪哪个用户下载数据了。
 *  @param cpID       关卡ID，在进入每个关卡之前需要保证数据库中已经有该数据存在。
 *  @param completion 完成的block。
 */
- (void)startWordRequestWithUserEmail:(NSString *)email checkPointID:(NSString *)cpID wordID:(NSString *)wID completion:(void (^)(BOOL finished, id result, NSError *error))completion;

- (void)startWordSentenceRequestWithUserEmail:(NSString *)email checkPointID:(NSString *)cpID wordID:(NSString *)wID completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  开始获取词的学习信息数据的请求
 *
 *  @param email      email
 *  @param cpID       关卡ID
 *  @param bID        词书ID
 *  @param cID        词书种类ID
 *  @param records    记录
 *  @param completion 完成的回调
 */
- (void)startWordLearnedRecordsRequestWithUserEmail:(NSString *)email checkPointID:(NSString *)cpID bookID:(NSString *)bID categoryID:(NSString *)cID records:(NSString *)records completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  开始获取生词本中生词数据的请求
 *
 *  @param email      email
 *  @param records    记录；需要同步的本地数据拼接出的字符串，没有要同步的，此参数为空。格式：wid|1|created,wid|0|created... 其中0：添加，1：移除，created：添加到生词本的时间。
 *
 *  @param completion 完成的回调
 */
- (void)startSynchronousWordReviewWithUserEmail:(NSString *)email bookID:(NSString *)bID records:(NSString *)records completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  获取关卡的下载链接
 *
 *  @param email      用户email
 *  @param cpID       关卡ID
 *  @param completion 完成的block。
 */
- (void)getWordAudioDataDonwloadInfoWithEmail:(NSString *)email audio:(NSString *)audio completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  下载关卡所需的数据
 *
 *  @param email      用户email
 *  @param cpID       关卡ID
 *  @param completion 回调的block
 */
- (void)downloadWordAudioDataWithEmail:(NSString *)email checkPointID:(NSString *)cpID audio:(NSString *)audio completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  取消该请求
 */
- (void)cancelRequest;

- (void)cancelDownload;

- (BOOL)isRequestCanceled;

- (BOOL)isDownloadCanceled;

@end
