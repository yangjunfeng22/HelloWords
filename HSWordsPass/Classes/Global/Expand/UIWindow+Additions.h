//
//  UIWindow+Additions.h
//  I8
//
//  Created by hvming on 13-4-25.
//  Copyright (c) 2013年 hvming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Additions)

/**
 * Searches the view hierarchy recursively for the first responder, starting with this window.
 */
- (UIView*)findFirstResponder;

/**
 * Searches the view hierarchy recursively for the first responder, starting with topView.
 */
- (UIView*)findFirstResponderInView:(UIView*)topView;

@end
