//
//  AppRecommendDAL.h
//  HelloHSK
//
//  Created by yang on 14-4-16.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppRecommendDAL : NSObject

@property (nonatomic, strong, readonly)NSError *error;

+(AppRecommendDAL *)sharedInstance;

- (NSString *)getCheckAppRecommendInfoURLParamsWithProductID:(NSString *)productID language:(NSString *)language;

- (id)parseAppRecommendInfoByData:(id)resultData;
@end
