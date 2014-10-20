//
//  UpdateAppDAL.h
//  HelloHSK
//
//  Created by yang on 14-4-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateAppDAL : NSObject

@property (nonatomic, strong, readonly)NSError *error;
@property (nonatomic, readwrite)BOOL needUpdate;

+(UpdateAppDAL *)sharedInstance;

- (NSString *)getCheckAppUpdateInfoURLParamsWithProductID:(NSString *)productID version:(NSString *)version language:(NSString *)language;

- (id)parseAppUpdateInfoByData:(id)resultData;

@end
