//
//  UpdateAppNet.m
//  HelloHSK
//
//  Created by yang on 14-4-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "UpdateAppNet.h"
#import "HttpClient.h"
#import "UpdateAppDAL.h"
#import "ResponseModel.h"
#import "CommonHelper.h"
#import "SystemInfoHelper.h"

static UpdateAppNet *instance = nil;

@interface UpdateAppNet ()
{
    HttpClient *requestClient;
}

@end

@implementation UpdateAppNet

hsSharedInstanceImpClass(UpdateAppNet);

-(void)dealloc
{
    instance=nil;
}

- (void)initRequestClient
{
    if (!requestClient)
    {
        requestClient = [[HttpClient alloc] init];
    }
}


-(void)checkAppUpdateInfo:(void (^)(BOOL, id, NSError *))completion{
    
    UpdateAppDAL *appUpdateDAL = [[UpdateAppDAL alloc] init];
    NSString *params = [appUpdateDAL getCheckAppUpdateInfoURLParamsWithProductID:productID()/*productPlatform()*/ version:kSoftwareVersion language:currentLanguage()];
    NSString *url = [kHostUrl stringByAppendingString:kUpdateApp];
    
    [self initRequestClient];
    
    [requestClient postRequestFromURL:url params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        DLog(@"error: %@; %@", error.localizedDescription, responseString);
        id jsonData;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        }
        
        ResponseModel *response = [[ResponseModel alloc] init];
        response.resultInfo = [appUpdateDAL parseAppUpdateInfoByData:jsonData];
        response.error = appUpdateDAL.error;
        response.statuCode = appUpdateDAL.needUpdate;
        
        if (jsonData) {
            completion(NO, response, error);;
        }
    }];
}

-(void)cancelCheck
{
    [requestClient cancelRequest];
}

@end
