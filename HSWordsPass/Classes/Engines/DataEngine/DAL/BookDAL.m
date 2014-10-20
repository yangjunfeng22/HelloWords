//
//  BookDAL.m
//  HSWordsPass
//
//  Created by yang on 14-8-28.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "BookDAL.h"
#import "BookModel.h"
#import "BookTranslationModel.h"
#import "BookCategoryModel.h"
#import "BookCategoryTransModel.h"
#import "URLUtility.h"
#import "Constants.h"

void (^parseCategoryDataCompletion)(BOOL finished, id result, NSError *error);
void (^parseWordBookDataCompletion)(BOOL finished, id result, NSError *error);
void (^parseWordBookTranslationDataCompletion)(BOOL finished, id result, NSError *error);

@implementation BookDAL
NSInteger parseCount;
NSInteger totalCount;

NSInteger parseBookCount;
NSInteger totalBookCount;

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
    
}


#pragma mark - 书本种类的数据操作
+ (NSString *)getCategoryRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID
{
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, language, productID, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"email", @"language", @"productID", nil]]];
}

+ (void)parseCategoryByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
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
            [self parseCategoryRequestResult:results completion:completion];
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

+ (void)parseCategoryRequestResult:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSArray class]])
    {
        parseCategoryDataCompletion = completion;
        parseCount = 0;
        totalCount = [resultData count];
        for (NSDictionary *dicRecord in resultData)
        {
            @autoreleasepool
            {
                NSString *cID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Bcid"]];
                NSString *name = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Name"]];
                NSString *picture = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Picture"]];
                NSInteger weight = [[[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Weight"]] integerValue];
                
                NSArray *arrTranslation = [dicRecord objectForKey:@"Translation"];
                for (NSDictionary *dicTran in arrTranslation)
                {
                    NSString *language = [[NSString alloc] initWithFormat:@"%@", [dicTran objectForKey:@"Language"]];
                    NSString *tName = [[NSString alloc] initWithFormat:@"%@", [dicTran objectForKey:@"Name"]];
                    
                    [self saveBookCategoryTranslationWithCategoryID:cID language:language name:tName completion:^(BOOL finished, id obj, NSError *error) {}];
                }
                
                [self saveWordBookCategoryWithCategoryID:cID name:name picture:picture weight:weight completion:^(BOOL finished, id obj, NSError *error) {
                    parseCount++;
                    if (parseCount >= totalCount)
                    {
                        if (parseCategoryDataCompletion) {
                            parseCategoryDataCompletion(YES, nil, error);
                        }
                    }
                }];
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
// 词书的数据
+ (void)saveWordBookCategoryWithCategoryID:(NSString *)cID name:(NSString *)name picture:(NSString *)picture weight:(NSInteger)weight completion:(void(^)(BOOL finished, id obj, NSError *error))completion
{
    BookCategoryModel *category = [self queryWordBookCategoryWithCategoryID:cID];
    // 不支持后台动态调整词书所属的词书种类。这里是一本词书是固定属于一种词书种类的。
    BOOL needUpdate = [category.cID isEqualToString:cID];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        BookCategoryModel *tCategory = needUpdate ? [category inContext:localContext] : [BookCategoryModel createEntityInContext:localContext];
        cID ? tCategory.cID = cID:cID;
        name ? tCategory.name = name:name;
        picture ? tCategory.picture = picture:picture;
        tCategory.weightValue = weight;
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

// 词书的翻译数据
+ (void)saveBookCategoryTranslationWithCategoryID:(NSString *)cID language:(NSString *)language name:(NSString *)name completion:(void(^)(BOOL finished, id obj, NSError *error))completion
{
    BookCategoryTransModel *bookCategoryTran = [self queryBookCategoryTranslationWithCategoryID:cID language:language];
    
    BOOL needUpdate = [bookCategoryTran.cID isEqualToString:cID] && [bookCategoryTran.language isEqualToString:language];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        BookCategoryTransModel *tBookCategoryTran = needUpdate ? [bookCategoryTran inContext:localContext] : [BookCategoryTransModel createEntityInContext:localContext];
        cID  ? tBookCategoryTran.cID = cID:cID;
        language ? tBookCategoryTran.language = language:language;
        name ? tBookCategoryTran.name = name:name;
        
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

+ (NSArray *)queryWordBookCategoryInfos
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSArray *categorys = [BookCategoryModel findAllSortedBy:@"weight,cID" ascending:YES inContext:context];
    return categorys;
}

+ (NSInteger)bookCategoryCount
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSInteger count = [BookCategoryModel countOfEntitiesWithContext:context];
    return count;
}

+ (BookCategoryModel *)queryWordBookCategoryWithCategoryID:(NSString *)cID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cID == %@", cID];
    BookCategoryModel *category = (BookCategoryModel *)[BookCategoryModel findFirstWithPredicate:predicate inContext:context];
    return category;
}

// bookCategoryTranslation
+ (BookCategoryTransModel *)queryBookCategoryTranslationWithCategoryID:(NSString *)cID language:(NSString *)language
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cID == %@ AND language == %@", cID, language];
    BookCategoryTransModel *bookCategoryTran = (BookCategoryTransModel *)[BookCategoryTransModel findFirstWithPredicate:predicate inContext:context];
    return bookCategoryTran;
}

#pragma mark - 书本的数据操作

#pragma mark - 数据的请求及解析
+ (NSString *)getWordBookRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email categoryID:(NSString *)categoryID language:(NSString *)language productID:(NSString *)productID
{
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, categoryID, language, productID, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"email", @"bcid", @"language", @"productID", nil]]];
}

+ (NSString *)getBookVersionRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email bookID:(NSString *)bID productID:(NSString *)productID
{
    return [URLUtility getURLFromParams:@{@"apkey": (apKey ? apKey : @""), @"email": (email ? email : @""), @"bid": (bID ? bID : @""), @"productID": (productID ? productID : @"")}];
}

// 解词书的数据
+ (void)parseWordBookByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
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
            [self parseWordBookRequestResult:results completion:completion];
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

+ (void)parseWordBookRequestResult:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSArray class]])
    {
        parseWordBookDataCompletion = completion;
        parseBookCount = 0;
        totalBookCount = [resultData count];
        for (NSDictionary *dicRecord in resultData)
        {
            @autoreleasepool
            {
                NSString *cID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Bcid"]];
                NSString *bID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Bid"]];
                NSString *name = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Name"]];
                NSString *picture = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Picture"]];
                NSInteger weight = [[[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Weight"]] integerValue];
                NSInteger count = [[dicRecord objectForKey:@"Count"] integerValue];
                BOOL showTone = [[dicRecord objectForKey:@"Show"] boolValue];
                //NSString *version = [dicRecord objectForKey:@"Version"];
                
                NSArray *arrTranslation = [dicRecord objectForKey:@"Translation"];
                for (NSDictionary *dicTran in arrTranslation)
                {
                    NSString *language = [[NSString alloc] initWithFormat:@"%@", [dicTran objectForKey:@"Language"]];
                    NSString *tName = [[NSString alloc] initWithFormat:@"%@", [dicTran objectForKey:@"Name"]];
                    [self saveWordBookTranslationWithBookID:bID language:language name:tName completion:^(BOOL finished, id obj, NSError *error) {}];
                    
                }
                
                [self saveWordBookWithBookID:bID categoryID:cID name:name picture:picture weight:weight wordCount:count showTone:showTone version:nil completion:^(BOOL finished, id obj, NSError *error) {
                    parseBookCount++;
                    if (parseBookCount >= totalBookCount)
                    {
                        if (parseWordBookDataCompletion) {
                            parseWordBookDataCompletion(YES, nil, error);
                        }
                    }
                }];
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

// 解词书的数据
+ (void)parseBookVersionByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        //NSString *bID = [[NSString alloc] initWithFormat:@"%@", [resultData objectForKey:@"Bid"]];
        NSString *version = [[NSString alloc] initWithFormat:@"%@", [resultData objectForKey:@"Version"]];
        
        
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
// 词书的数据
+ (void)saveWordBookWithBookID:(NSString *)bID categoryID:(NSString *)cID name:(NSString *)name picture:(NSString *)picture weight:(NSInteger)weight wordCount:(NSInteger)count showTone:(BOOL)showTone version:(NSString *)version completion:(void(^)(BOOL finished, id obj, NSError *error))completion
{
    BookModel *wordBook = [self queryWordBookWithCategoryID:cID bookID:bID];
    // 不支持后台动态调整词书所属的词书种类。这里是一本词书是固定属于一种词书种类的。
    BOOL needUpdate = [wordBook.cID isEqualToString:cID] && [wordBook.bID isEqualToString:bID];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        BookModel *tWordBook = needUpdate ? [wordBook inContext:localContext] : [BookModel createEntityInContext:localContext];
        cID ? tWordBook.cID = cID:cID;
        bID ? tWordBook.bID = bID:bID;
        name ? tWordBook.name = name:name;
        picture ? tWordBook.picture = picture:picture;
        tWordBook.weightValue = weight;
        count > 0 ? tWordBook.wCountValue = count:count;
        tWordBook.showToneValue = showTone;
        version ? tWordBook.version = version:version;
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion) {
            completion(success, nil, error);
        }
        
    }];
}

+ (NSArray *)queryWordBookInfos
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSArray *arrSoftware = [BookModel findAllInContext:context];
    return arrSoftware;
}

+ (NSArray *)queryWordBookInfosWithCategoryID:(NSString *)cID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSArray *arrWordBooks = [BookModel findByAttribute:@"cID" withValue:cID inContext:context];
    return arrWordBooks;
}

+ (BookModel *)queryWordBookWithCategoryID:(NSString *)cID bookID:(NSString *)bID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cID == %@ AND bID == %@", cID, bID];
    BookModel *wordBook = (BookModel *)[BookModel findFirstWithPredicate:predicate inContext:context];
    return wordBook;
}

+ (NSInteger)wordBookCount
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSInteger count = [BookModel countOfEntitiesWithContext:context];
    return count;
}

+ (NSInteger)wordBookCountWithCategoryID:(NSString *)cID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cID == %@", cID];
    NSInteger count = [BookModel countOfEntitiesWithPredicate:predicate inContext:context];
    return count;
}

// 词书翻译的数据
+ (void)saveWordBookTranslationWithBookID:(NSString *)bID language:(NSString *)language name:(NSString *)name completion:(void(^)(BOOL finished, id obj, NSError *error))completion
{
    BookTranslationModel *bookTran = [self queryWordBookTranslationWithBookID:bID language:language];
    // 不支持后台动态调整词书所属的词书种类。这里是一本词书是固定属于一种词书种类的。
    BOOL needUpdate = [bookTran.bID isEqualToString:bID] && [bookTran.language isEqualToString:language];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        BookTranslationModel *tBookTran = needUpdate ? [bookTran inContext:localContext] : [BookTranslationModel createEntityInContext:localContext];
        bID ? tBookTran.bID = bID:bID;
        language ? tBookTran.language = language:language;
        name ? tBookTran.name = name:name;
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

// 词书的翻译
+ (BookTranslationModel *)queryWordBookTranslationWithBookID:(NSString *)bID language:(NSString *)language
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bID == %@ AND language == %@", bID, language];
    BookTranslationModel *wordBookTran = (BookTranslationModel *)[BookTranslationModel findFirstWithPredicate:predicate inContext:context];
    return wordBookTran;
}

+ (id)fetchAllWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    id result = [BookModel fetchAllSortedBy:@"weight,bID" ascending:YES withPredicate:nil groupBy:nil delegate:delegate inContext:context];
    return result;
}

+ (id)fetchAllWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate categoryID:(NSString *)cID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cID == %@", cID];
    id result = [BookModel fetchAllSortedBy:@"weight,bID" ascending:YES withPredicate:predicate groupBy:nil delegate:delegate inContext:context];
    return result;
}

@end
