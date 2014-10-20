//
//  UIImage+Extra.h
//  PinyinGame
//
//  Created by yang on 13-11-11.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extra)

- (UIImage *)convertToGreyscale:(UIImage *)i;

+ (UIImage*)convertViewToImage:(UIView*)v;

+ (UIImage *)rotateImage:(UIImage *)aImage;

+ (UIImage *)originImage:(UIImage *)aImage scaleToSize:(CGSize)size;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

+ (UIImage*)circleImage:(UIImage*)image withParam:(CGFloat)inset;

@end
