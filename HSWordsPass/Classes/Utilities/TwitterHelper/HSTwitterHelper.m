//
//  HSTwitterHelper.m
//  HSWordsPass
//
//  Created by Lu on 14-9-5.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSTwitterHelper.h"
#import "STTwitter.h"


#define strTwitterAppKey       @"nJsougOrOCTeo13NuXo47XbIV"
#define strTwitterSecret       @"SuvRD6DHbKx1hJ8nbRelYy5JbmGx7I62y1Iok6pIW9Izshdopf"


void (^loginFinished)(NSString *userID, NSString *name, NSString *imageUrl, NSString *token);

void (^refreshShow)(NSString *);


@interface HSTwitterHelper ()

@property (nonatomic, strong) STTwitterAPI *twitter;

@end


@implementation HSTwitterHelper
{
    NSString *strToken;
}

hsSharedInstanceImpClass(HSTwitterHelper)


- (void)startLogin:(void (^)(NSString *, NSString *, NSString *, NSString *))finished
{
    
    loginFinished = finished;
    
    //设置默认存储
    [self registerUserDefaults];
    
    _twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];

    
    //先通过是否安装app登陆,如果无法打开已安装app登陆  则打开浏览器登陆
    [_twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        DLog(@"打开客户端username%@",username);

        STTwitterAPI *tempApi = [STTwitterAPI twitterAPIWithOAuthConsumerKey:strTwitterAppKey
                                                 consumerSecret:strTwitterSecret];
//        DLog(@"%@-----",tempApi.oauthAccessToken);
        
        [tempApi postTokenRequest:^(NSURL *url, NSString *oauthToken) {
            
            DLog(@"%@---------",url);
            NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
            strToken = d[@"oauth_token"];
            //保存信息并登陆
            [self getDetailInfo];
            
        } oauthCallback:@"twitterhswordpass://twitter_access_tokens/" errorBlock:^(NSError *error) {
            DLog(@"%@",[error localizedDescription]);
        }];
        
    } errorBlock:^(NSError *error) {
        DLog(@"打开浏览器");
        [self loginInSafariAction];
    }];

}


//浏览器登陆
- (void)loginInSafariAction
{
    _twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:strTwitterAppKey
                                                 consumerSecret:strTwitterSecret];
    
    [_twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        DLog(@"-- url: %@; oauthToken: %@",url, oauthToken);
        [[UIApplication sharedApplication] openURL:url];
        
    } authenticateInsteadOfAuthorize:NO
                    forceLogin:@(YES)
                    screenName:nil
                 oauthCallback:@"twitterhswordpass://twitter_access_tokens/"
                    errorBlock:^(NSError *error) {
                        DLog(@"-- error: %@", error);
                    }];
}




- (BOOL)handleTwitterOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
{
    
    if ([[url scheme] isEqualToString:@"twitterhswordpass"] == NO)
    {
        return NO;
    }
    
    DLog(@"url=====%@",url);
    
    NSDictionary *d = [self parametersDictionaryFromQueryString:[url query]];
    strToken = d[@"oauth_token"];
    NSString *verifier = d[@"oauth_verifier"];
    
    [_twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        
        DLog(@"-- screenName: %@", screenName);
        [self getDetailInfo];
        
    } errorBlock:^(NSError *error) {
        DLog(@"-- %@", [error localizedDescription]);
    }];
    
    return YES;
}


//处理接口返回数据
- (NSDictionary *)parametersDictionaryFromQueryString:(NSString *)queryString {
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    
    for(NSString *s in queryComponents) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;
        
        NSString *key = pair[0];
        NSString *value = pair[1];
        
        md[key] = value;
    }
    
    return md;
}



//获得用户详细信息
- (void)getDetailInfo
{
    [_twitter getAccountVerifyCredentialsWithSuccessBlock:^(NSDictionary *account) {
        
//        DLog(@"%@",account);
        NSString *userID = [account objectForKey:@"id_str"];
        NSString *name = [account objectForKey:@"screen_name"];
        NSString *imageUrl = [account objectForKey:@"profile_image_url"];
        NSString *token = strToken;
        
        [self refreshUserDefaultsWithTwitterToken:token TwitterUid:userID TwitterUName:name];
        
        //登陆验证
        loginFinished(userID,name,imageUrl,token);
    
    } errorBlock:^(NSError *error) {
        DLog(@"-- %@", [error localizedDescription]);
    }];
}



- (void)registerUserDefaults{
    NSDictionary *dicWbToken = [NSDictionary dictionaryWithObject:@"" forKey:@"TwitterToken"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dicWbToken];
    
    NSDictionary *dicWbUid   = [NSDictionary dictionaryWithObject:@"" forKey:@"TwitterUid"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dicWbUid];
    
    NSDictionary *dicWbName   = [NSDictionary dictionaryWithObject:@"Twitter" forKey:@"TwitterName"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dicWbName];
}


- (void)refreshUserDefaultsWithTwitterToken:(NSString *)token TwitterUid:(NSString *)uid TwitterUName:(NSString *)name
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:name forKey:@"TwitterName"];
    [userDefaults setObject:uid forKey:@"TwitterUid"];
    [userDefaults setObject:token forKey:@"TwitterToken"];
    [userDefaults synchronize];
}



- (NSString *)getScreenName
{
    NSString *screenName = [[NSUserDefaults standardUserDefaults] objectForKey:@"TwitterName"];
    return screenName;
}


- (void)logOut:(void (^)(NSString *))refresh
{
    refreshShow = refresh;
    
    refresh(@"退出成功");
    
    _twitter = nil;

}




@end
