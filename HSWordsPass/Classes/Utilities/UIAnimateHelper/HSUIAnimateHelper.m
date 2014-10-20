//
//  HSUIAnimateHelper.m
//  HSWordsPass
//
//  Created by yang on 14-8-29.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSUIAnimateHelper.h"

@implementation HSUIAnimateHelper

+ (CATransition *)pushInFromLeftOfCustomView
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    return animation;
}

+ (CATransition *)pushInFromRightOfCustomView
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    return animation;
}

+ (CATransition *)pushInFromBottomOfCustomView
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:1.2];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromBottom];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    return animation;
}

+ (CATransition *)moveInFromTopOfCustomView
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType: kCATransitionMoveIn];
    [animation setSubtype: kCATransitionFromTop];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    return animation;
}

+ (CATransition *)moveInFromBottomOfCustomView
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.3];
    [animation setType: kCATransitionMoveIn];
    [animation setSubtype: kCATransitionFromBottom];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    return animation;
}

+ (CATransition *)moveOutFromBottomOfCustomView
{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35];
    [animation setType: kCATransitionReveal];
    [animation setSubtype: kCATransitionFromBottom];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    return animation;
}

@end
