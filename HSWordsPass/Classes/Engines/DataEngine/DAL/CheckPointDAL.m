//
//  CheckPointDAL.m
//  HSWordsPass
//
//  Created by yang on 14-9-5.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "CheckPointDAL.h"
#import "CheckPointModel.h"
#import "CheckPointProgressModel.h"
#import "URLUtility.h"
#import "Constants.h"

void (^parseCheckPointDataCompletion)(BOOL finished, id result, NSError *error);
void (^parseCheckPointProgressDataCompletion)(BOOL finished, id result, NSError *error);

@implementation CheckPointDAL
NSInteger parseCount;
NSInteger totalCount;

NSInteger parsePCount;
NSInteger totalPCount;

#pragma mark - 数据的请求及解析
+ (NSString *)getCheckPointRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email bookID:(NSString *)bookID language:(NSString *)language productID:(NSString *)productID
{
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, bookID, language, productID, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"email", @"bid", @"language", @"productID", nil]]];
}

+ (NSString *)getCheckPointTranslationRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email checkPointID:(NSString *)cpID language:(NSString *)language productID:(NSString *)productID
{
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, cpID, language, productID, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"email", @"cpID", @"language", @"productID", nil]]];
}

+ (NSString *)getCheckPointProgressRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email bookID:(NSString *)bID records:(NSString *)records language:(NSString *)language productID:(NSString *)productID
{
    return [URLUtility getURLFromParams:@{@"apkey": (apKey ? apKey : @""), @"email": (email ? email : @""), @"bid": (bID ? bID : @""), @"records": (records ? records : @""), @"language": (language ? language : @""), @"productID": (productID ? productID : @"")}];
}

+ (NSString *)getCheckPointVersionRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email checkPointID:(NSString *)cpID productID:(NSString *)productID
{
    return [URLUtility getURLFromParams:@{@"apkey": (apKey ? apKey : @""), @"email": (email ? email : @""), @"cpid": (cpID ? cpID : @""), @"productID": (productID ? productID : @"")}];
}

+ (NSString *)getDownloadCheckPointDataURLParamsWithApKey:(NSString *)apKey email:(NSString *)email bookID:(NSString *)bID checkPointID:(NSString *)cpID productID:(NSString *)productID version:(NSString *)version
{
    NSString *strUrl = [NSString stringWithFormat:@"data/%@/%@.zip", bID, cpID];
    
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, strUrl, productID, version, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"email", @"url", @"productID", @"version", nil]]];
}

// 解关卡下载链接数据
+ (void)parseCheckPointDownloadByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    NSError *error;
    if (resultData) {
        error = [NSError errorWithDomain:NSLocalizedString(@"获取信息成功!", @"") code:0 userInfo:nil];
    }else{
        error = [NSError errorWithDomain:NSLocalizedString(@"获取下载链接失败!", @"") code:1 userInfo:nil];
    }
    
    completion(YES, [resultData objectForKey:@"Url"], error);
}

// 解关卡的数据
+ (void)parseCheckPointByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        
        id results = [resultData objectForKey:@"Records"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];

        if (success)
        {
            [self parseCheckPointRequestResult:results completion:completion];
        }
        else
        {
            if (completion) {
                completion(success, nil, error);
            }
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:NSLocalizedString(@"数据封装出错!", @"") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (void)parseCheckPointRequestResult:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    DLOG_CMETHOD;
    if ([resultData isKindOfClass:[NSArray class]])
    {
        parseCheckPointDataCompletion = completion;
        parseCount = 0;
        totalCount = [resultData count];
        
        //NSString *bookID = kBookID;
        //NSInteger cpCount = [self checkPointCountWithBookID:bookID];
        
        // 如果新的关卡的总数多于当前的, 那么更新即可。
        // 否则删除多余的关卡
        //if (totalCount < cpCount)
        {
            //[self deleteAllCheckPointWithBookID:bookID];
        }
        
        for (NSDictionary *dicRecord in resultData)
        {
            //DLog(@"dicRecord: %@", dicRecord);
            NSString *cpID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Cpid"]];
            NSString *bID  = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Bid"]];
            NSString *name = [dicRecord objectForKey:@"Name"];
            NSInteger index = [[dicRecord objectForKey:@"Index"] integerValue];
            
            [self saveCheckPointWithCheckPointID:cpID bookID:bID name:name index:index completion:^(BOOL finished, id obj, NSError *error) {
                parseCount++;
                if (parseCount >= totalCount)
                {
                    if (parseCheckPointDataCompletion) {
                        parseCheckPointDataCompletion(YES, nil, error);
                    }
                }
            }];
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:NSLocalizedString(@"数据封装出错!", @"") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}


// 解关卡进度的数据
+ (void)parseCheckPointProgressByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        NSString *uID = [[NSString alloc] initWithFormat:@"%@", [resultData objectForKey:@"Uid"]];
        id results = [resultData objectForKey:@"Records"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        
        if (success)
        {
            [self parseCheckPointProgressRequestResult:results userID:uID completion:completion];
        }
        else
        {
            if (completion) {
                completion(success, nil, error);
            }
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:NSLocalizedString(@"数据封装出错!", @"") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

+ (void)parseCheckPointProgressRequestResult:(id)resultData userID:(NSString *)uID completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSArray class]])
    {
        parsePCount = 0;
        totalPCount = [resultData count];
        for (NSDictionary *dicRecord in resultData)
        {
            @autoreleasepool
            {
                NSString *cpID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Cpid"]];
                NSString *bID  = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Bid"]];
                
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    
                    CGFloat progress = [[dicRecord objectForKey:@"Progress"] floatValue];
                    NSInteger status = [[dicRecord objectForKey:@"Status"] integerValue];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self saveCheckPointProgressWithUserID:uID CheckPointID:cpID bookID:bID version:@"" progress:progress status:status completion:^(BOOL finished, id obj, NSError *error) {
                            parsePCount++;
                            if (parsePCount >= totalPCount)
                            {
                                if (completion) {
                                    completion(YES, nil, error);
                                }
                            }
                        }];
                    });
                });
            }
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:NSLocalizedString(@"数据封装出错!", @"") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

// 解关卡进度的数据
+ (void)parseCheckPointVersionByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        //NSString *cpID = [[NSString alloc] initWithFormat:@"%@", [resultData objectForKey:@"Cpid"]];
        NSString *version = [resultData objectForKey:@"Version"];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        
        if (success)
        {
            if (completion) {
                completion(success, version, error);
            }
        }
        else
        {
            if (completion) {
                completion(success, nil, error);
            }
        }
    }
    else
    {
        NSError *error = [NSError errorWithDomain:NSLocalizedString(@"数据封装出错!", @"") code:-1 userInfo:nil];
        if (completion) {
            completion(NO, nil, error);
        }
    }
}

#pragma mark - 数据的数据库操作
// 关卡的数据
+ (void)saveCheckPointWithCheckPointID:(NSString *)cpID bookID:(NSString *)bID name:(NSString *)name index:(NSInteger)index completion:(void(^)(BOOL finished, id obj, NSError *error))completion
{
    CheckPointModel *checkPoint = [self queryCheckPointWithBookID:bID checkPointID:cpID];
    BOOL needUpdate = [checkPoint.cpID isEqualToString:cpID];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        CheckPointModel *tCheckPoint = needUpdate ? [checkPoint inContext:localContext] : [CheckPointModel createEntityInContext:localContext];
        cpID ? tCheckPoint.cpID = cpID:cpID;
        bID ? tCheckPoint.bID = bID:bID;
        name ? tCheckPoint.name = name:name;
        index >= 0 ? tCheckPoint.indexValue = index:index;
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

// 关卡进度的数据
+ (void)saveCheckPointProgressWithUserID:(NSString *)uID CheckPointID:(NSString *)cpID bookID:(NSString *)bID version:(NSString *)version progress:(CGFloat)progress status:(NSInteger)status completion:(void (^)(BOOL finished, id obj, NSError *error))completion
{
    CheckPointProgressModel *checkPoint = [self queryCheckPointProgressWithUserID:uID bookID:bID checkPointID:cpID];
    BOOL needUpdate = [checkPoint.cpID isEqualToString:cpID] && [checkPoint.uID isEqualToString:uID];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        CheckPointProgressModel *tCheckPoint = needUpdate ? [checkPoint inContext:localContext] : [CheckPointProgressModel createEntityInContext:localContext];
        cpID ? tCheckPoint.cpID = cpID:cpID;
        bID ? tCheckPoint.bID = bID:bID;
        uID ? tCheckPoint.uID = uID:uID;
        //version ? tCheckPoint.version = version:version;
        tCheckPoint.progressValue = progress;
        tCheckPoint.statusValue = status;
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

+ (NSArray *)queryCheckPointsWithBookID:(NSString *)bID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSArray *arrModels = [CheckPointModel findByAttribute:@"bID" withValue:bID andOrderBy:@"index" ascending:YES inContext:context];
    return arrModels;
}

+ (CheckPointModel *)queryCheckPointWithBookID:(NSString *)bID checkPointID:(NSString *)cpID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bID == %@ AND cpID == %@", bID, cpID];
    CheckPointModel *checkPoint = (CheckPointModel *)[CheckPointModel findFirstWithPredicate:predicate inContext:context];
    return checkPoint;
}

+ (CheckPointModel *)queryNextCheckPointWithBookID:(NSString *)bID index:(NSInteger)index
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bID == %@ AND index == %@", bID, [NSNumber numberWithInteger:index]];
    
    CheckPointModel *checkPoint = (CheckPointModel *)[CheckPointModel findFirstWithPredicate:predicate inContext:context];
    
    predicate = [NSPredicate predicateWithFormat:@"bID == %@", bID];
    NSArray *arrCp = [CheckPointModel findAllSortedBy:@"index" ascending:YES withPredicate:predicate inContext:context];
    NSInteger count = [arrCp count];
    NSInteger tIndex = [arrCp indexOfObject:checkPoint];
    if (tIndex >= 0 && tIndex < count-1){
        checkPoint = [arrCp objectAtIndex:tIndex+1];
    }
    return checkPoint;
}

+ (CheckPointModel *)queryCheckPointWithBookID:(NSString *)bID index:(NSInteger)index
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bID == %@ AND index == %@", bID, [NSNumber numberWithInteger:index]];
    
    CheckPointModel *checkPoint = (CheckPointModel *)[CheckPointModel findFirstWithPredicate:predicate inContext:context];
    return checkPoint;
}

+ (NSInteger)checkPointCountWithBookID:(NSString *)bID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bID == %@", bID];
    NSInteger count = [CheckPointModel countOfEntitiesWithPredicate:predicate inContext:context];
    return count;
}

+ (BOOL)deleteAllCheckPointWithBookID:(NSString *)bID
{
    NSManagedObjectContext *context = [NSManagedObjectContext rootSavingContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bID == %@", bID];
    return [CheckPointModel deleteAllMatchingPredicate:predicate inContext:context];
}

#pragma mark - 关卡进度数据的查询
+ (CheckPointProgressModel *)queryCheckPointProgressWithUserID:(NSString *)uID bookID:(NSString *)bID checkPointID:(NSString *)cpID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND bID == %@ AND cpID == %@", uID, bID, cpID];
    CheckPointProgressModel *model = (CheckPointProgressModel *)[CheckPointProgressModel findFirstWithPredicate:predicate inContext:context];
    return model;
}

/*
+ (CheckPointProgressModel *)queryCheckPointProgressWithUserID:(NSString *)uID checkPointID:(NSString *)cpID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND cpID == %@", uID, cpID];
    CheckPointProgressModel *model = (CheckPointProgressModel *)[CheckPointProgressModel findFirstWithPredicate:predicate inContext:context];
    return model;
}
 */

+ (NSInteger)countOfCheckPointProgressWithUserID:(NSString *)uID bookID:(NSString *)bID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND bID == %@", uID, bID];
    NSInteger count = [CheckPointProgressModel countOfEntitiesWithPredicate:predicate inContext:context];
    return count;
}

+ (NSArray *)queryAllCheckPointProgressWithUserID:(NSString *)uID bookID:(NSString *)bID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND bID == %@", uID, bID];
    NSArray *arr = [CheckPointProgressModel findAllWithPredicate:predicate inContext:context];
    return arr;
}

+ (NSArray *)queryAllCheckPointProgressWithUserID:(NSString *)uID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSArray *arr = [CheckPointProgressModel findByAttribute:@"uID" withValue:uID inContext:context];
    return arr;
}

@end
