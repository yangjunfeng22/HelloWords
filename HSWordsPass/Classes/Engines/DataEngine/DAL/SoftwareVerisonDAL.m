//
//  HSSoftwareVerisonDAL.m
//  HSWordsPass
//
//  Created by yang on 14-8-28.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "SoftwareVerisonDAL.h"
#import "SoftwareVersionModel.h"

@implementation SoftwareVerisonDAL

+ (void)saveSoftwareVersionWithVersion:(NSString *)version dbVersion:(NSString *)dbVersion launched:(BOOL)launched completion:(void (^)(BOOL finished, id result, NSError *error))completion
{
    SoftwareVersionModel *soft = [self querySoftwareVersionWithVersion:version];
    BOOL needUpdate = [soft.version isEqualToString:version];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        SoftwareVersionModel *tSoft = needUpdate ? [soft inContext:localContext] : [SoftwareVersionModel createEntityInContext:localContext];
        version ? tSoft.version = version:version;
        dbVersion ? tSoft.dbVersion = dbVersion:dbVersion;
        tSoft.launchedValue = launched;
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

+ (NSArray *)querySoftwareVersionInfos
{
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSArray *arrSoftware = [SoftwareVersionModel findAllInContext:context];
    return arrSoftware;
}

+ (SoftwareVersionModel *)querySoftwareVersionWithVersion:(NSString *)version
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    SoftwareVersionModel *softwareVersion = [SoftwareVersionModel findFirstByAttribute:@"version" withValue:version inContext:context];
    return softwareVersion;
}

+ (BOOL)isLaunchedWithVersion:(NSString *)version
{
    SoftwareVersionModel *soft = [self querySoftwareVersionWithVersion:version];
    DLog(@"soft: %@", soft);
    if (soft && soft.launchedValue){
        return YES;
    }else{
        return NO;
    }
}

@end
