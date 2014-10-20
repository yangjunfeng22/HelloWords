//
//  HSBaseTool.m
//  HSWordsPass
//
//  Created by Lu on 14-9-9.
//

#import "HSBaseTool.h"
#import "MBProgressHUD.h"

@implementation HSBaseTool

hsSharedInstanceImpClass(HSBaseTool)

+(NSDateFormatter*)getDateFormat
{
    static NSDateFormatter* format;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        format = [[NSDateFormatter alloc]init];
        //[format setCalendar:[NSCalendar currentCalendar]];
        //[format setLocale:[NSLocale currentLocale]];
        //[format setTimeZone:[NSTimeZone systemTimeZone]];
    });
    [format setDateFormat:defDateFormatter];
    
    return format;
}


//把Date 转换成String
+(NSString *)stringWithDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
    NSDateFormatter* formatter = [self getDateFormat];
    NSString* datestr = [formatter stringFromDate:date];
    return datestr;
}
+(NSString *)stringWithDate:(NSDate *)date format:(NSString *)format{
    if (!date) {
        return nil;
    }
    NSDateFormatter* formatter = [self getDateFormat];
    [formatter setDateFormat:format];
    NSString* datestr = [formatter stringFromDate:date];
    return datestr;
}
+(NSString *)stringWithStringDate:(NSString *)dateString format:(NSString *)format{
    NSDate *date = [HSBaseTool dateWithString:dateString format:format];
    return [HSBaseTool stringWithDate:date format:format];
}

+(NSDate *)dateWithString:(NSString *)str
{
    if (!str) {
        return nil;
    }
    NSDateFormatter* formatter = [self getDateFormat];
    NSDate* date = [formatter dateFromString:str];
    return date;
}
+(NSDate *)dateWithString:(NSString *)str format:(NSString *)format{
    if (!str) {
        return nil;
    }
    NSDateFormatter* formatter = [self getDateFormat];
    [formatter setDateFormat:format];
    NSDate* date = [formatter dateFromString:str];
    return date;
}
+(NSDate *)dateWithDate:(NSDate *)date format:(NSString *)format{
    NSString *dateStr = [HSBaseTool stringWithDate:date format:format];
    return [HSBaseTool dateWithString:dateStr format:format];
}





#pragma mark iphone应用变成中，不识别16进制的表示法，需要转化成rgb表示法
+(UIColor *) getHexColor:(NSString *)hexColor
{
    if ([NSString isNullString:hexColor]) {
        return nil;
    }
    
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:1.0f];
}




#pragma mark 邮箱手机格式验证
+ (BOOL)isEmailString:(NSString *)email{
    NSString *reg = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    
    NSPredicate *regexEmail = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", reg];
    
    return [regexEmail evaluateWithObject:email];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}






#pragma mark - 方便添加RightBarButtonItem

UIBarButtonItem* CreatViewControllerImageBarButtonItem(UIImage *image,SEL action,UIViewController *viewController,BOOL isLeft)
{
    
    /**
     * ios7 下使用
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:viewController action:action];
//    if (isLeft) {
//        [viewController.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
//    }else{
//        [viewController.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
//    }
//    return barButtonItem;
     */
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width, image.size.height);
//    button.frame = CGRectMake(0, 0, 40, 38);
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:viewController action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (isLeft) {
        [viewController.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    }else{
        [viewController.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
    }
    return barButtonItem;
}


UIBarButtonItem* CreatViewControllerTitleBarButtonItem(NSString *title,SEL action,UIViewController *viewController,BOOL isLeft)
{
    /*
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:viewController action:action];
//    if (isLeft) {
//        [viewController.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
//    }else{
//        [viewController.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
//    }
//    return barButtonItem;
     */
    
    //UIFont *font = [UIFont systemFontOfSize:16.0f];
    //CGSize size = [title sizeWithFont:font constrainedToSize:CGSizeMake(80, 32) lineBreakMode:NSLineBreakByTruncatingTail];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //button.frame = CGRectMake(0, 0, ceilf(size.width), ceilf(size.height));
    button.frame = CGRectMake(0, 0, 48, 30);
//    UIImage *leftButtonImage = BarItemNormalBackgroundImage;
//    UIImage *leftButtonHighlightedImage = BarItemHighlightBackgroundImage;
//    [button setBackgroundImage:leftButtonImage forState:UIControlStateNormal];
//    [button setBackgroundImage:leftButtonHighlightedImage forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:hsShineBlueColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button addTarget:viewController action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if (isLeft) {
        [viewController.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    }else{
        [viewController.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
    }
    return barButtonItem;
}


UIBarButtonItem* CreatViewControllerTitleBarButtonItemWithTag(NSString *title,id target,SEL action,UIViewController *viewController,BOOL isLeft)
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    if (isLeft) {
        [viewController.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    }else{
        [viewController.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
    }
    return barButtonItem;

}




-(void)HUDForView:(UIView *)view Title:(NSString *)title isHide:(BOOL)isHide position:(HUDYOffSetPosition)position{
    CGFloat yOffset = 0;
    switch (position) {
        case HUDYOffSetPositionTop:      {yOffset = -120; } break;
        case HUDYOffSetPositionCenter:   {yOffset = 0; } break;
        case HUDYOffSetPositionBottom:   {yOffset = 120; } break;
        default: break;
    }
    [self HUDForView:view Title:title detail:nil isHide:isHide afterDelay:1.0f yOffset:yOffset];
}

-(void)HUDForView:(UIView *)view Title:(NSString *)title isHide:(BOOL)hide{
    [self HUDForView:view Title:title detail:nil isHide:hide afterDelay:1.0f];
}

-(void)HUDForView:(UIView *)view detail:(NSString *)title isHide:(BOOL)hide{
    [self HUDForView:view Title:nil detail:title isHide:hide afterDelay:1.5f yOffset:0];
}

-(void)HUDForView:(UIView *)view Title:(NSString *)title detail:(NSString *)str isHide:(BOOL)hide afterDelay:(NSTimeInterval)delay{
    [self HUDForView:view Title:title detail:str isHide:hide afterDelay:delay yOffset:120];
}
-(void)HUDForView:(UIView *)view Title:(NSString *)title detail:(NSString *)str isHide:(BOOL)hide afterDelay:(NSTimeInterval)delay yOffset:(CGFloat)yOffset{
    MBProgressHUD *progressHUD = [MBProgressHUD HUDForView:view];
    if (!progressHUD) {
        progressHUD = [[MBProgressHUD alloc] initWithView:view];
        __block __weak MBProgressHUD *tempProgressHUD = progressHUD;
        [view addSubview:tempProgressHUD];
        tempProgressHUD.userInteractionEnabled = NO;
        tempProgressHUD.yOffset = yOffset;
        tempProgressHUD.mode = MBProgressHUDModeText;
        tempProgressHUD.animationType = MBProgressHUDAnimationZoomOut;
        tempProgressHUD.labelText = title;
        tempProgressHUD.detailsLabelText = str;
        [tempProgressHUD show:YES];
        
        if (hide) {
            [tempProgressHUD hide:YES afterDelay:delay];
            [tempProgressHUD setCompletionBlock:^(void){
                [tempProgressHUD removeFromSuperview];
                tempProgressHUD = nil;
            }];
        }
    }else{
        __block __weak MBProgressHUD *tempProgressHUD = progressHUD;
        tempProgressHUD.labelText = title;
        tempProgressHUD.detailsLabelText = str;
        tempProgressHUD.yOffset = yOffset;
        [tempProgressHUD show:YES];
        
        if (hide) {
            [tempProgressHUD hide:YES afterDelay:delay];
            [tempProgressHUD setCompletionBlock:^(void){
                [tempProgressHUD removeFromSuperview];
                tempProgressHUD = nil;
            }];
        }
    }
}

-(void)hideAllHUDForView:(UIView *)view animated:(BOOL)animated{
    [MBProgressHUD hideAllHUDsForView:view animated:animated];
}



@end
