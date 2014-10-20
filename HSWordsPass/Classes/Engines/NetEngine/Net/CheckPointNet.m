//
//  CheckPointNet.m
//  HSWordsPass
//
//  Created by yang on 14-9-5.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "CheckPointNet.h"
#import "CheckPointDAL.h"
#import "HttpClient.h"
#import "SystemInfoHelper.h"
#import "OpenUDID.h"
#import "MD5Helper.h"
#import "FileHelper.h"
#import "ZipArchive.h"

#import "ASINetworkQueue.h"

@interface CheckPointNet ()<ASIHTTPRequestDelegate>
{
    NSString *unzipPath;
    BOOL isDownloading;
    HttpClient *requestClient;
    
    ASINetworkQueue *networdQueue;
}

@end

@implementation CheckPointNet
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
- (void)startCheckPointRequestWithUserEmail:(NSString *)email bookID:(NSString *)bookID completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    NSString *apKey = [MD5Helper md5Digest:md5];
    
    NSString *params = [CheckPointDAL getCheckPointRequestURLParamsWithApKey:apKey email:email bookID:bookID language:currentLanguage() productID:productID()];
    
    [self initRequestClient];
    [requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kCheckPointList] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"关卡数据 jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [CheckPointDAL parseCheckPointByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

// 同步关卡进度
- (void)startSynchronousCheckPointProgressWithEmail:(NSString *)email bookID:(NSString *)bID records:(NSString *)records completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    NSString *apKey = [MD5Helper md5Digest:md5];
    
    NSString *params = [CheckPointDAL getCheckPointProgressRequestURLParamsWithApKey:apKey email:email bookID:bID records:records language:currentLanguage() productID:productID()];
    
    [self initRequestClient];
    [requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kProgressUpdate] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            DLog(@"关卡进度： jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [CheckPointDAL parseCheckPointProgressByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)getCheckPointVersionWithEmail:(NSString *)email cpID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    NSString *apKey = [MD5Helper md5Digest:md5];
    
    NSString *params = [CheckPointDAL getCheckPointVersionRequestURLParamsWithApKey:apKey email:email checkPointID:cpID productID:productID()];
    
    [self initRequestClient];
    [requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kCheckPointVersion] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
        }
        
        if (jsonData) {
            [CheckPointDAL parseCheckPointVersionByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)getCheckPointDataDonwloadInfoWithEmail:(NSString *)email bookID:(NSString *)bID checkPointID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion
{
    NSString *md5 = [[NSString alloc] initWithFormat:@"%@%@%@", email, productID(), kMD5_KEY];
    NSString *apKey = [MD5Helper md5Digest:md5];
    NSString *params = [CheckPointDAL getDownloadCheckPointDataURLParamsWithApKey:apKey email:email bookID:bID checkPointID:cpID productID:productID() version:kSoftwareVersion];
    
    [self initRequestClient];
    
    [requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kDownloadFile] params:params completion:^(BOOL finished, NSData *responseData, NSString *responseString, NSError *error) {
        
        //DLog(@"error: %@", error.localizedDescription);
        id jsonData = nil;
        if (responseData && error.code == 0) {
            jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
            //DLog(@"下载数据： jsonData: %@", jsonData);
        }
        
        if (jsonData) {
            [CheckPointDAL parseCheckPointDownloadByData:jsonData completion:completion];
        }
        else
        {
            if (completion){
                completion(NO, nil, error);
            }
        }
    }];
}

- (void)downloadCheckPointDataWithEmail:(NSString *)email bookID:(NSString *)bID checkPointID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion
{
    __block void (^downloadCompletion)(BOOL finished, id result, NSError *error) = completion;
    [self getCheckPointDataDonwloadInfoWithEmail:email bookID:bID checkPointID:cpID completion:^(BOOL finished, id result, NSError *error) {
        
        if (finished && result)
        {
            if(![[FileHelper sharedInstance] isExistPath:kDownloadingPath])
            {
                if(![[FileHelper sharedInstance] createDirectory:kDownloadingPath])
                {
                    DLog(@"创建课程临时文件夹失败!");
                    NSError *error = [NSError errorWithDomain:NSLocalizedString(@"创建课程临时文件夹失败!", @"") code:1 userInfo:nil];
                    if (downloadCompletion) {
                        downloadCompletion(NO, nil, error);
                    }
                }
            }
            
            if(![[FileHelper sharedInstance] isExistPath:kDownloadedPath])
            {
                if(![[FileHelper sharedInstance] createDirectory:kDownloadedPath])
                {
                    DLog(@"创建课程文件夹失败!");
                    NSError *error = [NSError errorWithDomain:NSLocalizedString(@"创建课程文件夹失败!", @"") code:1 userInfo:nil];
                    if (downloadCompletion) {
                        downloadCompletion(NO, nil, error);
                    }
                }
            }
            
            NSString *dataPath    = [NSString stringWithFormat:@"%@.zip", cpID];
            NSString *dataTmpPath = [NSString stringWithFormat:@"%@.temp", cpID];
            NSString *destionPath =[kDownloadedPath stringByAppendingPathComponent:dataPath];
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
            __weak CheckPointNet *weakSelf = self;
            [request setCompletionBlock:^{
                DLog(@"response statu: %d", _requestCopy.responseStatusCode);
                NSError *error;
                // 解压文件
                [weakSelf unzipFileWithCheckPointID:cpID error:&error];
                if (downloadCompletion) {
                    downloadCompletion(YES, nil, error);
                }
            }];
            
            [request setFailedBlock:^{
                DLog(@"failed: %@; %@", _requestCopy.responseStatusMessage, _requestCopy.responseString);
                NSError *error = [NSError errorWithDomain:_requestCopy.error.localizedDescription code:_requestCopy.error.code userInfo:nil];
                if (downloadCompletion) {
                    downloadCompletion(YES, nil, error);
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
}

#pragma mark - Progress
- (void)setProgress:(float)aProgress
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(downloadProgress:)])
    {
        [self.delegate downloadProgress:aProgress];
    }
}

#pragma mark - Zip Method
- (void)unzipFileWithCheckPointID:(NSString *)cpID error:(NSError **)error
{
    //解压
    NSString *dataPath    = [NSString stringWithFormat:@"%@.zip", cpID];
    NSString *destionPath   =[kDownloadedPath stringByAppendingPathComponent:dataPath];
    
    NSString *dataDPath = [NSString stringWithFormat:@"%@", cpID];
    
    unzipPath = [kDownloadedPath stringByAppendingPathComponent:dataDPath];
    ZipArchive *unzip = [[ZipArchive alloc] init];
    if ([unzip UnzipOpenFile:destionPath])
    {
        BOOL result = [unzip UnzipFileTo:unzipPath overWrite:YES];
        
        if (result)
        {
            DLog(@"解压成功！");
            if (error) *error = [NSError errorWithDomain:NSLocalizedString(@"成功解压资源文件!", @"") code:0 userInfo:nil];
            [self deleteDownloadFileWithCheckPointID:cpID];
        }
        else
        {
            DLog(@"解压资源文件失败!");
            if (error) *error = [NSError errorWithDomain:NSLocalizedString(@"解压资源文件失败!", @"") code:1 userInfo:nil];
        }
        [unzip UnzipCloseFile];
    }
    else
    {
        DLog(@"打开待解压文件失败!");
        if (error) *error = [NSError errorWithDomain:NSLocalizedString(@"打开待解压文件失败!", @"") code:2 userInfo:nil];
    }
}

- (void)deleteDownloadFileWithCheckPointID:(NSString *)cpID
{
    NSString *dataPath    = [NSString stringWithFormat:@"%@.zip", cpID];
    NSString *dataTmpPath = [NSString stringWithFormat:@"%@.temp", cpID];
    NSString *destionPath   =[kDownloadedPath stringByAppendingPathComponent:dataPath];
    NSString *tmpPath       = [kDownloadingPath stringByAppendingPathComponent:dataTmpPath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:destionPath])
    {
        if ([[NSFileManager defaultManager] removeItemAtPath:destionPath error:nil])
        {
            DLog(@"删除压缩文件成功!");
        }
        else
        {
            DLog(@"删除压缩文件失败");
        }
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:tmpPath])
    {
        if ([[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil])
        {
            DLog(@"删除临时文件成功!");
        }
        else
        {
            DLog(@"删除临时文件失败");
        }
    }
}

#pragma mark - Cancel
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
