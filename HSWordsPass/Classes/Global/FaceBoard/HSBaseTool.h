//
//  HSBaseFormatTool.h
//  HSWordsPass
//
//  Created by Lu on 14-9-9.
//

#import <Foundation/Foundation.h>


#define defDateFormatter @"yyyy-MM-dd HH:mm:ss"

#define HEXCOLOR(hex) [HSBaseTool getHexColor:(hex)]
#define HEXCOLOR(hex) [HSBaseTool getHexColor:(hex)]


typedef NS_ENUM(NSUInteger, HUDYOffSetPosition) {
    HUDYOffSetPositionTop = 0,
    HUDYOffSetPositionCenter,
    HUDYOffSetPositionBottom,
};


@interface HSBaseTool : NSObject

hsSharedInstanceDefClass(HSBaseTool)

#pragma mark NSDate和NSString转化
+(NSDate *)dateWithString:(NSString *)str;
+(NSDate *)dateWithString:(NSString *)str format:(NSString *)format;
+(NSDate *)dateWithDate:(NSDate *)date format:(NSString *)format;
+(NSString *)stringWithDate:(NSDate *)date;
+(NSString *)stringWithDate:(NSDate *)date format:(NSString *)format;
+(NSString *)stringWithStringDate:(NSString *)dateString format:(NSString *)format;


#pragma mark 颜色的16进制的表示法
//phone应用变成中，不识别16进制的表示法，需要转化成rgb表示法
+ (UIColor *) getHexColor:(NSString *)hexColor; //通过宏 HEXCOLOR 来调用



#pragma mark 邮箱手机格式验证
+ (BOOL)isEmailString:(NSString *)email;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;



#pragma mark - 方便添加RightBarButtonItem
UIBarButtonItem* CreatViewControllerImageBarButtonItem(UIImage *image,SEL action,UIViewController *viewController,BOOL isLeft);
UIBarButtonItem* CreatViewControllerTitleBarButtonItem(NSString *title,SEL action,UIViewController *viewController,BOOL isLeft);
UIBarButtonItem* CreatViewControllerTitleBarButtonItemWithTag(NSString *title,id target,SEL action,UIViewController *viewController,BOOL isLeft);



#pragma mark - 方便添加hub
-(void)HUDForView:(UIView *)view Title:(NSString *)title isHide:(BOOL)hide;
-(void)HUDForView:(UIView *)view detail:(NSString *)title isHide:(BOOL)hide;
-(void)HUDForView:(UIView *)view Title:(NSString *)title detail:(NSString *)str isHide:(BOOL)hide afterDelay:(NSTimeInterval)delay;
-(void)HUDForView:(UIView *)view Title:(NSString *)title detail:(NSString *)str isHide:(BOOL)hide afterDelay:(NSTimeInterval)delay yOffset:(CGFloat)yOffset;
-(void)HUDForView:(UIView *)view Title:(NSString *)title isHide:(BOOL)isHide position:(HUDYOffSetPosition)postion;

-(void)hideAllHUDForView:(UIView *)view animated:(BOOL)animated;


@end
