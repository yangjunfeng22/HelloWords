//
//  UINavigationController+Extern.m
//  HSWordsPass
//
//  Created by yang on 14-8-28.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "UINavigationController+Extern.h"

@implementation UINavigationController (Extern)

#pragma mark - customize NavigationBar
- (void)customizeNavigationBarAppearance
{
    if (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)){
        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTintColor:hsGlobalBlueColor];
        
    }else{
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [self removeNavigationBarShadow];
    }
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:hsGlobalBlueColor, UITextAttributeTextColor, [UIColor colorWithWhite:1.0f alpha:0.7f], UITextAttributeTextShadowColor, [UIFont fontWithName:@"Helvetica" size:18.0f], UITextAttributeFont, nil]];
}

- (void)removeNavigationBarShadow
{
    [self.navigationBar setBackgroundColor:[UIColor whiteColor]];
    CALayer *navLayer = self.navigationBar.layer;
    
    navLayer.masksToBounds = YES;
    
    navLayer.borderWidth = 0.01f;
    navLayer.borderColor = [UIColor lightGrayColor].CGColor;
    
    navLayer.shouldRasterize = YES;
}

- (void)setNavigationBarShadow
{
    [self.navigationBar setBackgroundColor:[UIColor whiteColor]];
    
    CALayer *navLayer = self.navigationBar.layer;
    
    navLayer.masksToBounds = NO;
    navLayer.shadowColor = [UIColor whiteColor].CGColor;
    navLayer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    navLayer.shadowOpacity = 0.05f;
    navLayer.shadowPath = [UIBezierPath bezierPathWithRect:self.navigationBar.bounds].CGPath;
    
    navLayer.borderWidth = 0.5f;
    navLayer.borderColor = [UIColor whiteColor].CGColor;
    
    navLayer.shouldRasterize = YES;
}

- (void)setNavigationBarBackItemWihtTarget:(UIViewController *)target image:(UIImage *)image
{
    [target.navigationItem setHidesBackButton:YES];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:image forState:UIControlStateNormal];
    [btnBack addTarget:target.navigationController action:@selector(customPopViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    btnBack.bounds = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    [target.navigationItem setLeftBarButtonItem:backItem animated:YES];
    target.navigationItem.leftItemsSupplementBackButton = YES;
}

- (void)setPresentNavigationBarBackItemWihtTarget:(UIViewController *)target image:(UIImage *)image{
    [target.navigationItem setHidesBackButton:YES];
    
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBack setImage:image forState:UIControlStateNormal];
    [btnBack addTarget:target.navigationController action:@selector(customDismissiewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    btnBack.bounds = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
    [target.navigationItem setLeftBarButtonItem:backItem animated:YES];
    target.navigationItem.leftItemsSupplementBackButton = YES;
}

- (void)customPopViewControllerAnimated:(id)sender
{
    [self popViewControllerAnimated:YES];
}

- (void)customDismissiewControllerAnimated:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
