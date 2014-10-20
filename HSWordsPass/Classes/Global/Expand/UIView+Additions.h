//
//  UIView+Additions.h
//  I8
//
//  Created by hvming on 13-4-25.
//  Copyright (c) 2013年 hvming. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ASProgressPopUpView;

@interface UIView (Additions)

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;

/**
 * Return the x coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenX;

/**
 * Return the y coordinate on the screen.
 */
@property (nonatomic, readonly) CGFloat ttScreenY;

/**
 * Return the x coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewX;

/**
 * Return the y coordinate on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGFloat screenViewY;

/**
 * Return the view frame on the screen, taking into account scroll views.
 */
@property (nonatomic, readonly) CGRect screenFrame;

/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize size;

/**
 * Finds the first descendant view (including this view) that is a member of a particular class.
 */
- (UIView*)descendantOrSelfWithClass:(Class)cls;

/**
 * Finds the first ancestor view (including this view) that is a member of a particular class.
 */
- (UIView*)ancestorOrSelfWithClass:(Class)cls;

/**
 * Removes all subviews.
 */
- (void)removeAllSubviews;

/**
 * Calculates the offset of this view from another view in screen coordinates.
 *
 * otherView should be a parent view of this view.
 */
- (CGPoint)offsetFromView:(UIView*)otherView;

/**
 * Calculates the frame of this view with parts that intersect with the keyboard subtracted.
 *
 * If the keyboard is not showing, this will simply return the normal frame.
 */
- (CGRect)frameWithKeyboardSubtracted:(CGFloat)plusHeight;

/**
 * Shows the view in a window at the bottom of the screen.
 *
 * This will send a notification pretending that a keyboard is about to appear so that
 * observers who adjust their layout for the keyboard will also adjust for this view.
 */
- (void)presentAsKeyboardInView:(UIView*)containingView;

/**
 * Hides a view that was showing in a window at the bottom of the screen (via presentAsKeyboard).
 *
 * This will send a notification pretending that a keyboard is about to disappear so that
 * observers who adjust their layout for the keyboard will also adjust for this view.
 */
- (void)dismissAsKeyboard:(BOOL)animated;


//找到view所在的viewController
- (UIViewController *) firstViewController;
- (id) traverseResponderChainForViewController:(Class)clazz;


//绘制view的边角弧度
- (id)drawViewCornerWithRadius:(CGFloat)radius;
- (id)drawViewCorner:(CGSize)radii;
- (id)drawViewCorner:(CGSize)radii withCorner:(UIRectCorner) corners;

/*!
 *  添加 / 移除 梯度颜色的动画边界
 */
- (void)addGradientColorLineAnimation;
- (void)removeGradientColorLineAnimation;

/*!
 *  添加一个进度条
 */
//@property (nonatomic, readonly) ASProgressPopUpView *progressPopUpView;
//- (void)addProgessPopupView;
//- (void)removeProgessPopupView;

@end
