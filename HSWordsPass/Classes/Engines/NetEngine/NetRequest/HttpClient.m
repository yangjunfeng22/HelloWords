//
//  HttpClient.m
//  PinyinGame
//
//  Created by yang on 13-11-16.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "HttpClient.h"
#import "ASINetworkQueue.h"

//typedef void (^RequestBlock)(BOOL finished, NSData *responseData, NSString *responseString, NSError *error);
void (^requestCompletion)(BOOL finished, NSData *responseData, NSString *responseString, NSError *error);

@interface HttpClient ()
{
    BOOL _isFinished;
    
    ASINetworkQueue *networdQueue;
    ASIFormDataRequest *currentRequest;
    //RequestBlock requestCompletion;
}

- (id)requestFromURL:(NSString *)url params:(NSString *)params method:(NSString *)method error:(NSError **)error;

- (void)requestFromURL:(NSString *)url params:(NSString *)params method:(NSString *)method completion:(void (^)(BOOL finished, NSData *responseData, NSString *responseString, NSError *error))completion;

@end

@implementation HttpClient
@synthesize isRequestCanceled = _isRequestCanceled;

- (id)getRequestFromURL:(NSString *)url params:(NSString *)params error:(NSError **)error
{
    return [self requestFromURL:url params:params method:@"GET" error:error];
}

- (id)postRequestFromURL:(NSString *)url params:(NSString *)params error:(NSError **)error
{
    return [self requestFromURL:url params:params method:@"POST" error:error];
}

- (id)requestFromURL:(NSString *)url params:(NSString *)params method:(NSString *)method error:(NSError **)error
{
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //NSLog(@"%@: 请求的url: %@; 数据: %@", NSStringFromSelector(_cmd), url, params);
    if ([method isEqualToString:@"GET"])
    {
        // GET 请求的url为 url?params。
        url = [[url stringByAppendingString:@"?"] stringByAppendingString:params];
        currentRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    }
    else
    {
        currentRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        NSArray *arrParams = [params componentsSeparatedByString:@"&"];
        
        for (NSString *strParam in arrParams)
        {
            NSArray *arrParam = [strParam componentsSeparatedByString:@"="];
            NSString *key = [arrParam objectAtIndex:0];
            NSString *value = [arrParam objectAtIndex:1];
            
            [currentRequest addPostValue:value forKey:key];
        }
    }
    currentRequest.defaultResponseEncoding = NSUTF8StringEncoding;
    // 超时时间60秒
    currentRequest.timeOutSeconds = 60.0f;
    // 请求类型
    currentRequest.requestMethod = method;
    // 同步请求
    [currentRequest startSynchronous];

    //NSLog(@"返回的数据: %@", currentRequest.responseString);
    // 服务器在维护时的信息: message: HTTP/1.1 503 Service Temporarily Unavailable; statu: 503
    //NSLog(@"message: %@; statu: %d", currentRequest.responseStatusMessage, currentRequest.responseStatusCode);
    
    // 记录错误信息
    // 206为重定向
    if (currentRequest.responseStatusCode == 200 || currentRequest.responseStatusCode == 206){
        if (error) {
            *error = currentRequest.error;
        }
    }else{
        if (error) {
            *error = [NSError errorWithDomain:currentRequest.error.localizedDescription code:currentRequest.error.code userInfo:nil];
        }
    }
    
    return currentRequest.responseData;
}

- (void)cancelRequest
{
    [currentRequest clearDelegatesAndCancel];
}

- (BOOL)isRequestCanceled
{
    _isRequestCanceled = currentRequest.isCancelled;
    return _isRequestCanceled;
}

#pragma mark - Block
- (void)getRequestFromURL:(NSString *)url params:(NSString *)params completion:(void (^)(BOOL, NSData *, NSString *, NSError *))completion
{
    [self requestFromURL:url params:params method:@"GET" completion:completion];
}

- (void)postRequestFromURL:(NSString *)url params:(NSString *)params completion:(void (^)(BOOL, NSData *, NSString *, NSError *))completion
{
    [self requestFromURL:url params:params method:@"POST" completion:completion];
}

- (void)requestFromURL:(NSString *)url params:(NSString *)params method:(NSString *)method completion:(void (^)(BOOL, NSData *, NSString *, NSError *))completion
{
    //[self dealDemonDataWithUrl:url completion:completion];
    //return;
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    DLog(@"%@: 请求的url: %@; 数据: %@", NSStringFromSelector(_cmd), url, params);
    ASIFormDataRequest *request = nil;
    BOOL isGet = [method isEqualToString:@"GET"];
    if (isGet)
    {
        // GET 请求的url为 url?params。
        url = [[url stringByAppendingString:@"?"] stringByAppendingString:params];
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    }
    else
    {
        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        NSArray *arrParams = [params componentsSeparatedByString:@"&"];
        
        for (NSString *strParam in arrParams)
        {
            NSArray *arrParam = [strParam componentsSeparatedByString:@"="];
            NSString *key = [arrParam objectAtIndex:0];
            NSString *value = [arrParam objectAtIndex:1];
            
            [request addPostValue:value forKey:key];
        }
    }
    
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setTimeOutSeconds:60.0f];// 超时时间60秒
    [request setNumberOfTimesToRetryOnTimeout:3];//超时重传3次。
    [request setShouldContinueWhenAppEntersBackground:YES];
    [request setRequestMethod:method];

    __block ASIFormDataRequest *_requestCopy = request;
    [request setCompletionBlock:^{
        //DLog(@"response: %@", _requestCopy.responseString);
        if (completion){
            completion(YES, _requestCopy.responseData, _requestCopy.responseString, _requestCopy.error);
        }
    }];
    
    [request setFailedBlock:^{
        //DLog(@"failed: %@; %@; %d", _requestCopy.responseStatusMessage, _requestCopy.responseString, _requestCopy.responseStatusCode);
        if (completion){
            NSError *error = [NSError errorWithDomain:_requestCopy.error.localizedDescription code:_requestCopy.error.code userInfo:nil];
            completion(YES, _requestCopy.responseData, _requestCopy.responseString, error);
        }
    }];
    
    [[self requestQueue] addOperation:request];//添加到队列，队列启动后不需重新启动
    if ([self requestQueue].isSuspended) {
        //DLog(@"suspend");
        // 只需调用一次go函数
        [[self requestQueue] go];
    }
}

- (ASINetworkQueue *)requestQueue
{
    if (!networdQueue)
    {
        networdQueue = [[ASINetworkQueue alloc] init];
        [networdQueue reset];
        //下载队列代理方法
        //[networdQueue setQueueDidFinishSelector:@selector(requestsFinished:)];
        [networdQueue setDelegate:self];
        [networdQueue setShouldCancelAllRequestsOnFailure:YES];
        [networdQueue setMaxConcurrentOperationCount:1];
    }
    return networdQueue;
}

- (void)requestsFinished:(id)sender
{
    
    //DLOG_CMETHOD;
}

- (void)cancelAllRequest
{
    if (networdQueue)
    {
        [networdQueue reset];
        networdQueue = nil;
    }
}

- (BOOL)isRequestAllCanceled
{
    return ([self.requestQueue operationCount] <= 0);
}

#pragma mark - DemonData Manager
- (void)dealDemonDataWithUrl:(NSString *)url completion:(void (^)(BOOL, NSData *, NSString *, NSError *))completion
{
    NSRange range = [url rangeOfString:kHostUrl];
    NSString *strApi = [url substringFromIndex:range.length];
    DLog(@"api: %@", strApi);
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"APIDemonData" ofType:@"txt"];
    //BOOL exit = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    //DLog(@"dic: %@; exit: %d", dic, exit);
    NSString *responseString = [[dic objectForKey:strApi] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    //DLog(@"responseString: %@", responseString);
    NSData *responseData = [responseString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    if (completion){
        completion(YES, responseData, responseString, nil);
    }
}

#pragma mark - Memeory Manager
- (void)dealloc
{
    [currentRequest clearDelegatesAndCancel];
    currentRequest = nil;
    self.error = nil;
    [self cancelAllRequest];
}

@end
