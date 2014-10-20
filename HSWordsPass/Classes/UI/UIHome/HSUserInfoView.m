//
//  HSUserInfoView.m
//  HSWordsPass
//
//  Created by yang on 14-9-3.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSUserInfoView.h"
#import "UIImage+Extra.h"
#import "UIImageView+WebCache.h"
#import "BookDAL.h"
#import "BookModel.h"
#import "WordDAL.h"
#import "UserDAL.h"
#import "UserModel.h"
#import "UIView+RoundedCorners.h"

@implementation HSUserInfoView
{
    NSInteger total;
    UIImage *imgHeader;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (HSUserInfoView *)instance
{
    NSArray *loginView = [[NSBundle mainBundle] loadNibNamed:@"HSUserInfoView" owner:nil options:nil];
    return [loginView lastObject];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        imgHeader = [UIImage imageNamed:@"imgHeader.jpg"];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imgvUserHeader.bounds = CGRectMake(0.0f, 0.0f, self.height*0.8f, self.height*0.8f);
    // 加一个圆形遮罩
    [self.imgvUserHeader setRoundedCorners:UIRectCornerAllCorners radius:_imgvUserHeader.size];
    
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //DLOG_CMETHOD;
    
    self.lblUserName.textColor = hsGlobalBlueColor;
    self.lblLearnWord.textColor = hsGlobalBlueColor;
    
    [self.btnLaterStudy setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
    self.btnLaterStudy.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self.btnLaterStudy setTitle:NSLocalizedString(@"继续学习", @"") forState:UIControlStateNormal];
    self.btnLaterStudy.backgroundColor = hsShineBlueColor;
    self.btnLaterStudy.layer.cornerRadius = 3.0f;
}

-(THProgressView *)tHProgressView{
    if (!_tHProgressView) {
        _tHProgressView = [[THProgressView alloc] initWithFrame:CGRectMake(85, 38, 150, 20)];
        _tHProgressView.left = self.lblUserName.left;
        _tHProgressView.width = self.lblLearnWord.right - self.lblUserName.left;
        _tHProgressView.progress = 0;
        _tHProgressView.borderTintColor = kClearColor;
        _tHProgressView.progressBackgroundColor = HEXCOLOR(@"D4D4D4");
        _tHProgressView.progressTintColor = hsShineBlueColor;
        [self addSubview:self.tHProgressView];
    }
    return _tHProgressView;
}

- (IBAction)ibaGoOnLearn:(id)sender
{
    //谷歌
    [CommonHelper googleAnalyticsLogCategory:@"继续学习" action:@"继续学习" event:@"继续学习" pageView:NSStringFromClass([self class])];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(userGoOnLearn:)])
    {
        [self.delegate userGoOnLearn:self];
    }
}

- (void)refreshUserInfo
{
    //[self setNeedsLayout];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UserModel *user = [UserDAL queryUserInfoWithUserID:kUserID];
        
        NSURL *imgUrl = [NSURL URLWithString:user.picture];
        NSString *name = user.name;
        
        BookModel *book = [BookDAL queryWordBookWithCategoryID:kCategoryID bookID:kBookID];
        total = book.wCountValue;
        
        NSInteger count = [WordDAL countOfMasteredWordLearnedRecordWithUserID:kUserID bookID:kBookID];
        NSString *strProgress = total > 0 ? [[NSString alloc] initWithFormat:@"%d/%d", count, total]:@"";
        
        CGFloat progress = total > 0 ?  (float)count/(float)total:0.0f;
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3f animations:^{
                _imgvUserHeader.alpha = 1.0f;
                _lblUserName.alpha = 1.0f;
                _lblLearnWord.alpha = 1.0f;
                _btnLaterStudy.alpha = 1.0f;
            } completion:^(BOOL finished) {
                [_imgvUserHeader setImageWithURL:imgUrl placeholderImage:imgHeader];
                _lblUserName.text = name;
                _lblLearnWord.text = strProgress;
                [self.tHProgressView setProgress:progress animated:NO];
            }];
        });
    });
}

- (void)refreshUserMasteredWords
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger count = [WordDAL countOfMasteredWordLearnedRecordWithUserID:kUserID bookID:kBookID];
        NSString *strProgress = total > 0 ? [[NSString alloc] initWithFormat:@"%d/%d", count, total]:@"";
        
        CGFloat progress = total > 0 ?  (float)count/(float)total:0.0f;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.lblLearnWord.text = strProgress;
            [self.tHProgressView setProgress:progress animated:YES];
        });
    });
}

#pragma mark - Memory Manager
- (void)dealloc
{
    
}

@end
