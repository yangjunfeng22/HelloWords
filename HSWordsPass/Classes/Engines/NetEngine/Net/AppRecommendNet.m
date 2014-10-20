//
//  AppRecommendNet.m
//  HelloHSK
//
//  Created by yang on 14-4-16.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "AppRecommendNet.h"
//#import "JSONKit.h"
#import "HttpClient.h"
#import "AppRecommendDAL.h"
#import "ResponseModel.h"
#import "SystemInfoHelper.h"

@interface AppRecommendNet ()
{
    HttpClient *requestClient;
}

@property (nonatomic, strong)id jsonData;




@end

@implementation AppRecommendNet

-(void)dealloc
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


-(void)checkAppRecommendInfo:(void (^)(BOOL, id, NSError *))completion{
    AppRecommendDAL *appRecommendDAL = [[AppRecommendDAL alloc] init];
    NSString *params = [appRecommendDAL getCheckAppRecommendInfoURLParamsWithProductID:productID() language:currentLanguage()];
    NSString *url = [kHostUrl stringByAppendingString:KAppRecommend];
    
    
    [self initRequestClient];
    [requestClient postRequestFromURL:url params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        DLog(@"error: %@; %@", error.localizedDescription, responseString);
        if (responseData && error.code == 0) {
            self.jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"生词 jsonData: %@", jsonData);
        }
        
        if (self.jsonData) {
            completion(NO, [appRecommendDAL parseAppRecommendInfoByData:self.jsonData], error);;
        }
    }];
    
    
}

- (void)cancelCheck
{
    [requestClient cancelRequest];
}

@end
