//
//  HSRegisterAreaView.m
//  HelloHSK
//
//  Created by yang on 14-3-6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSRegisterAreaView.h"

@implementation HSRegisterAreaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (HSRegisterAreaView *)instance
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HSRegisterAreaView" owner:nil options:nil];
    return [nibs lastObject];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    [_lbEmail removeFromSuperview];
    [_lbPassword removeFromSuperview];
    [_lbRepassword removeFromSuperview];
    
    self.lbEmail = nil;
    self.lbPassword = nil;
    self.lbRepassword = nil;
    
    [_tfEmail removeFromSuperview];
    [_tfPassword removeFromSuperview];
    [_tfRepassword removeFromSuperview];
    
    self.tfEmail = nil;
    self.tfPassword = nil;
    self.tfRepassword = nil;
}

@end
