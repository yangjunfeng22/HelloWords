//
//  HSSoftwareVerisonDAL.h
//  HSWordsPass
//
//  Created by yang on 14-8-28.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SoftwareVersionModel;

@interface SoftwareVerisonDAL : NSObject

+ (void)saveSoftwareVersionWithVersion:(NSString *)version dbVersion:(NSString *)dbVersion launched:(BOOL)launched completion:(void (^)(BOOL finished, id result, NSError *error))completion;

+ (NSArray *)querySoftwareVersionInfos;

+ (SoftwareVersionModel *)querySoftwareVersionWithVersion:(NSString *)version;

+ (BOOL)isLaunchedWithVersion:(NSString *)version;

@end
