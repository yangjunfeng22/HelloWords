
//
//  HSWordCheckTopicCardView.m
//  HSWordsPass
//
//  Created by Lu on 14-9-12.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSWordCheckTopicCardViewCon.h"
#import "WordModel.h"
#import "UINavigationController+Extern.h"
#import "HSLearnCircleProgressView.h"



@interface HSWordCheckTopicBtn()

@property (nonatomic, strong)HSLearnCircleProgressView *circleProView;

@end

@implementation HSWordCheckTopicBtn



-(void)setIsChoice:(BOOL)isChoice{
    if (isChoice) {
        self.circleProView.isFill = YES;
        self.circleProView.groundTintColor = hsShineBlueColor;
        [self.topicBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    }else{
        self.circleProView.isFill = NO;
        _circleProView.groundTintColor = HEXCOLOR(@"ababab");
        [self.topicBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
    }
}

-(UIButton *)topicBtn{
    if (!_topicBtn) {
        _topicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topicBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _topicBtn.backgroundColor = kClearColor;
        _topicBtn.frame = self.bounds;
        [self addSubview:_topicBtn];
    }
    return _topicBtn;
}


-(HSLearnCircleProgressView *)circleProView{

    if (!_circleProView) {
        _circleProView = [[HSLearnCircleProgressView alloc] initWithFrame:self.bounds];
        _circleProView.backgroundColor = [UIColor clearColor];
        _circleProView.fillRadiusPx = 3.0f;
        _circleProView.isFill = NO;
        _circleProView.userInteractionEnabled = NO;
        [self insertSubview:_circleProView belowSubview:self.topicBtn];
    }
    return _circleProView;
}

@end





#define lineNumber 5

@interface HSWordCheckTopicCardViewCon ()

@property (nonatomic, assign)NSInteger countNum;

@end


@implementation HSWordCheckTopicCardViewCon


-(id)initWithTopicModelCount:(NSInteger)countNum{
    self = [super init];
    if (self) {
        self.countNum = countNum;
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self loadBtn];
//        });
//    });
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *imgNavBack = [UIImage imageNamed:@"hsGlobal_back_icon.png"];
    [self.navigationController setPresentNavigationBarBackItemWihtTarget:self image:imgNavBack];
    self.title = NSLocalizedString(@"答题卡", @"");
    
    self.submitBtn.backgroundColor = kClearColor;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDataWithAllTopicArray:_topicModelArray];
}




-(void)loadDataWithAllTopicArray:(NSArray *)topicModelArray{
    _topicModelArray = topicModelArray;
    
    
    CGFloat topFloat = kIOS7 ? 60 : (60 - kNavigationBarHeight);
    CGFloat ySpace = 60;
    CGFloat xSpace = self.view.width/(lineNumber+1);
    
    for (int i = 0; i < _topicModelArray.count; i++) {
        WordModel *model = (WordModel *)[_topicModelArray objectAtIndex:i];
        HSWordCheckTopicBtn *btn = (HSWordCheckTopicBtn *)[self.view viewWithTag:(kWordCheckTopicCardBtnTag + i)];
        if (!btn) {
            btn = [[HSWordCheckTopicBtn alloc] init];
            btn.size = CGSizeMake(45, 45);
            [btn.topicBtn setTitle:[NSString stringWithFormat:@"%i",i+1] forState:UIControlStateNormal];
            btn.tag = kWordCheckTopicCardBtnTag + i;
            
            NSInteger line = i/lineNumber;//第几行
            btn.centerX = xSpace*(i%lineNumber+1);
            btn.centerY = (line+1) * ySpace + topFloat;
            [btn.topicBtn addTarget:self action:@selector(jumpToTargetTopic:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
        }
        DLog(@"%i",model.practicResult);
        if (model.practicResult == kPracticeResultTypeDefault)
        {
            btn.isChoice = NO;
        }else{
            btn.isChoice = YES;
        }
    }
}


#pragma mark - action
- (void)jumpToTargetTopic:(UIButton *)btn{
    if (self.parentViewController) {
        [self.parentViewController dismissViewControllerAnimated:YES completion:^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToTargetTopicPage:)]) {
                [self.delegate jumpToTargetTopicPage:(btn.superview.tag - kWordCheckTopicCardBtnTag)];
            }
        }];
    }
    else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(jumpToTargetTopicPage:)]) {
            [self.delegate jumpToTargetTopicPage:(btn.superview.tag - kWordCheckTopicCardBtnTag)];
        }
    }
}


#pragma mark - 初始化ui
-(UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.height = 49.0f;
        _submitBtn.bottom = self.view.bottom;
        _submitBtn.width = self.view.width;
        if (!kIOS7) {
            _submitBtn.top =  self.view.height - 49 - kNavigationBarHeight;
        }
        _submitBtn.backgroundColor = kClearColor;
        
        NSString *title = NSLocalizedString(@"交卷并查看结果", @"");
        [_submitBtn setTitle:title forState:UIControlStateNormal];
        [_submitBtn setTitleColor:hsShineBlueColor forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitAndGoToReportView:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_submitBtn];
        
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _submitBtn.width, 1)];
        lineView.backgroundColor = hsGlobalLineColor;
        [_submitBtn addSubview:lineView];
    }
    return _submitBtn;
}

- (void)submitAndGoToReportView:(id)send
{
    BOOL isFinishAllTopic = YES;
    for (int i = 0; i < _topicModelArray.count; i++) {
        WordModel *model = [_topicModelArray objectAtIndex:i];
        if (model.practicResult == kPracticeResultTypeDefault) {
            isFinishAllTopic = false;
            break;
        }
    }
    
    NSString *title = isFinishAllTopic ? NSLocalizedString(@"确定交卷吗？",@"") : NSLocalizedString(@"您还有题目未做,确定交卷吗?",@"");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:title
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"取消", @"")
                                          otherButtonTitles:NSLocalizedString(@"确定", @""), nil];
    [alert show];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (self.parentViewController) {
            [self.parentViewController dismissViewControllerAnimated:YES completion:^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(submitAndGoToReportView)]) {
                    [self.delegate submitAndGoToReportView];
                }
            }];
        }
        else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(submitAndGoToReportView)]) {
                [self.delegate submitAndGoToReportView];
            }
        }
    }
}
@end
