//
//  UIGuidViewController.h
//  DicisionMaking
//
//  Created by yang on 13-4-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIGuidViewControllerDelegate;

@interface UIGuidViewController : UIViewController<UIScrollViewDelegate>
{
    NSMutableArray *arrGuidPages;                                                                   //用户引导页面数组
}

@property (nonatomic, weak)id<UIGuidViewControllerDelegate>delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil guidPages:(NSArray *)aPages;

@end

@protocol UIGuidViewControllerDelegate <NSObject>

@optional
- (void)guidViewController:(UIGuidViewController *)controller experienceAction:(id)sender;

@end
