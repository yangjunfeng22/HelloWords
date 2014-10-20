//
//  HSUIAnimateHelper.h
//  HSWordsPass
//
//  Created by yang on 14-8-29.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSUIAnimateHelper : NSObject

+ (CATransition *)pushInFromLeftOfCustomView;

+ (CATransition *)pushInFromRightOfCustomView;

+ (CATransition *)pushInFromBottomOfCustomView;

+ (CATransition *)moveInFromTopOfCustomView;

+ (CATransition *)moveInFromBottomOfCustomView;

+ (CATransition *)moveOutFromBottomOfCustomView;

@end
