//
//  WordListNet.m
//  HSWordsPass
//
//  Created by yang on 14-9-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "WordNet.h"
#import "WordDAL.h"
#import "HttpClient.h"
#import "SystemInfoHelper.h"
#import "OpenUDID.h"
#import "MD5Helper.h"
#import "FileHelper.h"

#import "ZipArchive.h"

#import "ASINetworkQueue.h"

@interface WordNet ()
{
    HttpClient *requestClient;
    
    ASINetworkQueue *networdQueue;
    
    BOOL isDownloading;
}

@end

@implementation WordNet

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
    [self cancelDownload];
    [self cancelRequest];
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

- (ASINetworkQueue *)downloadQueue
{
    if (!networdQueue)
    {
        networdQueue = [[ASINetworkQueue alloc] init];
        [networdQueue reset];
        //下载队列代理方法
        [networdQueue setQueueDidFinishSelector:@selector(downLoadFinished)];
        [networdQueue setDelegate:self];
        [networdQueue setShouldCancelAllRequestsOnFailure:NO];
        [networdQueue setMaxConcurrentOperationCount:1];
    }
    return networdQueue;
}

- (void)downLoadFinished
{
    isDownloading = NO;
    DLOG_CMETHOD;
}

#pragma mark - Request
- (void)startCheckPointWordsLinkedRequestWithEmail:(NSString *)email checkPointID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    NSString *apKey = [MD5Helper md5Digest:md5];
    
    NSString *params = [WordDAL getCheckPointWordsLinkedRequestURLParamsWithApKey:apKey email:email checkPointID:cpID productID:productID()];
    
    [self initRequestClient];
    [requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kCheckPointWords] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"关卡词对应数据 jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [WordDAL parseCheckPointWordsLinkedByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)startWordRequestWithUserEmail:(NSString *)email checkPointID:(NSString *)cpID wordID:(NSString *)wID completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    NSString *apKey = [MD5Helper md5Digest:md5];
    
    NSString *params = [WordDAL getWordRequestURLParamsWithApKey:apKey email:email checkPointID:cpID wordID:wID language:currentLanguage() productID:productID()];
    
    [self initRequestClient];
    [requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kWordList] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"词汇: jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [WordDAL parseWordByData:jsonData checkPointID:cpID completion:completion];
        }
        else
        {
            //DLog(@"error: %@", error.localizedDescription);
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)startWordSentenceRequestWithUserEmail:(NSString *)email checkPointID:(NSString *)cpID wordID:(NSString *)wID completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    NSString *apKey = [MD5Helper md5Digest:md5];
    
    NSString *params = [WordDAL getWordSentenceRequestURLParamsWithApKey:apKey email:email wordID:wID language:currentLanguage() productID:productID()];
    
    [self initRequestClient];
    [requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kWordSentence] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"词汇例句: jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [WordDAL parseWordSentenceByData:jsonData checkPointID:cpID wordID:wID completion:completion];
        }
        else
        {
            //DLog(@"error: %@", error.localizedDescription);
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)startWordLearnedRecordsRequestWithUserEmail:(NSString *)email checkPointID:(NSString *)cpID bookID:(NSString *)bID categoryID:(NSString *)cID records:(NSString *)records completion:(void (^)(BOOL finished, id result, NSError *error))completion
{
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    NSString *apKey = [MD5Helper md5Digest:md5];
    
    NSString *params = [WordDAL getWordLearnedRecordsRequestURLParamsWithApKey:apKey email:email checkPointID:cpID bookID:bID categoryID:cID records:records language:currentLanguage() productID:productID()];
    
    [self initRequestClient];
    [requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kPracticeRecord] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"做题同步：jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [WordDAL parseWordLearnedRecordsByData:jsonData completion:completion];
        }
        else
        {
            //DLog(@"error: %@", error.localizedDescription);
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)startSynchronousWordReviewWithUserEmail:(NSString *)email bookID:(NSString *)bID records:(NSString *)records completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    NSString *apKey = [MD5Helper md5Digest:md5];
    
    NSString *params = [WordDAL getWordReviewRequestURLParamsWithApKey:apKey email:email bookID:bID records:records language:currentLanguage() productID:productID()];
    
    [self initRequestClient];
    [requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kWordNoteUpdate] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            DLog(@"生词 jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [WordDAL parseWordReviewByData:jsonData completion:completion];
        }
        else
        {
            //DLog(@"error: %@", error.localizedDescription);
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

#pragma mark - 下载音频数据
- (void)getWordAudioDataDonwloadInfoWithEmail:(NSString *)email audio:(NSString *)audio completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    NSString *apKey = [MD5Helper md5Digest:md5];
    NSString *params = [WordDAL getDownloadWordAudioDataURLParamsWithApKey:apKey email:email audio:audio productID:productID() version:kSoftwareVersion];
    
    [self initRequestClient];
    
    [requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kDownloadFile] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"下载数据： jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [WordDAL parseWordAudioDownloadByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)downloadWordAudioDataWithEmail:(NSString *)email checkPointID:(NSString *)cpID audio:(NSString *)audio completion:(void (^)(BOOL, id, NSError *))completion
{
    __block void (^downloadCompletion)(BOOL finished, id result, NSError *error) = completion;
    [self getWordAudioDataDonwloadInfoWithEmail:email audio:audio completion:^(BOOL finished, id result, NSError *error) {
        
        if (finished && result)
        {
            if(![[FileHelper sharedInstance] isExistPath:kDownloadingPath])
            {
                if(![[FileHelper sharedInstance] createDirectory:kDownloadingPath])
                {
                    DLog(@"创建临时音频文件夹失败!");
                    NSError *error = [NSError errorWithDomain:NSLocalizedString(@"创建临时音频文件夹失败!", @"") code:1 userInfo:nil];
                    if (downloadCompletion) {
                        downloadCompletion(NO, nil, error);
                    }
                }
            }
            
            if(![[FileHelper sharedInstance] isExistPath:kDownloadedPath])
            {
                if(![[FileHelper sharedInstance] createDirectory:kDownloadedPath])
                {
                    DLog(@"创建音频文件夹失败!");
                    NSError *error = [NSError errorWithDomain:NSLocalizedString(@"创建音频文件夹失败!", @"") code:1 userInfo:nil];
                    if (downloadCompletion) {
                        downloadCompletion(NO, nil, error);
                    }
                }
            }
            
            NSMutableArray *arrPath = (NSMutableArray *)[audio componentsSeparatedByString:@"/"];
            NSString *strName = [arrPath lastObject];
            [arrPath removeLastObject];
            NSString *strDir = [arrPath componentsJoinedByString:@"/"];
            
            NSString *exaDir = [NSString stringWithFormat:@"%@/%@/%@", kDownloadedPath, cpID, strDir];
            
            NSString *tempAudio = [kDownloadedPath stringByAppendingPathComponent:strName];
            BOOL tempExists = [[NSFileManager defaultManager] fileExistsAtPath:tempAudio isDirectory:nil];
            
            NSString *destionPath;
            BOOL dirExists = [[NSFileManager defaultManager] fileExistsAtPath:exaDir isDirectory:nil];
            
            NSString *destPath = [NSString stringWithFormat:@"%@/%@", exaDir, strName];
            
            // 1、如果目标文件夹存在且临时音频文件存在，那么移动音频过去即可。
            if (dirExists && tempExists)
            {
                [[NSFileManager defaultManager] moveItemAtPath:tempAudio toPath:destPath error:nil];
                
                if (completion) {
                    completion(YES, destPath, error);
                }
                return ;
            }
            // 2、如果目标文件夹存在但是临时音频文件不存在，那么下载到目标文件夹即可。
            else if (dirExists && !tempExists)
            {
                destionPath = destPath;
            }
            // 3、如果目标文件夹不存在临时音频也不存在，那么下载到临时目录即可。
            else if (!dirExists && !tempExists)
            {
                destionPath = tempAudio;
            }
            // 4、如果目标文件夹不存在但是临时音频存在，那么不再下载。
            else
            {
                if (completion) {
                    completion(YES, tempAudio, error);
                }
                return ;
            }
    
            DLog(@"继续下载");
            NSString *dataTmpPath = [NSString stringWithFormat:@"%@", strName];
            NSString *tmpPath     = [kDownloadingPath stringByAppendingPathComponent:dataTmpPath];
            
            NSString *dataURL = (NSString *)result;
            NSURL *url = [NSURL URLWithString:dataURL];
            //NSLog(@"下载的url: %@", url);
            //创建请求
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            //request.delegate = self;//代理
            [request setUserInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%@", cpID] forKey:@"ID"]];
            [request setNumberOfTimesToRetryOnTimeout:3];//超时重传3次。
            [request setShouldContinueWhenAppEntersBackground:YES];//进入background后继续下载
            [request setAllowResumeForFileDownloads:YES];//断点续传
            [request setDownloadDestinationPath:destionPath];//下载路径
            [request setTemporaryFileDownloadPath:tmpPath];//缓存路径
            request.downloadProgressDelegate = self;//下载进度代理
            request.showAccurateProgress = YES;
            
            __block ASIHTTPRequest *_requestCopy = request;
            //__weak WordNet *weakSelf = self;
            [request setCompletionBlock:^{
                DLog(@"response statu: %d", _requestCopy.responseStatusCode);
                NSError *error;
                if (downloadCompletion) {
                    downloadCompletion(YES, destionPath, error);
                }
            }];
            
            [request setFailedBlock:^{
                DLog(@"failed: %@; %@", _requestCopy.responseStatusMessage, _requestCopy.responseString);
                NSError *error = [NSError errorWithDomain:_requestCopy.error.localizedDescription code:_requestCopy.error.code userInfo:nil];
                if (downloadCompletion) {
                    downloadCompletion(NO, destionPath, error);
                }
            }];
            
            [[self downloadQueue] addOperation:request];//添加到队列，队列启动后不需重新启动
            
            if ([self downloadQueue].isSuspended) {
                DLog(@"suspend");
                // 只需调用一次go函数
                [[self downloadQueue] go];
            }
        }// if end
        else
        {
            NSError *error = [NSError errorWithDomain:NSLocalizedString(@"获取下载链接失败!", @"") code:-1 userInfo:nil];
            if (downloadCompletion) {
                downloadCompletion(NO, nil, error);
            }
        }
    }];
    
    DLog(@"到最后");
}

#pragma mark - cancel
- (void)cancelRequest
{
    [requestClient cancelAllRequest];
}

- (void)cancelDownload
{
    if (isDownloading){
        isDownloading = NO;
    }
    
    if (networdQueue){
        [networdQueue cancelAllOperations];
    }
}

- (BOOL)isRequestCanceled
{
    return ([requestClient isRequestAllCanceled]);
}

- (BOOL)isDownloadCanceled
{
    return ([networdQueue operationCount] <= 0);
}

@end
