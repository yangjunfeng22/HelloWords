//
//  HSShareViewController.m
//  HSWordsPass
//
//  Created by Lu on 14-9-24.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSShareViewController.h"
#import "UINavigationController+Extern.h"

@interface HSShareViewController ()

@property (nonatomic, strong) UIButton *shareFacebookBtn;
@property (nonatomic, strong) UIButton *shareSinaBtn;
@property (nonatomic, strong) UIButton *shareTwitterBtn;

@end

@implementation HSShareViewController

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
    
    [self.shareTwitterBtn setBackgroundImage:[UIImage imageNamed:@"shareTwitter"] forState:UIControlStateNormal];
    [self.shareFacebookBtn setBackgroundImage:[UIImage imageNamed:@"shareFacebook"] forState:UIControlStateNormal];
    [self.shareSinaBtn setBackgroundImage:[UIImage imageNamed:@"shareSina"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - action
- (void)shareTwitterBtnClick:(id)sender
{
    DLog(@"shareTwitterBtnClick");
}

- (void)shareSinaBtnClick:(id)sender
{
    DLog(@"shareSinaBtnClick");
}

- (void)shareFacebookBtnClick:(id)sender
{
    DLog(@"shareFacebookBtnClick");
}

#pragma mark - ui
-(UIButton *)shareTwitterBtn{
    if (!_shareTwitterBtn) {
        _shareTwitterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareTwitterBtn.size = CGSizeMake(202, 32);
        CGFloat top = kIOS7 ? (kNavigationBarHeight + kStatusBarHeight + 100) : 100;
        _shareTwitterBtn.top = top;
        _shareTwitterBtn.centerX = self.view.width/2;
        _shareTwitterBtn.backgroundColor = kClearColor;
        [_shareTwitterBtn addTarget:self action:@selector(shareTwitterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_shareTwitterBtn];
    }
    return _shareTwitterBtn;
}


-(UIButton *)shareFacebookBtn{
    if (!_shareFacebookBtn) {
        _shareFacebookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareFacebookBtn.size = CGSizeMake(202, 32);
        _shareFacebookBtn.top = self.shareTwitterBtn.bottom + 30;
        _shareFacebookBtn.centerX = self.shareTwitterBtn.centerX;
        _shareFacebookBtn.backgroundColor = kClearColor;
        [_shareFacebookBtn addTarget:self action:@selector(shareFacebookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_shareFacebookBtn];
    }
    return _shareFacebookBtn;
}

-(UIButton *)shareSinaBtn{
    if (!_shareSinaBtn) {
        _shareSinaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareSinaBtn.size = CGSizeMake(202, 32);
        _shareSinaBtn.top = self.shareFacebookBtn.bottom + 30;
        _shareSinaBtn.centerX = self.shareTwitterBtn.centerX;
        _shareSinaBtn.backgroundColor = kClearColor;
        [_shareSinaBtn addTarget:self action:@selector(shareSinaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_shareSinaBtn];
    }
    return _shareSinaBtn;
}



@end
