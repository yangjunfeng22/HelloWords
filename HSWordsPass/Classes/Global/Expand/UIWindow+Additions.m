//
//  UIWindow+Additions.m
//  I8
//
//  Created by hvming on 13-4-25.
//  Copyright (c) 2013年 hvming. All rights reserved.
//

#import "UIWindow+Additions.h"

@implementation UIWindow (Additions)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)findFirstResponder {
    return [self findFirstResponderInView:self];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)findFirstResponderInView:(UIView*)topView {
    if ([topView isFirstResponder]) {
        return topView;
    }
    
    for (UIView* subView in topView.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
        
        UIView* firstResponderCheck = [self findFirstResponderInView:subView];
        if (nil != firstResponderCheck) {
            return firstResponderCheck;
        }
    }
    return nil;
}


@end
