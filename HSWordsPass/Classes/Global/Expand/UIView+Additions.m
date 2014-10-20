//
//  UIView+Additions.m
//  I8
//
//  Created by hvming on 13-4-25.
//  Copyright (c) 2013年 hvming. All rights reserved.
//

#import "UIView+Additions.h"
#import "UIWindow+Additions.h"
//#import "ASProgressPopUpView.h"

BOOL TTIsKeyboardVisible() {
    // Operates on the assumption that the keyboard is visible if and only if there is a first
    // responder; i.e. a control responding to key events
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    return !![window findFirstResponder];
}

#define I8_TRANSITION_DURATION 0.3


@interface UIView ()
@property (nonatomic, strong) UIView *gradientColorLineView;
@property (nonatomic, readwrite) ASProgressPopUpView *progressPopUpView;
@end

@implementation UIView (Additions)


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
    }
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += view.left;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += view.top;
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
    return CGRectMake(self.screenViewX, self.screenViewY, self.width, self.height);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
        
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
        
    } else {
        return nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0, y = 0;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += view.left;
        y += view.top;
    }
    return CGPointMake(x, y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)frameWithKeyboardSubtracted:(CGFloat)plusHeight {
    CGRect frame = self.frame;
    if (TTIsKeyboardVisible()) {
        CGRect screenFrame = [[UIScreen mainScreen] bounds];
        CGFloat keyboardTop = (screenFrame.size.height - (216 + plusHeight));
        CGFloat screenBottom = self.ttScreenY + frame.size.height;
        CGFloat diff = screenBottom - keyboardTop;
        if (diff > 0) {
            frame.size.height -= diff;
        }
    }
    return frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSDictionary *)userInfoForKeyboardNotification {
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    CGPoint centerBegin = CGPointMake(floor(screenFrame.size.width/2 - self.width/2),
                                      screenFrame.size.height + floor(self.height/2));
    CGPoint centerEnd = CGPointMake(floor(screenFrame.size.width/2 - self.width/2),
                                    screenFrame.size.height - floor(self.height/2));
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSValue valueWithCGPoint:centerBegin], UIKeyboardFrameBeginUserInfoKey,
            [NSValue valueWithCGPoint:centerEnd], UIKeyboardFrameEndUserInfoKey,
            nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)presentAsKeyboardAnimationDidStop {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidShowNotification
                                                        object:self
                                                      userInfo:[self
                                                                userInfoForKeyboardNotification]];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dismissAsKeyboardAnimationDidStop {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardDidHideNotification
                                                        object:self
                                                      userInfo:[self
                                                                userInfoForKeyboardNotification]];
    [self removeFromSuperview];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)presentAsKeyboardInView:(UIView*)containingView {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification
                                                        object:self
                                                      userInfo:[self
                                                                userInfoForKeyboardNotification]];
    
    self.top = containingView.height;
    [containingView addSubview:self];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:I8_TRANSITION_DURATION];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(presentAsKeyboardAnimationDidStop)];
    self.top -= self.height;
    [UIView commitAnimations];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dismissAsKeyboard:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification
                                                        object:self
                                                      userInfo:[self
                                                                userInfoForKeyboardNotification]];
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:I8_TRANSITION_DURATION];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(dismissAsKeyboardAnimationDidStop)];
    }
    
    self.top += self.height;
    
    if (animated) {
        [UIView commitAnimations];
        
    } else {
        [self dismissAsKeyboardAnimationDidStop];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController *) firstViewController {
    // convenience function for casting and to "mask" the recursive function
    return (UIViewController *)[self traverseResponderChainForViewController:[UIViewController class]];
}

- (id) traverseResponderChainForViewController:(Class)clazz{
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:clazz]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForViewController:clazz];
    } else {
        return nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)drawViewCornerWithRadius:(CGFloat)cornerRadius{
    return [self drawViewCorner:CGSizeMake(cornerRadius, cornerRadius)];

}
- (id)drawViewCorner:(CGSize)radii{
    return [self drawViewCorner:radii withCorner:UIRectCornerAllCorners];
}

-(id)drawViewCorner:(CGSize)radii withCorner:(UIRectCorner)corners{
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:radii];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame         = self.bounds;
    maskLayer.path          = maskPath.CGPath;
    self.layer.mask         = maskLayer;
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////

//static char kHvmingGradientColorLineView;

//- (UIView *)gradientColorLineView
//{
//    return objc_getAssociatedObject(self, &kHvmingGradientColorLineView);
//}
//- (void)setGradientColorLineView:(UIView *)gradientColorLineView{
//    [self willChangeValueForKey:@"gradientColorLineView"];
//    objc_setAssociatedObject(self,
//                             &kHvmingGradientColorLineView,
//                             gradientColorLineView,
//                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self didChangeValueForKey:@"gradientColorLineView"];
//}

- (void)addGradientColorLineAnimation{
    if (!self.gradientColorLineView) {
        UIImage *lineImage = [UIImage imageNamed:@"tabbar_up_color_line"];
        UIImageView *tabBarLineView1 = [[UIImageView alloc] initWithImage:lineImage];
        UIImageView *tabBarLineView2 = [[UIImageView alloc] initWithImage:lineImage];
        UIImageView *tabBarLineView3 = [[UIImageView alloc] initWithImage:lineImage];
        tabBarLineView1.origin = CGPointMake(0, 0);
        tabBarLineView2.origin = CGPointMake(lineImage.size.width, 0);
        tabBarLineView2.transform = CGAffineTransformMakeRotation(M_PI);
        tabBarLineView3.origin = CGPointMake(lineImage.size.width*2, 0);
        CGFloat width = lineImage.size.width * 3.0f;
        CGFloat x = width - self.width;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(-x, 0, width, 1)];
        lineView.backgroundColor = [UIColor clearColor];
        [lineView addSubview:tabBarLineView1];
        [lineView addSubview:tabBarLineView2];
        [lineView addSubview:tabBarLineView3];
        
        UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, -1, self.width, 1)];
        subView.clipsToBounds = YES;
        [subView addSubview:lineView];
        
        [self addSubview:subView];
        self.gradientColorLineView = subView;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(lineView.centerX, 0.5)];
        [path addLineToPoint:CGPointMake(lineView.width/2.0f, 0.5)];
        
        CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnimation.path = path.CGPath;
        moveAnimation.duration = 4.0f;
        moveAnimation.repeatCount = HUGE_VALF;
        [lineView.layer addAnimation:moveAnimation forKey:@"GradientColorLineAnimation"];
    }
}
- (void)removeGradientColorLineAnimation{
    if (self.gradientColorLineView) {
        [self.gradientColorLineView.layer removeAnimationForKey:@"GradientColorLineAnimation"];
        [self.gradientColorLineView removeFromSuperview];
        self.gradientColorLineView = nil;
    }
}

//static char kHvmingProgressPopUpView;

//- (ASProgressPopUpView *)progressPopUpView
//{
//    return objc_getAssociatedObject(self, &kHvmingProgressPopUpView);
//}
//- (void)setProgressPopUpView:(ASProgressPopUpView *)progressPopUpView{
//    [self willChangeValueForKey:@"progressPopUpView"];
//    objc_setAssociatedObject(self,
//                             &kHvmingProgressPopUpView,
//                             progressPopUpView,
//                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self didChangeValueForKey:@"progressPopUpView"];
//}
//
//- (void)addProgessPopupView{
//    if (!self.progressPopUpView) {
//        CGRect frame = CGRectMake(0, self.height-2, self.width, 2);
//        self.progressPopUpView = [[ASProgressPopUpView alloc] initWithFrame:frame];
//        self.progressPopUpView.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16];
//        self.progressPopUpView.popUpViewAnimatedColors = @[kCPECShineBlueColor];
//        self.progressPopUpView.popUpViewIsDown = YES;
//        [self.progressPopUpView showPopUpViewAnimated:YES];
//        [self addSubview:self.progressPopUpView];
//    }
//}
//- (void)removeProgessPopupView{
//    if (self.progressPopUpView) {
//        [self.progressPopUpView removeFromSuperview];
//        self.progressPopUpView = nil;
//    }
//}


@end
