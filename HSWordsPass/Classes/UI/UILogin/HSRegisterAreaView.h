//
//  HSRegisterAreaView.h
//  HelloHSK
//
//  Created by yang on 14-3-6.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSRegisterAreaView : UIView
@property (weak, nonatomic) IBOutlet UILabel *lbEmail;
@property (weak, nonatomic) IBOutlet UILabel *lbPassword;
@property (weak, nonatomic) IBOutlet UILabel *lbRepassword;
@property (weak, nonatomic) IBOutlet UITextField *tfEmail;
@property (weak, nonatomic) IBOutlet UITextField *tfPassword;
@property (weak, nonatomic) IBOutlet UITextField *tfRepassword;

+ (HSRegisterAreaView *)instance;

@end
