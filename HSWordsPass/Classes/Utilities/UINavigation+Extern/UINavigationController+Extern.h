//
//  UINavigationController+Extern.h
//  HSWordsPass
//
//  Created by yang on 14-8-28.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Extern)

- (void)customizeNavigationBarAppearance;

- (void)setNavigationBarShadow;

- (void)setNavigationBarBackItemWihtTarget:(UIViewController *)target image:(UIImage *)image;

- (void)setPresentNavigationBarBackItemWihtTarget:(UIViewController *)target image:(UIImage *)image;

@end
