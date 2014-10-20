//
//  WordListDAL.m
//  HSWordsPass
//
//  Created by yang on 14-9-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "WordDAL.h"
#import "WordModel.h"
#import "WordTranslationModel.h"
#import "SentenceModel.h"
#import "SentenceTranslationModel.h"
#import "Word_SentenceModel.h"
#import "CheckPoint_WordModel.h"
#import "WordLearnInfoModel.h"
#import "WordReviewModel.h"
#import "CheckPointModel.h"

#import "URLUtility.h"
#import "Constants.h"

void (^parseWordLearnedRecordsCompletion)(BOOL finished, id result, NSError *error);
void (^parseWordDataCompletion)(BOOL finished, id result, NSError *error);
void (^parseWordReviewCompletion)(BOOL finished, id result, NSError *error);

@implementation WordDAL
NSInteger parseCount;
NSInteger totalCount;

NSInteger parseWordLearnCount;
NSInteger totalWordLearnCount;

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

#pragma mark - 数据的请求参数
+ (NSString *)getWordRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email checkPointID:(NSString *)cpID wordID:(NSString *)wID language:(NSString *)language productID:(NSString *)productID
{
    return [URLUtility getURLFromParams:@{@"apkey": (apKey ? apKey : @""), @"email": (email ? email : @""), @"cpid": (cpID ? cpID : @""), @"wid": (wID ? wID : @""), @"language": (language ? language : @""), @"productID": (productID ? productID : @"")}];
}

+ (NSString *)getWordSentenceRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email wordID:(NSString *)wID language:(NSString *)language productID:(NSString *)productID
{
    return [URLUtility getURLFromParams:@{@"apkey": (apKey ? apKey : @""), @"email": (email ? email : @""),  @"wid": (wID ? wID : @""), @"language": (language ? language : @""), @"productID": (productID ? productID : @"")}];
}

#pragma mark - 数据的解析
// 解词的数据
+ (void)parseWordByData:(id)resultData checkPointID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion
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
            [self parseWordRequestResult:results checkPointID:cpID completion:completion];
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

+ (void)parseWordRequestResult:(id)resultData checkPointID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion
{
    DLOG_CMETHOD;
    if ([resultData isKindOfClass:[NSArray class]])
    {
        parseWordDataCompletion = completion;
        parseCount = 0;
        totalCount = [resultData count];
        for (NSDictionary *dicRecord in resultData)
        {
            //DLog(@"dicRecord: %@", dicRecord);
            @autoreleasepool
            {
                NSString *wID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Wid"]];
                NSString *chinese = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Chinese"]];
                NSString *pinyin = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Pinyin"]];
                NSString *property = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Property"]];
                NSString *audio = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Audio"]];

                NSString *dataDPath = [NSString stringWithFormat:@"%@", cpID];
                NSString *destionPath = [kDownloadedPath stringByAppendingPathComponent:dataDPath];
                NSString *tAudio = [audio isEqualToString:@""] ? @"" : [destionPath stringByAppendingPathComponent:audio];
                
                NSString *picture = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Picture"]];
                
                NSDictionary *dicTranslation = [dicRecord objectForKey:@"Translation"];
                NSString *language = [[NSString alloc] initWithFormat:@"%@", [dicTranslation objectForKey:@"Language"]];
                NSString *tChinese = [[NSString alloc] initWithFormat:@"%@", [dicTranslation objectForKey:@"Chinese"]];
                NSString *tProperty = [[NSString alloc] initWithFormat:@"%@", [dicTranslation objectForKey:@"Property"]];
                
                // 保存翻译数据
                [self saveWordTranslationWithWordID:wID language:language chinese:tChinese property:tProperty completion:^(BOOL finished, id obj, NSError *error) {}];
                
                // 保存关卡-词对应关系。
                [self saveCheckPoint_WordWithCheckPointID:cpID wordID:wID completion:^(BOOL finished, id obj, NSError *error) {}];
                /*
                // 保存关卡-词对应数据
                NSArray *arrCheckPoint = [dicRecord objectForKey:@"CheckPoint"];
                //DLog(@"arrCheckPoint: %@", arrCheckPoint);
                for (id cpID in arrCheckPoint)
                {
                    //DLog(@"cpID: %@", cpID);
                    NSString *strCpID = [[NSString alloc] initWithFormat:@"%@", cpID];
                    [self saveCheckPoint_WordWithCheckPointID:strCpID wordID:wID completion:^(BOOL finished, id obj, NSError *error) {}];
                }
                */
                // 保存例句的数据
                NSArray *arrSentence = [dicRecord objectForKey:@"Sentence"];
                //DLog(@"例句 arrSentence : %@", arrSentence);
                for (NSDictionary *dicSentece in arrSentence)
                {
                    NSString *sID = [[NSString alloc] initWithFormat:@"%@", [dicSentece objectForKey:@"Sid"]];
                    NSString *chinese = [[NSString alloc] initWithFormat:@"%@", [dicSentece objectForKey:@"Chinese"]];
                    NSString *pinyin = [[NSString alloc] initWithFormat:@"%@", [dicSentece objectForKey:@"Pinyin"]];
                    NSString *audio = [[NSString alloc] initWithFormat:@"%@", [dicSentece objectForKey:@"Audio"]];
                    
                    NSString *dataDPath = [NSString stringWithFormat:@"%@", cpID];
                    NSString *destionPath = [kDownloadedPath stringByAppendingPathComponent:dataDPath];
                    NSString *tAudio = [audio isEqualToString:@""] ? @"" : [destionPath stringByAppendingPathComponent:audio];
                    
                    NSDictionary *dicTranslation = [dicSentece objectForKey:@"Translate"];
                    NSString *language = [[NSString alloc] initWithFormat:@"%@", [dicTranslation objectForKey:@"Language"]];
                    NSString *tChinese = [[NSString alloc] initWithFormat:@"%@", [dicTranslation objectForKey:@"Chinese"]];
                    
                    // 例句
                    [self saveSentenceWithSentenceID:sID chinese:chinese pinyin:pinyin audio:audio tAudio:tAudio completion:^(BOOL finished, id obj, NSError *error) {}];
                    // 例句的翻译
                    [self saveSentenceTranslationWithSentenceID:sID language:language chinese:tChinese completion:^(BOOL finished, id obj, NSError *error) {}];
                    // 词-例句的对应关系
                    [self saveWord_SentenceWithWordID:wID sentenceID:sID completion:^(BOOL finished, id obj, NSError *error) {}];
                }
                
                // 保存词数据
                [self saveWordWithWordID:wID chinese:chinese pinyin:pinyin property:property audio:audio  tAudio:tAudio picture:picture completion:^(BOOL finished, id obj, NSError *error) {
                    parseCount++;
                    if (parseCount >= totalCount)
                    {
                        if (parseWordDataCompletion) {
                            parseWordDataCompletion(YES, nil, error);
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

// 解词例句的数据
+ (void)parseWordSentenceByData:(id)resultData checkPointID:(NSString *)cpID wordID:(NSString *)wID completion:(void (^)(BOOL, id, NSError *))completion
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
            [self parseWordSentenceRequestResult:results checkPointID:cpID wordID:wID completion:completion];
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

NSInteger parseSentenceCount;
NSInteger totalSentenceCount;
+ (void)parseWordSentenceRequestResult:(id)resultData checkPointID:(NSString *)cpID wordID:(NSString *)wID completion:(void (^)(BOOL, id, NSError *))completion
{
    DLOG_CMETHOD;
    if ([resultData isKindOfClass:[NSArray class]])
    {
        parseSentenceCount = 0;
        totalSentenceCount = [resultData count];
        for (NSDictionary *dicRecord in resultData)
        {
            //DLog(@"dicRecord: %@", dicRecord);
            @autoreleasepool
            {
                NSString *sID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Sid"]];
                NSString *chinese = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Chinese"]];
                NSString *pinyin = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Pinyin"]];
                NSString *audio = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Audio"]];
                
                NSString *dataDPath = [NSString stringWithFormat:@"%@", cpID];
                NSString *destionPath = [kDownloadedPath stringByAppendingPathComponent:dataDPath];
                NSString *tAudio = [audio isEqualToString:@""] ? @"" : [destionPath stringByAppendingPathComponent:audio];
                
                NSDictionary *dicTranslation = [dicRecord objectForKey:@"Translate"];
                NSString *language = [[NSString alloc] initWithFormat:@"%@", [dicTranslation objectForKey:@"Language"]];
                NSString *tChinese = [[NSString alloc] initWithFormat:@"%@", [dicTranslation objectForKey:@"Chinese"]];
                
                // 例句
                [self saveSentenceWithSentenceID:sID chinese:chinese pinyin:pinyin audio:audio tAudio:tAudio completion:^(BOOL finished, id obj, NSError *error) {}];
                // 例句的翻译
                [self saveSentenceTranslationWithSentenceID:sID language:language chinese:tChinese completion:^(BOOL finished, id obj, NSError *error) {}];
                // 词-例句的对应关系
                [self saveWord_SentenceWithWordID:wID sentenceID:sID completion:^(BOOL finished, id obj, NSError *error) {
                    parseSentenceCount++;
                    if (parseSentenceCount >= totalSentenceCount)
                    {
                        if (completion) {
                            completion(YES, nil, error);
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

#pragma mark - 保存词、词的翻译的数据
+ (void)saveWordWithWordID:(NSString *)wID chinese:(NSString *)chinese pinyin:(NSString *)pinyin property:(NSString *)property audio:(NSString *)audio tAudio:(NSString *)tAudio picture:(NSString *)picture completion:(void(^)(BOOL finished, id obj, NSError *error))completion
{
    WordModel *word = [self queryWordWithWordID:wID];
    
    BOOL needUpdate = [word.wID isEqualToString:wID];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        WordModel *tWord = needUpdate ? [word inContext:localContext] : [WordModel createEntityInContext:localContext];
        wID      ? tWord.wID = wID:wID;
        chinese  ? tWord.chinese = chinese:chinese;
        pinyin   ? tWord.pinyin = pinyin:pinyin;
        property ? tWord.property = property:property;
        audio    ? tWord.audio = audio:audio;
        tAudio   ? tWord.tAudio = tAudio:tAudio;
        picture  ? tWord.picture = picture:picture;
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

// 词的翻译数据
+ (void)saveWordTranslationWithWordID:(NSString *)wID language:(NSString *)language chinese:(NSString *)chinese property:(NSString *)property completion:(void(^)(BOOL finished, id obj, NSError *error))completion
{
    WordTranslationModel *wordTran = [self queryWordTranslationWithWordID:wID language:language];
    
    BOOL needUpdate = [wordTran.wID isEqualToString:wID] && [wordTran.language isEqualToString:language];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        WordTranslationModel *tWordTran = needUpdate ? [wordTran inContext:localContext] : [WordTranslationModel createEntityInContext:localContext];
        wID  ? tWordTran.wID = wID:wID;
        language ? tWordTran.language = language:language;
        chinese ? tWordTran.chinese = chinese:chinese;
        property ? tWordTran.property = property:property;
        
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

#pragma mark - 保存词-关卡对应的数据
+ (void)parseCheckPointWordsLinkedByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        NSString *cpID = [[NSString alloc] initWithFormat:@"%@", [resultData objectForKey:@"Cpid"]];
        NSString *wIDs = [resultData objectForKey:@"Wid"];
        
        NSArray *arrWIDs = [wIDs componentsSeparatedByString:@","];
        
        NSInteger errorCode = success ? 0 : 1;
        NSString *domain = (message ? message : @"");
        //NSLog(@"errorCode: %d", errorCode);
        NSError *error = [NSError errorWithDomain:domain code:errorCode userInfo:nil];
        
        if (success)
        {
            [self parseCheckPointWordsLinkedRequestWIDs:arrWIDs checkPointID:cpID completion:completion];
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

NSInteger parseLinkCount;
NSInteger totalLinkCount;
+ (void)parseCheckPointWordsLinkedRequestWIDs:(id)WIDs checkPointID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion
{
    parseLinkCount = 0;
    totalLinkCount = [WIDs count];
    if ([WIDs isKindOfClass:[NSArray class]])
    {
        // 先删除所有的关系数据
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cpID == %@", cpID];
        [CheckPoint_WordModel deleteAllMatchingPredicate:predicate inContext:[NSManagedObjectContext rootSavingContext]];
        
        for (NSString *wID in WIDs)
        {
            [self saveCheckPoint_WordWithCheckPointID:cpID wordID:wID completion:^(BOOL finished, id obj, NSError *error) {
                parseLinkCount++;
                if (parseLinkCount >= totalLinkCount)
                {
                    if (completion) {
                        completion(YES, nil, error);
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

+ (void)saveCheckPoint_WordWithCheckPointID:(NSString *)cpID wordID:(NSString *)wID completion:(void(^)(BOOL finished, id obj, NSError *error))completion
{
    CheckPoint_WordModel *cpWord = [self queryCheckPoint_WordWithCheckPointID:cpID wordID:wID];
    
    BOOL needUpdate = [cpWord.cpID isEqualToString:cpID] && [cpWord.wID isEqualToString:wID];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        CheckPoint_WordModel *tCpWord = needUpdate ? [cpWord inContext:localContext] : [CheckPoint_WordModel createEntityInContext:localContext];
        cpID ? tCpWord.cpID = cpID:cpID;
        wID  ? tCpWord.wID = wID:wID;
        
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

#pragma mark - 保存例句、例句翻译的数据
+ (void)saveSentenceWithSentenceID:(NSString *)sID chinese:(NSString *)chinese pinyin:(NSString *)pinyin audio:(NSString *)audio tAudio:(NSString *)tAudio completion:(void(^)(BOOL finished, id obj, NSError *error))completion
{
    SentenceModel *sentence = [self querySentenceWithSentenceID:sID];
    
    BOOL needUpdate = [sentence.sID isEqualToString:sID];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        SentenceModel *tSentence = needUpdate ? [sentence inContext:localContext] : [SentenceModel createEntityInContext:localContext];
        sID      ? tSentence.sID = sID:sID;
        chinese  ? tSentence.chinese = chinese:chinese;
        pinyin   ? tSentence.pinyin = pinyin:pinyin;
        audio    ? tSentence.audio = audio:audio;
        tAudio   ? tSentence.tAudio = tAudio:tAudio;
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

// 词的翻译数据
+ (void)saveSentenceTranslationWithSentenceID:(NSString *)sID language:(NSString *)language chinese:(NSString *)chinese completion:(void(^)(BOOL finished, id obj, NSError *error))completion
{
    SentenceTranslationModel *senTran = [self querySentenceTranslationWithSentenceID:sID language:language];
    
    BOOL needUpdate = [senTran.sID isEqualToString:sID] && [senTran.language isEqualToString:language];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        SentenceTranslationModel *tSenTran = needUpdate ? [senTran inContext:localContext] : [SentenceTranslationModel createEntityInContext:localContext];
        sID  ? tSenTran.sID = sID:sID;
        language ? tSenTran.language = language:language;
        chinese ? tSenTran.chinese = chinese:chinese;
        
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

#pragma mark - 保存词-例句对应的数据
+ (void)saveWord_SentenceWithWordID:(NSString *)wID sentenceID:(NSString *)sID completion:(void(^)(BOOL finished, id obj, NSError *error))completion
{
    Word_SentenceModel *wSen = [self queryWord_SentenceWithWordID:wID sentenceID:sID];
    
    BOOL needUpdate = [wSen.sID isEqualToString:sID] && [wSen.wID isEqualToString:wID];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        Word_SentenceModel *tWSen = needUpdate ? [wSen inContext:localContext] : [Word_SentenceModel createEntityInContext:localContext];
        sID ? tWSen.sID = sID:sID;
        wID  ? tWSen.wID = wID:wID;
        
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

#pragma mark - 词数据的查询
+ (NSArray *)queryWordInfos
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSArray *arrWord = [WordModel findAllInContext:context];
    return arrWord;
}

+ (NSArray *)queryWordInfosWithCheckPointID:(NSString *)cpID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cpID == %@", cpID];
    NSArray *arrCpWord = [CheckPoint_WordModel findAllSortedBy:@"wID" ascending:YES withPredicate:predicate inContext:context];
    
    NSMutableArray *arrWords = [[NSMutableArray alloc] initWithCapacity:2];
    for (CheckPoint_WordModel *cpWord in arrCpWord)
    {
        WordModel *word = [WordDAL queryWordWithWordID:cpWord.wID];
        [arrWords addObject:word];
    }
    return arrWords;
}

+ (WordModel *)queryWordWithWordID:(NSString *)wID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wID == %@", wID];
    WordModel *word = (WordModel *)[WordModel findFirstWithPredicate:predicate inContext:context];
    return word;
}

+ (NSInteger)wordCountWithCheckPointID:(NSString *)cpID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cpID == %@", cpID];
    NSInteger count = [CheckPoint_WordModel countOfEntitiesWithPredicate:predicate inContext:context];
    return count;
}

#pragma mark - 词的音频数据的下载
+ (NSString *)getDownloadWordAudioDataURLParamsWithApKey:(NSString *)apKey email:(NSString *)email audio:(NSString *)audio productID:(NSString *)productID version:(NSString *)version
{
    return [URLUtility getURLFromParams:@{@"apkey": (apKey ? apKey : @""), @"email": (email ? email : @""), @"url": (audio ? audio : @""), @"version": (version ? version : @""), @"productID": (productID ? productID : @"")}];
}

// 解音频下载链接数据
+ (void)parseWordAudioDownloadByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
{
    NSError *error;
    if (resultData) {
        error = [NSError errorWithDomain:NSLocalizedString(@"获取信息成功!", @"") code:0 userInfo:nil];
    }else{
        error = [NSError errorWithDomain:NSLocalizedString(@"获取下载链接失败!", @"") code:1 userInfo:nil];
    }
    
    completion(YES, [resultData objectForKey:@"Url"], error);
}

#pragma mark - 词翻译的查询
+ (WordTranslationModel *)queryWordTranslationWithWordID:(NSString *)wID language:(NSString *)language
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wID == %@ AND language == %@", wID, language];
    WordTranslationModel *wordTran = (WordTranslationModel *)[WordTranslationModel findFirstWithPredicate:predicate inContext:context];
    return wordTran;
}

#pragma mark - 关卡-词对应关系的查询
+ (NSString *)getCheckPointWordsLinkedRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email checkPointID:(NSString *)cpID productID:(NSString *)productID
{
    return [URLUtility getURLFromParams:@{@"apkey": (apKey ? apKey : @""), @"email": (email ? email : @""), @"cpid": (cpID ? cpID : @""), @"productID": (productID ? productID : @"")}];
}

+ (CheckPoint_WordModel *)queryCheckPoint_WordWithCheckPointID:(NSString *)cpID wordID:(NSString *)wID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cpID == %@ AND wID == %@", cpID, wID];
    CheckPoint_WordModel *cpWord = (CheckPoint_WordModel *)[CheckPoint_WordModel findFirstWithPredicate:predicate inContext:context];
    return cpWord;
}

+ (NSArray *)queryCheckPoint_WordWithWordID:(NSString *)wID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wID == %@", wID];
    
    NSArray *arr = [CheckPoint_WordModel findAllWithPredicate:predicate inContext:context];
    
    return arr;
}

#pragma mark - 例句数据的查询
+ (SentenceModel *)querySentenceWithSentenceID:(NSString *)sID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sID == %@", sID];
    SentenceModel *sentence = (SentenceModel *)[SentenceModel findFirstWithPredicate:predicate inContext:context];
    return sentence;
}

+ (NSArray *)querySentencesWithWordID:(NSString *)wID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wID == %@", wID];
    NSArray *arrWdSentence = [Word_SentenceModel findAllWithPredicate:predicate inContext:context];
    
    NSMutableArray *arrSentence = [[NSMutableArray alloc] initWithCapacity:0];
    for (Word_SentenceModel *wdSentence in arrWdSentence)
    {
        SentenceModel *sentence = [WordDAL querySentenceWithSentenceID:wdSentence.sID];
        [arrSentence addObject:sentence];
    }
    
    return arrSentence;
}

#pragma mark - 例句翻译的查询
+ (SentenceTranslationModel *)querySentenceTranslationWithSentenceID:(NSString *)sID language:(NSString *)language
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sID == %@ AND language == %@", sID, language];
    SentenceTranslationModel *senTran = (SentenceTranslationModel *)[SentenceTranslationModel findFirstWithPredicate:predicate inContext:context];
    return senTran;
}

#pragma mark - 词-例句对应关系的查询
+ (Word_SentenceModel *)queryWord_SentenceWithWordID:(NSString *)wID sentenceID:(NSString *)sID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sID == %@ AND wID == %@", sID, wID];
    Word_SentenceModel *model = (Word_SentenceModel *)[Word_SentenceModel findFirstWithPredicate:predicate inContext:context];
    return model;
}

+ (NSArray *)queryWord_SentenceWithWordID:(NSString *)wID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"wID == %@", wID];
    NSArray *models = [Word_SentenceModel findAllSortedBy:@"sID" ascending:YES withPredicate:predicate inContext:context];
    return models;
}

+ (NSArray *)querySentence_WordWithSentenceID:(NSString *)sID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sID == %@", sID];
    NSArray *models = [Word_SentenceModel findAllSortedBy:@"sID" ascending:YES withPredicate:predicate inContext:context];
    return models;
}

+ (NSArray *)querySentence_CheckPointWithSentenceID:(NSString *)sID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sID == %@", sID];
    NSArray *arrWSentence = [Word_SentenceModel findAllSortedBy:@"wID" ascending:YES withPredicate:predicate inContext:context];
    
    NSMutableArray *arrCWModel = [[NSMutableArray alloc] initWithCapacity:2];
    for (Word_SentenceModel *wSentence in arrWSentence)
    {
        NSPredicate *predicateA = [NSPredicate predicateWithFormat:@"wID == %@", wSentence.wID];
        NSArray *arrCpWord = [CheckPoint_WordModel findAllSortedBy:@"cpID" ascending:YES withPredicate:predicateA inContext:context];
        
        [arrCWModel addObjectsFromArray:arrCpWord];
    }
    return arrCWModel;
}

#pragma mark - fetch 方式查询
+ (id)fetchAllWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate checkPointID:(NSString *)cpID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cpID == %@", cpID];
    
    NSArray *arrCpWord = [CheckPoint_WordModel findAllWithPredicate:predicate inContext:context];
    
    NSMutableArray *arrWid = [[NSMutableArray alloc] initWithCapacity:2];
    for (CheckPoint_WordModel *cpWord in arrCpWord){
        [arrWid addObject:cpWord.wID];
    }
    NSPredicate *predicated = [NSPredicate predicateWithFormat:@"wID IN %@", arrWid];
    id result = [WordModel fetchAllSortedBy:@"wID" ascending:YES withPredicate:predicated groupBy:nil delegate:delegate inContext:context];
    
    return result;
    
}

#pragma mark - 词的学习记录数据
+ (NSString *)getWordLearnedRecordsRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email checkPointID:(NSString *)cpID bookID:(NSString *)bID categoryID:(NSString *)cID records:(NSString *)records language:(NSString *)language productID:(NSString *)productID
{
    return [URLUtility getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:apKey, email, cpID, bID, cID, records, language, productID, nil] forKeys:[NSArray arrayWithObjects:@"apkey", @"email", @"cpid", @"bid", @"bcid", @"records", @"language", @"productID", nil]]];
}

+ (void)parseWordLearnedRecordsByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
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
            [self parseWordLearnedRecordsRequestResult:results userID:uID completion:completion];
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

+ (void)parseWordLearnedRecordsRequestResult:(id)resultData userID:(NSString *)uID completion:(void (^)(BOOL, id, NSError *))completion
{
    
    if ([resultData isKindOfClass:[NSArray class]])
    {
        parseWordLearnedRecordsCompletion = completion;
        parseWordLearnCount = 0;
        totalWordLearnCount = [resultData count];
        for (NSDictionary *dicRecord in resultData)
        {
            NSString *cpID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Cpid"]];
            NSString *wID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Wid"]];
            NSInteger rights = [[dicRecord objectForKey:@"Rights"] integerValue];
            NSInteger wrongs = [[dicRecord objectForKey:@"Wrongs"] integerValue];
            NSInteger status = [[dicRecord objectForKey:@"Status"] integerValue];
            
            [self saveWordLearnedRecordsWithUserID:uID checkPointID:cpID wordID:wID rights:rights wrongs:wrongs status:status sync:1 completion:^(BOOL finished, id obj, NSError *error) {
                parseWordLearnCount++;
                if (parseWordLearnCount >= totalWordLearnCount)
                {
                    if (parseWordLearnedRecordsCompletion) {
                        parseWordLearnedRecordsCompletion(YES, nil, error);
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

#pragma mark - 保存词练习记录的数据
+ (void)saveWordLearnedRecordsWithUserID:(NSString *)uID checkPointID:(NSString *)cpID wordID:(NSString *)wID rights:(NSInteger)rights wrongs:(NSInteger)wrongs status:(NSInteger)status sync:(NSInteger)sync completion:(void(^)(BOOL finished, id obj, NSError *error))completion
{
    WordLearnInfoModel *wordLearned = [self queryWordLearnedRecordInfoWithUserID:uID checkPointID:cpID WordID:wID];
    
    BOOL needUpdate = [wordLearned.uID isEqualToString:uID] && [wordLearned.cpID isEqualToString:cpID] && [wordLearned.wID isEqualToString:wID];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        WordLearnInfoModel *tWordLearned = needUpdate ? [wordLearned inContext:localContext] : [WordLearnInfoModel createEntityInContext:localContext];
        wID  ? tWordLearned.wID = wID:wID;
        uID  ? tWordLearned.uID = uID:uID;
        cpID   ? tWordLearned.cpID = cpID:cpID;
        rights > tWordLearned.rightsValue ?  tWordLearned.rightsValue = rights : rights;
        wrongs > tWordLearned.wrongsValue ? tWordLearned.wrongsValue = wrongs : wrongs;
        // 未归档的进行保存, 已归档的不做处理.
        !status ? tWordLearned.statusValue = status : status;
        tWordLearned.syncValue = sync;
    }completion:^(BOOL success, NSError *error) {
        //DLog(@"update: %d error: %@", needUpdate, error);
        if (completion) {
            completion(success, nil, error);
        }
    }];
}

+ (WordLearnInfoModel *)queryWordLearnedRecordInfoWithUserID:(NSString *)uID checkPointID:(NSString *)cpID WordID:(NSString *)wID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND cpID == %@ AND wID == %@", uID, cpID, wID];
    WordLearnInfoModel *model = (WordLearnInfoModel *)[WordLearnInfoModel findFirstWithPredicate:predicate inContext:context];
    return model;
}

+ (NSInteger)countOfFiledWordLearnedRecordWithUserID:(NSString *)uID bookID:(NSString *)bID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bID == %@", bID];
    NSArray *arrCp = [CheckPointModel findAllWithPredicate:predicate inContext:context];
    
    NSInteger count = 0;
    for (CheckPointModel *checkPoint in arrCp)
    {
        @autoreleasepool
        {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND cpID == %@ AND status == 1", uID, checkPoint.cpID];
            
            count += [WordLearnInfoModel countOfEntitiesWithPredicate:predicate inContext:context];
        }
    }
    return count;
}

+ (NSInteger)countOfMasteredWordLearnedRecordWithUserID:(NSString *)uID bookID:(NSString *)bID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bID == %@", bID];
    NSArray *arrCp = [CheckPointModel findAllWithPredicate:predicate inContext:context];
    
    NSInteger count = 0;
    for (CheckPointModel *checkPoint in arrCp)
    {
        @autoreleasepool
        {
            //&& (status == 1 || (((rights+wrongs) > 0) && (rights/(rights+wrongs)) >= 0.8))
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"uID == %@ && cpID == %@", uID, checkPoint.cpID];
            NSArray *arrWordLearn = [WordLearnInfoModel findAllWithPredicate:predicate inContext:context];
            for (WordLearnInfoModel *wordLearn in arrWordLearn)
            {
                count += (wordLearn.statusValue == WordLearnFileStatusFiled || (((wordLearn.rightsValue + wordLearn.wrongsValue) > 0) && (float)wordLearn.rightsValue/(float)(wordLearn.rightsValue+wordLearn.wrongsValue) > 0.8f)) ? 1 : 0;
            }
        }
    }
    return count;
}

+ (NSArray *)queryWordLearnRecordInfosWithUserID:(NSString *)uID checkPointID:(NSString *)cpID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND cpID == %@", uID, cpID];
    NSArray *models = [WordLearnInfoModel findAllWithPredicate:predicate inContext:context];
    return models;
}

+ (void)loadWordCheckRecordInfoWithUserID:(NSString *)uID checkPointID:(NSString *)cpID WordID:(NSString *)wID completion:(void (^)(BOOL success, id obj, NSError *error))completion
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND cpID == %@ AND wID == %@", uID, cpID, wID];
    WordLearnInfoModel *wordLearned = (WordLearnInfoModel *)[WordLearnInfoModel findFirstWithPredicate:predicate];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        WordLearnInfoModel *tWordLearned = wordLearned ? [wordLearned inContext:localContext] : [WordLearnInfoModel createEntityInContext:localContext];
        wID  ? tWordLearned.wID = wID:wID;
        uID  ? tWordLearned.uID = uID:uID;
        cpID ? tWordLearned.cpID = cpID:cpID;
    }completion:^(BOOL success, NSError *error) {
        if (completion)
        {
            [NSManagedObjectContext clearNonMainThreadContextsCache];
            //NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND cpID == %@ AND wID == %@", uID, cpID, wID];
            WordLearnInfoModel *wordRecord = (WordLearnInfoModel *)[WordLearnInfoModel findFirstWithPredicate:predicate];
            completion(success, wordRecord, error);
        }
    }];
}

#pragma mark - 生词本的数据
NSInteger parseWordReviewCount;
NSInteger totalWordReviewCount;

+ (NSString *)getWordReviewRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email bookID:(NSString *)bID records:(NSString *)records language:(NSString *)language productID:(NSString *)productID
{
    return [URLUtility getURLFromParams:@{@"apkey": (apKey ? apKey : @""), @"email": (email ? email : @""), @"bid": (bID ? bID : @""), @"records": (records ? records : @""), @"language": (language ? language : @""), @"productID": (productID ? productID : @"")}];
}

+ (void)parseWordReviewByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion
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
            [self parseWordReviewRequestResult:results userID:uID completion:completion];
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

+ (void)parseWordReviewRequestResult:(id)resultData userID:(NSString *)uID completion:(void (^)(BOOL, id, NSError *))completion
{
    
    if ([resultData isKindOfClass:[NSArray class]])
    {
        parseWordReviewCount = 0;
        totalWordReviewCount = [resultData count];

        for (NSDictionary *dicRecord in resultData)
        {
            NSString *wID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Wid"]];
            NSInteger created = [[dicRecord objectForKey:@"Created"] integerValue];
            NSString *cpID = [[NSString alloc] initWithFormat:@"%@", [dicRecord objectForKey:@"Cpid"]];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND cpID == %@", uID, cpID];
            [WordReviewModel deleteAllMatchingPredicate:predicate inContext:[NSManagedObjectContext rootSavingContext]];
            
            [self saveWordReviewWithUserID:uID cpID:cpID wordID:wID created:created status:1 completion:^(BOOL success, id obj, NSError *error) {
                parseWordReviewCount++;
                if (parseWordReviewCount >= totalWordReviewCount)
                {
                    if (completion) {
                        completion(YES, nil, error);
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

+ (void)saveWordReviewWithUserID:(NSString *)uID cpID:(NSString *)cpID wordID:(NSString *)wID created:(NSInteger)created status:(NewWordStatus)status completion:(void (^)(BOOL, id, NSError *))completion
{
    WordReviewModel *wordReview = [self queryWordReviewInfoWithUserID:uID WordID:wID];
    
    BOOL needUpdate = [wordReview.uID isEqualToString:uID] && [wordReview.wID isEqualToString:wID];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        WordReviewModel *tWordReview = needUpdate ? [wordReview inContext:localContext] : [WordReviewModel createEntityInContext:localContext];
        wID  ? tWordReview.wID = wID:wID;
        uID  ? tWordReview.uID = uID:uID;
        cpID ? tWordReview.cpID = cpID:cpID;
        tWordReview.statusValue = status;
        created > tWordReview.createdValue ? tWordReview.createdValue = created : created;
    }completion:^(BOOL success, NSError *error) {
        if (completion) {
            completion(success, wordReview, error);
        }
    }];
}

+ (WordReviewModel *)queryWordReviewInfoWithUserID:(NSString *)uID WordID:(NSString *)wID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND wID == %@ AND (status IN {0, 1})", uID, wID];
    WordReviewModel *model = (WordReviewModel *)[WordReviewModel findFirstWithPredicate:predicate inContext:context];
    return model;
}

+ (BOOL)existNewWordWithUserID:(NSString *)uID WordID:(NSString *)wID
{
    WordReviewModel *model = (WordReviewModel *)[self queryWordReviewInfoWithUserID:uID WordID:wID];
    BOOL exist = model ? YES : NO;
    return exist;
}

+ (NSArray *)queryAllNewWordsInfosWithUserID:(NSString *)uID bookID:(NSString *)bID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bID == %@", bID];
    
    NSArray *arrCp = [CheckPointModel findAllWithPredicate:predicate inContext:context];
    
    NSMutableArray *arrWord = [[NSMutableArray alloc] initWithCapacity:2];
    for (CheckPointModel *checkPoint in arrCp)
    {
        @autoreleasepool
        {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND cpID == %@", uID, checkPoint.cpID];
            
            NSArray *arrNew = [WordReviewModel findAllWithPredicate:predicate inContext:context];
            [arrWord addObjectsFromArray:arrNew];
        }
    }
    return arrWord;
}

+ (NSArray *)queryNewWordsShowInfosWithUserID:(NSString *)uID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND (status IN {0, 1})", uID];
    NSArray *arrNew = [WordReviewModel findAllSortedBy:@"wID" ascending:YES withPredicate:predicate inContext:context];
    
    NSMutableArray *arrWord = [[NSMutableArray alloc] initWithCapacity:2];
    for (WordReviewModel *wordReview in arrNew)
    {
        WordModel *word = [self queryWordWithWordID:wordReview.wID];
        [arrWord addObject:word];
    }
    return arrWord;
}

+ (NSInteger)newWordCountWithUserID:(NSString *)uID checkPointID:(NSString *)cpID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND cpID == %@ AND (status IN {0, 1})", uID, cpID];
    NSInteger count = [WordReviewModel countOfEntitiesWithPredicate:predicate inContext:context];
    return count;
}

#pragma mark - fetch 方式查询
+ (id)fetchNewWordsShowWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate UserID:(NSString *)uID
{
    [NSManagedObjectContext clearNonMainThreadContextsCache];
    NSManagedObjectContext *context = [NSManagedObjectContext contextForCurrentThread];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND (status IN {0, 1})", uID];
    
    id result = [WordReviewModel fetchAllSortedBy:@"status" ascending:YES withPredicate:predicate groupBy:nil delegate:delegate inContext:context];
    return result;
}

+ (id)fetchNewWordsShowWithUserID:(NSString *)uID fetchOffset:(NSInteger)fetchOffset fetchLimit:(NSInteger)fetchLimit
{
    
    NSManagedObjectContext *context =[NSManagedObjectContext contextForCurrentThread];
    //自定义fetch查询
    NSFetchRequest *request = [WordReviewModel createFetchRequestInContext:context];
    
    //使用谓词指定查询条件。
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uID == %@ AND (status IN {0, 1})", uID];
    
    [request setPredicate:predicate];
    [request setReturnsObjectsAsFaults:NO];
    
    //指定查询偏移量
    request.fetchOffset = fetchOffset;
    request.fetchLimit = fetchLimit;
    NSArray *fetchResult = [WordReviewModel executeFetchRequest:request inContext:context];
    
    return fetchResult;
}

@end
