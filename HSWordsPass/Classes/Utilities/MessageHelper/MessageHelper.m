//
//  MessageHelper.m
//  HSWordsPass
//
//  Created by yang on 14-9-1.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "MessageHelper.h"

@implementation MessageHelper

+ (void)showMessage:(NSString *)aMessage view:(UIView *)aView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:aMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

@end
