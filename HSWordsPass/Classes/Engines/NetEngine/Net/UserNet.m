//
//  UserNet.m
//  PinyinGame
//
//  Created by yang on 13-11-20.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UserNet.h"
#import "HttpClient.h"
#import "UserDAL.h"
#import "ResponseModel.h"
#import "SystemInfoHelper.h"
#import "OpenUDID.h"
#import "MD5Helper.h"

void (^loginCompletion)(BOOL finished, id result, NSError *error);
void (^registCompletion)(BOOL finished, id result, NSError *error);
void (^findPasswordCompletion)(BOOL finished, id result, NSError *error);

@interface UserNet ()
{
    HttpClient *requestClient;
}

@end

@implementation UserNet

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

#pragma mark - block
- (void)startLoginWithUserEmail:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL, id, NSError *))completion
{
    loginCompletion = completion;
    
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    NSString *apKey = [MD5Helper md5Digest:md5];
    
    NSString *params = [UserDAL getLoginURLParamsWithApKey:apKey email:email password:password language:currentLanguage() productID:productID()];
    
    [self initRequestClient];
    [requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kLoginMethod] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [UserDAL parseUserByData:jsonData completion:loginCompletion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)startRegistWithUserEmail:(NSString *)email password:(NSString *)password completion:(void (^)(BOOL, id, NSError *))completion
{
    registCompletion = completion;
    
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    NSString *apKey = [MD5Helper md5Digest:md5];
    
    NSString *params = [UserDAL getRegistURLParamsWithApKey:apKey email:email password:password language:currentLanguage() productID:productID() mcKey:[OpenUDID value]];
    
    [self initRequestClient];
    
    [requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kRegistMethod] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [UserDAL parseUserByData:jsonData completion:registCompletion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)startFindBackUserPasswordWithEmail:(NSString *)email completion:(void (^)(BOOL, id, NSError *))completion
{
    findPasswordCompletion = completion;
    
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    NSString *apKey = [MD5Helper md5Digest:md5];
    
    NSString *params = [UserDAL getPasswordBackURLParamsWithApKey:apKey email:email language:currentLanguage() productID:productID()];
    
    [self initRequestClient];
    
    [requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kFindPassword] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [UserDAL parseUserFindPasswordData:jsonData completion:findPasswordCompletion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

#pragma mark - Cancel
- (void)cancelLogin
{
    [requestClient cancelAllRequest];
}

@end
