//
//  UpdateAppDAL.m
//  HelloHSK
//
//  Created by yang on 14-4-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "UpdateAppDAL.h"
#import "URLUtility.h"
#import "Constants.h"

static UpdateAppDAL *instance = nil;

@implementation UpdateAppDAL

+(UpdateAppDAL *)sharedInstance
{
    /*
    if(instance==nil)
    {
        instance=[[UpdateAppDAL alloc] init];
    }
    return instance;
     */
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(void)dealloc
{
    instance = nil;
}

- (NSString *)getCheckAppUpdateInfoURLParamsWithProductID:(NSString *)productID version:(NSString *)version language:(NSString *)language
{
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:productID, version, language, nil] forKeys:[NSArray arrayWithObjects:@"name", @"version", @"language", nil]]];
}

- (id)parseAppUpdateInfoByData:(id)resultData
{
    id object = nil;
    _needUpdate = 0;
    //NSLog(@"resultData: %@", resultData);
    _error = [NSError errorWithDomain:NSLocalizedString(@"连接失败", @"") code:0 userInfo:nil];
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        NSString *strMessage = [resultData objectForKey:@"Message"];
        
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        BOOL must    = [[resultData objectForKey:@"Must"] boolValue];
        _needUpdate = must;
        if (success)
        {
            _error = [NSError errorWithDomain:strMessage code:success userInfo:nil];
        }
    }
    return object;
}

@end
