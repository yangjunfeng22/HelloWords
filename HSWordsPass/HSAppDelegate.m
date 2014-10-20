//
//  HSAppDelegate.m
//  HSWordsPass
//
//  Created by yang on 14-7-8.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSAppDelegate.h"
#import "HSRootViewController.h"
#import "UIGuidViewController.h"
#import "UINavigationController+Extern.h"
#import "SoftwareVerisonDAL.h"
#import "HSRemoteNotificationHelper.h"
#import "ResponseModel.h"

#import "NFSinaWeiboHelper.h"
#import "NFFaceBookHelper.h"
#import "HSTwitterHelper.h"
#import "UpdateAppNet.h"

#import "ACTReporter.h"

#import "WeiboSDK.h"

@interface HSAppDelegate ()<UIGuidViewControllerDelegate, WeiboSDKDelegate,UIAlertViewDelegate>
{
    ResponseModel *responseModel;
}

@end

@implementation HSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupAutoMigratingCoreDataStack];
    //[MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelVerbose];
    
    // 注册第三方的app管理
    [self registerThirdAppKey];
    
    
    // Hello Words iOS
    // Google iOS Download tracking snippet
    // To track downloads of your app, add this snippet to your
    // application delegate's application:didFinishLaunchingWithOptions: method.
    
    [ACTConversionReporter reportWithConversionID:@"971962044" label:@"6CVMCJqs91YQvO27zwM" value:@"0.00" isRepeatable:NO];
    
    
    
    [NFSinaWeiboHelper registerApp];
    [NFFaceBookHelper registerApp];
    
    [self registerKeyValueToUserDefaults];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = kWhiteColor;
    
    [self dealFirstLaunch];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming   phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [NFFaceBookHelper handleBecomeActive];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //[HSRemoteNotificationHelper registerForRemoteNotificationToGetToken];
    });
    // hide the badge
    application.applicationIconBadgeNumber = 0;
    
    
    
    // 检查当前app是否有更新信息
    [NSThread detachNewThreadSelector:@selector(checkAppUpdateInfo) toTarget:self withObject:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [NFFaceBookHelper close];
    [MagicalRecord cleanUp];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    DLog(@"sourceApplication: %@; annotation: %@", sourceApplication, annotation);
    
    [NFFaceBookHelper handleStateChange];
    
    BOOL fb = [NFFaceBookHelper handleFBOpenURL:url sourceApplication:sourceApplication];;
    
    BOOL wb = [WeiboSDK handleOpenURL:url delegate:self];
    
    BOOL tw = [hsGetSharedInstanceClass(HSTwitterHelper) handleTwitterOpenURL:url sourceApplication:sourceApplication];
    
    return (fb || wb || tw);
}


#pragma mark - Weibo Delegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    DLog(@"%@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    //DLog(@"%@", NSStringFromSelector(_cmd));
    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]])
    {
        [NFSinaWeiboHelper sendMessageWithResponse:response];
    }
    else if ([response isKindOfClass:[WBAuthorizeResponse class]])
    {
        [NFSinaWeiboHelper authorizeWithResponse:response];
    }
}

#pragma mark - 消息服务的注册与接收
// 消息通知服务
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //DLog(@"register success: %@", deviceToken);
    // 将device token转换为字符串
    NSString *strDeviceToken = [[NSString alloc] initWithFormat:@"%@", deviceToken];
    // 注册成功，将deviceToken保存到应用服务器数据库中
    strDeviceToken = [[strDeviceToken substringWithRange:NSMakeRange(0, 72)] substringWithRange:NSMakeRange(1, 71)];
    // 将deviceToken保存在NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // 保存device token令牌， 并且去掉空格
    NSString *strNEToken = [strDeviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [userDefaults setObject:strNEToken forKey:kDeviceTokenStringKey];
    // send deviceToken to the service provider
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 没有在service provider注册device token，需要发送令牌到服务器
        if (![userDefaults boolForKey:kDeviceTokenRegisteredKey])
        {
            //DLog(@"没有注册Device token");
            [HSRemoteNotificationHelper sendProviderDeviceToken:strDeviceToken];
        }
    });
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // 处理推送消息
    application.applicationIconBadgeNumber += 1;
    // 当用户打开程序时候收到远程通知执行下面代码
    if (application.applicationState == UIApplicationStateActive)
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // hide the badge
            application.applicationIconBadgeNumber = 0;
            
            // ask the provider to set the badgenumber to zero
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *strDeviceToken = [userDefaults objectForKey:kDeviceTokenStringKey];
            [HSRemoteNotificationHelper resetBadgeNumberOnProviderWithDeviceToken:strDeviceToken];
        });
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
    DLog(@"remote notification regist failed: %@", error.localizedDescription);
    /*
     NSString *msg = [[NSString alloc] initWithFormat:@"%@", error.localizedDescription];
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [alert show];
     */
}



#pragma mark - 注册第三方的追踪信息。
- (void)registerThirdAppKey
{
    NSString *version = kSoftwareVersion;

    // 谷歌分析
    // 1
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // 2
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelVerbose];
    // 3
    [GAI sharedInstance].dispatchInterval = 20;
    
    id tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-55684024-1"];

    [tracker set:kGAIAppVersion value:version];
    [tracker set:kGAISampleRate value:@"50.0"];
    
}

#pragma mark - Custom Manager
#pragma mark -  注册一些常用数据
- (void)registerKeyValueToUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 用户是否已经登陆进去
    //  --已经用数据库的方式替代了。因为在iphone6中表现始终是一个错误的bool值。
    //NSDictionary *dicUser  = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], @"UserLogined", nil];
    //[userDefaults registerDefaults:dicUser];
    
    // 用户当前的ID
    NSDictionary *dicUserID  = [NSDictionary dictionaryWithObjectsAndKeys:@"0", kUDKEY_UserID, nil];
    [userDefaults registerDefaults:dicUserID];
    
    NSDictionary *dicEmail = [NSDictionary dictionaryWithObjectsAndKeys:@"", kUDKEY_Email, nil];
    [userDefaults registerDefaults:dicEmail];
    
    // 选择的词书种类的ID
    NSDictionary *dicCID  = [NSDictionary dictionaryWithObjectsAndKeys:@"0", kUDKEY_CategoryID, nil];
    [userDefaults registerDefaults:dicCID];
    
    // 选择的词书的ID
    NSDictionary *dicBID  = [NSDictionary dictionaryWithObjectsAndKeys:@"0", kUDKEY_BookID, nil];
    [userDefaults registerDefaults:dicBID];
    
    // 以默认形式登陆
    NSDictionary *dicUserLoginType  = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:kLoginTypeDefault], @"UserLoginType", nil];
    [userDefaults registerDefaults:dicUserLoginType];
    
    // 设备令牌是否已注册。
    NSDictionary *dicDevToken  = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kDeviceTokenRegisteredKey, nil];
    [userDefaults registerDefaults:dicDevToken];
    [userDefaults synchronize];
}

#pragma mark - 处理是否是第一次打开程序/是更新后的第一次打开程序
- (void)dealFirstLaunch
{
#ifdef DEBUG
    CFTimeInterval start = CFAbsoluteTimeGetCurrent();
#endif
    BOOL isLaunched = [SoftwareVerisonDAL isLaunchedWithVersion:kSoftwareVersion];
#ifdef DEBUG
    CFTimeInterval end = CFAbsoluteTimeGetCurrent();
#endif
    DLog(@"查询用时: %f", end-start);
    if (isLaunched)
    {
        [self initRootViewController];
    }
    else
    {
        [self initGuidViewController];
    }
}

#pragma mark - 初始化HSRootViewController
- (void)initRootViewController
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [[UIApplication sharedApplication] setStatusBarStyle:(kIOS7 ? UIStatusBarStyleDefault:UIStatusBarStyleBlackOpaque) animated:YES];
    
    HSRootViewController *rootViewController = [[HSRootViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [nav customizeNavigationBarAppearance];
    self.navigationController = nav;
    self.window.rootViewController = self.navigationController;
    self.window.rootViewController.view.alpha = 0.0f;
    [UIView animateWithDuration:0.3f animations:^{
        self.window.rootViewController.view.alpha = 1.0f;
    }];
}

#pragma mark - Custom Guid/Root ViewController
- (void)initGuidViewController
{
    NSArray *arrImages = @[@"G2.jpg", @"G3.jpg", @"G4.jpg", @"G5.jpg", @"G6.jpg"];
    UIGuidViewController *guidViewController = [[UIGuidViewController alloc] initWithNibName:nil bundle:nil guidPages:arrImages];
    guidViewController.delegate = self;
    self.window.rootViewController = guidViewController;
    
    [UIApplication sharedApplication].statusBarHidden = YES;
}

#pragma mark - UIGuidViewController Delegate
- (void)guidViewController:(UIGuidViewController *)controller experienceAction:(id)sender
{
    //只要这个引导界面点击了体验按钮(暂定, 也可能是其他名称的按钮), 就设置第一次启动为NO。
    [UIView animateWithDuration:0.3f animations:^{
        self.window.rootViewController.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        
        [self initRootViewController];
        
        // 当前软件已经进入体验模式
        CFTimeInterval start = CFAbsoluteTimeGetCurrent();
        [SoftwareVerisonDAL saveSoftwareVersionWithVersion:kSoftwareVersion dbVersion:kSoftwareVersion launched:YES completion:^(BOOL finished, id result, NSError *error) {
            
        }];
        CFTimeInterval end = CFAbsoluteTimeGetCurrent();
        DLog(@"保存用时: %f", end-start);
    }];
}




#pragma mark - 检查版本更新
- (void)checkAppUpdateInfo
{
    @autoreleasepool
    {
        [hsGetSharedInstanceClass(UpdateAppNet) checkAppUpdateInfo:^(BOOL finished, id result, NSError *error) {
            responseModel = result;
            
            if (1 == responseModel.error.code)
            {
                [self performSelectorOnMainThread:@selector(showAlertView) withObject:nil waitUntilDone:NO];
            }
        }];
    }
}


- (void)showAlertView
{
    NSString *strIgnor = 1 == responseModel.statuCode ? @"退出应用" : @"忽略";
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", @"") message:responseModel.error.domain delegate:self cancelButtonTitle:NSLocalizedString(strIgnor, @"") otherButtonTitles:NSLocalizedString(@"立即更新", @""), nil];
    
    [alert show];
}


#pragma mark - UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger appID = 930872352;
    NSString *strAppID = [[NSString alloc] initWithFormat:@"%d", appID];
    if (1 == buttonIndex)
    {
        
        //NSString *appUrl = [[NSString alloc] initWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%d", appID];
        
        NSString *appUrl = [[NSString alloc] initWithFormat:@"itms-apps://itunes.apple.com/us/app/id%d?mt=8", appID];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
        
        [CommonHelper googleAnalyticsLogCategory:@"应用更新" action:@"应用ID" event:strAppID pageView:NSStringFromClass([self class])];
    }
    else
    {
        [CommonHelper googleAnalyticsLogCategory:@"忽略更新" action:@"应用ID" event:strAppID pageView:NSStringFromClass([self class])];
    }
    
    if (1 == responseModel.statuCode)
    {
        [self exitApplication];
    }
}


- (void)exitApplication
{
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.3];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    self.window.alpha = 0;
    //self.window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}


@end
