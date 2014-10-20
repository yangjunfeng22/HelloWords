//
//  HSAppSetAboutUSViewController.m
//  HSWordsPass
//
//  Created by Lu on 14-9-23.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSAppSetAboutUSViewController.h"
#import "UINavigationController+Extern.h"

@interface HSAppSetAboutUSViewController ()

@property (nonatomic, strong) UIImageView *appImageView;
@property (nonatomic, strong) UILabel *appNameLabel;
@property (nonatomic, strong) UILabel *appVersionLabel;
@property (nonatomic, strong) UIButton *bottomCompanyUrlBtn;

@end

@implementation HSAppSetAboutUSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    [self.navigationController setNavigationBarBackItemWihtTarget:self image:[UIImage imageNamed:@"hsGlobal_back_icon.png"]];
    
    self.appImageView.image = [UIImage imageNamed:@"hs_appIcon"];
    self.appNameLabel.text = NSLocalizedString(@"词汇通关", @"");
    self.appVersionLabel.text = kSoftwareVersion;
    [self.bottomCompanyUrlBtn setTitle:@"© 2014 hellohsk.com All Rights Reserved" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - action

- (void)linkToHelloHskWebsite:(id)sender
{
    NSURL *url = [[NSURL alloc] initWithString:@"http://www.hellohsk.com"];
    [[UIApplication sharedApplication] openURL:url];
}



#pragma mark - ui

-(UIImageView *)appImageView{
    if (!_appImageView) {
        _appImageView = [[UIImageView alloc] init];
        _appImageView.size = CGSizeMake(100, 100);
        CGFloat top = kIOS7 ? (kNavigationBarHeight + kStatusBarHeight + 20) : 20.0f;
        _appImageView.centerX = self.view.width/2;
        _appImageView.top = top;
        [self.view addSubview:_appImageView];
    }
    return _appImageView;
}


-(UILabel *)appNameLabel{
    if (!_appNameLabel) {
        _appNameLabel = [[UILabel alloc] init];
        _appNameLabel.size = CGSizeMake(100, 30);
        _appNameLabel.centerX = self.appImageView.centerX;
        _appNameLabel.top = self.appImageView.bottom + 10;
        _appNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        _appNameLabel.textAlignment = UITextAlignmentCenter;
        _appNameLabel.textColor = hsShineBlueColor;
        [self.view addSubview:_appNameLabel];
    }
    return _appNameLabel;
}


-(UILabel *)appVersionLabel{
    if (!_appVersionLabel) {
        _appVersionLabel = [[UILabel alloc] init];
        _appVersionLabel.size = CGSizeMake(120, 30);
        _appVersionLabel.centerX = self.appNameLabel.centerX;
        _appVersionLabel.top = self.appNameLabel.bottom;
        _appVersionLabel.textColor = self.appNameLabel.textColor;
        _appVersionLabel.font = self.appNameLabel.font;
        _appVersionLabel.textAlignment = self.appNameLabel.textAlignment;
        [self.view addSubview:_appVersionLabel];
    }
    return _appVersionLabel;
}

-(UIButton *)bottomCompanyUrlBtn{
    if (!_bottomCompanyUrlBtn) {
        _bottomCompanyUrlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomCompanyUrlBtn.backgroundColor = kClearColor;
        _bottomCompanyUrlBtn.size = CGSizeMake(self.view.width, 20);
        CGFloat temp = kIOS7 ? 0 : kNavigationBarHeight;
        _bottomCompanyUrlBtn.bottom = self.view.height - temp - 20;
        _bottomCompanyUrlBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _bottomCompanyUrlBtn.titleLabel.textAlignment = UITextAlignmentCenter;
        [_bottomCompanyUrlBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_bottomCompanyUrlBtn setTitleColor:hsShineBlueColor forState:UIControlStateHighlighted];
        [_bottomCompanyUrlBtn addTarget:self action:@selector(linkToHelloHskWebsite:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_bottomCompanyUrlBtn];
    }
    return _bottomCompanyUrlBtn;
}

@end
