//
//  HSGlobalMacro.h
//  HSWordsPass
//
//  Created by Lu on 14-9-9.
//

#import <Foundation/Foundation.h>

#pragma mark - 颜色处理
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

#pragma mark - 判断系统和机器类型
//
#define kIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define kiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)



#pragma mark - 获取沙盒路径
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#pragma mark - 屏幕尺寸
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#pragma mark - 快速定义单例
//获取单例
#define hsGetSharedInstanceClass(cls)  ((cls *)[cls sharedInstance])

//单例定义
#define hsSharedInstanceDefClass(cls)  +(cls *)sharedInstance;
#define hsSharedInstanceDefId  +(id)sharedInstance;

//单例实现
#define hsSharedInstanceImpClass(cls)            \
+(id)sharedInstance                             \
{                                               \
static id ShardInstance;                        \
static dispatch_once_t onceToken;               \
dispatch_once(&onceToken, ^{                    \
ShardInstance=[[cls alloc] init];               \
});                                             \
return ShardInstance;                           \
}                                               \



#pragma mark - 快速定义通知
//方便postNotification
#define kPostNotification(name,obj,info) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj userInfo:info]
//注册通知
#define kAddObserverNotification(observer,sel,n,obj)  [[NSNotificationCenter defaultCenter] addObserver:observer selector:sel name:n object:obj]
//移除通知
#define kRemoveObserverNotification(observer,n,obj)  [[NSNotificationCenter defaultCenter] removeObserver:observer name:n object:obj];

@interface HSGlobalMacro : NSObject

@end
