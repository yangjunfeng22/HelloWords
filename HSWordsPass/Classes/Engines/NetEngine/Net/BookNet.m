//
//  BookNet.m
//  HSWordsPass
//
//  Created by yang on 14-9-4.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "BookNet.h"
#import "BookDAL.h"
#import "HttpClient.h"
#import "SystemInfoHelper.h"
#import "OpenUDID.h"
#import "MD5Helper.h"

@interface BookNet ()
{
    HttpClient *requestClient;
}

@end

@implementation BookNet

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{
    [requestClient cancelRequest];
    requestClient = nil;
}

- (void)initRequestClient
{
    if (!requestClient)
    {
        requestClient = [[HttpClient alloc] init];
    }
}

#pragma mark - Request
// 词书种类
- (void)startWordBookCategoryRequestWithUserEmail:(NSString *)email completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    NSString *apKey = [MD5Helper md5Digest:md5];
    
    NSString *params = [BookDAL getCategoryRequestURLParamsWithApKey:apKey email:email language:currentLanguage() productID:productID()];
    
    [self initRequestClient];
    [requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kBookCategory] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"词书种类: jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [BookDAL parseCategoryByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

// 词书
- (void)startWordBookRequestWithUserEmail:(NSString *)email categoryID:(NSString *)categoryID completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    NSString *apKey = [MD5Helper md5Digest:md5];
    
    NSString *params = [BookDAL getWordBookRequestURLParamsWithApKey:apKey email:email categoryID:categoryID language:currentLanguage() productID:productID()];
    
    [self initRequestClient];
    [requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kBookList] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"词书 jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [BookDAL parseWordBookByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)getBookVersionWithEmail:(NSString *)email bookID:(NSString *)bID completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    NSString *apKey = [MD5Helper md5Digest:md5];
    
    NSString *params = [BookDAL getBookVersionRequestURLParamsWithApKey:apKey email:email bookID:bID productID:productID()];
    
    [self initRequestClient];
    [requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kBookVersion] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"词书版本 jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [BookDAL parseBookVersionByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)cancelRequest
{
    [requestClient cancelAllRequest];
    requestClient = nil;
}

@end
