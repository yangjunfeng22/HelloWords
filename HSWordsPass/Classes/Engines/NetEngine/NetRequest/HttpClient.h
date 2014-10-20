//
//  HttpClient.h
//  PinyinGame
//
//  Created by yang on 13-11-16.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface HttpClient : NSObject<ASIHTTPRequestDelegate>

@property (nonatomic, readonly)NSInteger statuCode;
@property (nonatomic, readonly)BOOL isRequestCanceled;

@property (nonatomic, strong)NSError *error;

/**
 *  发送get请求
 *
 *  @param url    服务器地址的url
 *  @param params url所需的参数
 *  @param error  错误描述
 *
 *  @return 请求结果
 */
- (id)getRequestFromURL:(NSString *)url params:(NSString *)params error:(NSError **)error;

/**
 *  发送post请求
 *
 *  @param url    服务器地址的url
 *  @param params url所需的参数
 *  @param error  错误描述
 *
 *  @return 请求结果
 */
- (id)postRequestFromURL:(NSString *)url params:(NSString *)params error:(NSError **)error;

- (void)getRequestFromURL:(NSString *)url params:(NSString *)params completion:(void (^)(BOOL finished, NSData *responseData, NSString *responseString, NSError *error))completion;

- (void)postRequestFromURL:(NSString *)url params:(NSString *)params completion:(void (^)(BOOL finished, NSData *responseData, NSString *responseString, NSError *error))completion;

- (void)cancelRequest;

- (void)cancelAllRequest;

- (BOOL)isRequestAllCanceled;


@end
