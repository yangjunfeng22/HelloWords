//
//  BookNet.h
//  HSWordsPass
//
//  Created by yang on 14-9-4.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookNet : NSObject

#pragma mark - Block
/**
 *  开始获取词书种类的请求
 *
 *  @param email      传递当前用户的email，以便跟踪哪个用户下载数据了。
 *  @param completion 完成的block。
 */
- (void)startWordBookCategoryRequestWithUserEmail:(NSString *)email completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  开始获取词书数据的请求
 *
 *  @param email      传递当前用户的email，以便跟踪哪个用户下载数据了。
 *  @param completion 完成的block。
 */
- (void)startWordBookRequestWithUserEmail:(NSString *)email categoryID:(NSString *)categoryID completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  获取词书的版本
 *
 *  @param email      email
 *  @param bID        词书ID
 *  @param completion 回调
 */
- (void)getBookVersionWithEmail:(NSString *)email bookID:(NSString *)bID completion:(void (^)(BOOL finished, id result, NSError *error))completion;

/**
 *  取消该请求
 */
- (void)cancelRequest;

@end
