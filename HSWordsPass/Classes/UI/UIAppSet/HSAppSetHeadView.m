//
//  HSAppSetHeadView.m
//  HSWordsPass
//
//  Created by Lu on 14-9-23.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSAppSetHeadView.h"

@interface HSAppSetHeadView ()

@property (nonatomic, strong) UIImageView *companyIconImageView;
@property (nonatomic, strong) UILabel *companyNameLabel;
@property (nonatomic, strong) UILabel *appVersionLabel;
@property (nonatomic, strong) UIView *bottomLine;


@end

@implementation HSAppSetHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.companyIconImageView.image = [UIImage imageNamed:@"hs_appIcon"];
        self.companyNameLabel.text = @"Hello Words";
        self.appVersionLabel.text = [NSString stringWithFormat:@"v %@",kSoftwareVersion];
        self.height = self.bottomLine.bottom;
    }
    return self;
}



#pragma mark - ui

-(UIImageView *)companyIconImageView{
    if (!_companyIconImageView) {
        _companyIconImageView = [[UIImageView alloc] init];
        _companyIconImageView.backgroundColor = kClearColor;
        _companyIconImageView.size = CGSizeMake(60, 60);
        _companyIconImageView.centerX = self.width/2;
        _companyIconImageView.top = 30.0f;
        [self addSubview:_companyIconImageView];
    }
    return _companyIconImageView;
}


-(UILabel *)companyNameLabel{
    if (!_companyNameLabel) {
        _companyNameLabel = [[UILabel alloc] init];
        _companyNameLabel.size = CGSizeMake(self.width, 20);
        _companyNameLabel.top = self.companyIconImageView.bottom + 10;
        _companyNameLabel.centerX = self.companyIconImageView.centerX;
        _companyNameLabel.textAlignment = UITextAlignmentCenter;
        _companyNameLabel.textColor = hsShineBlueColor;
        _companyNameLabel.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:_companyNameLabel];
    }
    return _companyNameLabel;
}


-(UILabel *)appVersionLabel{
    if (!_appVersionLabel) {
        _appVersionLabel = [[UILabel alloc] init];
        _appVersionLabel.size = self.companyNameLabel.size;
        _appVersionLabel.top = self.companyNameLabel.bottom + 10;
        _appVersionLabel.centerX = self.companyNameLabel.centerX;
        _appVersionLabel.textAlignment = self.companyNameLabel.textAlignment;
        _appVersionLabel.textColor = self.companyNameLabel.textColor;
        _appVersionLabel.font = self.companyNameLabel.font;
        [self addSubview:_appVersionLabel];
    }
    return _appVersionLabel;
}


-(UIView *)bottomLine{
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.appVersionLabel.bottom + 20 - 0.5f, self.width, 0.5f)];
        _bottomLine.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_bottomLine];
    }
    return _bottomLine;
}

@end
