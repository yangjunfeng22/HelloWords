//
//  HSWordCheckReportView.m
//  HSWordsPass
//
//  Created by Lu on 14-9-11.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSWordCheckReportView.h"
#import "HSLearnCircleProgressView.h"

#pragma mark - ---------wordCell
@interface wordCell ()

@property (nonatomic, strong) UIButton *editWordBtn;
@property (nonatomic, strong) UIImageView *statusImgView;//正确或者错误的红蓝色圈圈
@property (nonatomic, strong) UILabel *labelCH;//中文
@property (nonatomic, strong) UILabel *labelEn;//英文

@end

@implementation wordCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}


-(void)loadData{
    
    self.labelCH.text = @"您好啊";
    self.labelEn.text = @"ouihadoihoihowqeh foh ";
    [self.editWordBtn setImage:[UIImage imageNamed:@"hsGlobal_add_Words"] forState:UIControlStateNormal];
    self.statusImgView.image = [UIImage imageNamed:@"hsWordCheck_red_circle"];
    

}

#pragma mark - action
- (void)editWordBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(wordCellEditWordBtnClick)]) {
        [self.delegate wordCellEditWordBtnClick];
    }
}


#pragma mark - 初始化控件
-(UIButton *)editWordBtn{
    if (!_editWordBtn) {
        _editWordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _editWordBtn.backgroundColor = kClearColor;
        _editWordBtn.frame = CGRectMake(self.width - 40, 0, 22, 22);
        _editWordBtn.centerY = 30;
        [_editWordBtn addTarget:self action:@selector(editWordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_editWordBtn];
    }
    return _editWordBtn;
}

-(UIImageView *)statusImgView{
    if (!_statusImgView) {
        _statusImgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 14, 14)];
        _statusImgView.centerY = 30;
        _statusImgView.backgroundColor = kClearColor;
        [self addSubview:_statusImgView];
    }
    return _statusImgView;
}


-(UILabel *)labelCH{
    if (!_labelCH) {
        _labelCH = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 20)];
        _labelCH.backgroundColor = kClearColor;
        _labelEn.textAlignment = NSTextAlignmentLeft;
        _labelCH.textColor = hsShineBlueColor;
        _labelCH.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:_labelCH];
    }
    return _labelCH;
}

-(UILabel *)labelEn{
    if (!_labelEn) {
        _labelEn = [[UILabel alloc] initWithFrame:CGRectMake(self.labelCH.left, 30, self.labelCH.width, self.labelCH.height)];
        _labelEn.backgroundColor = kClearColor;
        _labelEn.textAlignment = NSTextAlignmentLeft;
        _labelEn.textColor = self.labelCH.textColor;
        _labelEn.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:_labelEn];
    }
    return _labelEn;
}




@end




#pragma mark - ------------HSWordCheckReportView

#define bottomToolViewHeight 45

@interface HSWordCheckReportView ()

@property (nonatomic, strong) UIView *topResultView;
@property (nonatomic, strong) UITableView *wordsTableView;

@property (nonatomic, strong) UIView *bottomToolView;
@property (nonatomic, strong) UIButton *reTestBtn;
@property (nonatomic, strong) UIButton *nextLevelBtn;


@end



@implementation HSWordCheckReportView
{
    NSInteger trueNum;//对
    NSInteger falseNum;//错误
    
    CGFloat percent;//正确率
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


-(void)loadData{
    
#warning 临时数据
    trueNum = 3;
    falseNum = 1;
    percent = (CGFloat)trueNum/(CGFloat)(trueNum + falseNum);
    
    //显示测试结果view
    [self showResultData];
    
    
    
    self.wordsTableView.backgroundColor = kClearColor;
    self.reTestBtn.backgroundColor = kClearColor;
    
#warning 访问接口判断有无开启下一关
    [self judgeNextLevelBtnHidden];
}


- (void)judgeNextLevelBtnHidden{
    //如果下一关已开启 或者 本关得分不是100分  则显示下一关按钮

    BOOL hasNextLeave = NO;
    if (hasNextLeave || percent == 1) {
        [self setNextLevelBtnStatus];
    }
}


#pragma mark - 初始化各种页面及控件
-(UIView *)topResultView{
    if (!_topResultView) {
        _topResultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 130)];
        _topResultView.backgroundColor = kClearColor;
        [self addSubview:_topResultView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5f)];
        line.bottom = _topResultView.bottom;
        line.backgroundColor = [UIColor lightGrayColor];
        [_topResultView addSubview:line];
    }
    return _topResultView;
}


-(UITableView *)wordsTableView{
    if (!_wordsTableView) {
        _wordsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topResultView.bottom, self.width,self.bottomToolView.top - self.topResultView.bottom) style:UITableViewStylePlain];
        _wordsTableView.backgroundColor = [UIColor clearColor];
        _wordsTableView.delegate = self;
        _wordsTableView.dataSource = self;
        _wordsTableView.tableFooterView = [[UIView alloc] init];
        [self addSubview:_wordsTableView];
    }
    return _wordsTableView;
}


- (void)showResultData{
    //蓝色圆点
    UIImageView *blueCircleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 40, 14, 14)];
    blueCircleImgView.backgroundColor = [UIColor clearColor];
    blueCircleImgView.image = [UIImage imageNamed:@"hsWordCheck_blue_circle"];
    [self.topResultView addSubview:blueCircleImgView];
    
    //对的label
    UILabel *trueLabel = [[UILabel alloc] initWithFrame:CGRectMake(blueCircleImgView.right + 10, 0, 80, 20)];
    trueLabel.centerY = blueCircleImgView.centerY;
    trueLabel.backgroundColor = [UIColor clearColor];
    trueLabel.textColor = [UIColor grayColor];
    trueLabel.font = [UIFont systemFontOfSize:18.0f];
    trueLabel.text = [NSString stringWithFormat:@"对:  %i题",trueNum];
    [self.topResultView addSubview:trueLabel];
    
    //红色圆点
    UIImageView *redCircleImgView = [[UIImageView alloc] initWithFrame:blueCircleImgView.frame];
    redCircleImgView.backgroundColor = [UIColor clearColor];
    redCircleImgView.top = blueCircleImgView.bottom + 20;
    redCircleImgView.image = [UIImage imageNamed:@"hsWordCheck_red_circle"];
    [self.topResultView addSubview:redCircleImgView];
    
    //错的label
    UILabel *falseLabel = [[UILabel alloc] initWithFrame:trueLabel.frame];
    falseLabel.centerY = redCircleImgView.centerY;
    falseLabel.backgroundColor = trueLabel.backgroundColor;
    falseLabel.textColor = trueLabel.textColor;
    falseLabel.font = trueLabel.font;
    falseLabel.text = [NSString stringWithFormat:@"错:  %i题",falseNum];
    [self.topResultView addSubview:falseLabel];
    
    //进度圈圈
    HSLearnCircleProgressView  *circleProView = [[HSLearnCircleProgressView alloc] initWithFrame:CGRectMake(trueLabel.right+40, 20, 80, 80)];
    circleProView.backgroundColor = [UIColor clearColor];
    circleProView.animationDuration = 0.3f;
    circleProView.fillRadiusPx = 3.0f;
    circleProView.progressTintColor = hsShineBlueColor;
    circleProView.groundTintColor = [UIColor redColor];
    circleProView.userInteractionEnabled = NO;
    [circleProView setCurrent:percent animated:YES];
    [self.topResultView addSubview:circleProView];
    
    //进度label
    UILabel *progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    progressLabel.center = circleProView.center;
    progressLabel.backgroundColor = [UIColor clearColor];
    progressLabel.textAlignment = UITextAlignmentCenter;
    NSString *progressStr = [NSString stringWithFormat:@"%i",(int)(round(percent * 100))];
    progressLabel.text = [progressStr stringByAppendingString:@"%"];
    progressLabel.font = [UIFont systemFontOfSize:20.0f];
    progressLabel.textColor = trueLabel.textColor;
    [self.topResultView addSubview:progressLabel];
}


-(UIView *)bottomToolView{
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - bottomToolViewHeight-kNavigationBarHeight-kStatusBarHeight, self.width, bottomToolViewHeight)];
        _bottomToolView.backgroundColor = kClearColor;
        [self addSubview:_bottomToolView];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [_bottomToolView addSubview:line];
    }
    return _bottomToolView;
}

-(UIButton *)reTestBtn{
    if (!_reTestBtn) {
        _reTestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reTestBtn.frame = CGRectMake(0, 0, self.bottomToolView.width, self.bottomToolView.height);
        _reTestBtn.backgroundColor = kClearColor;
        [_reTestBtn setTitle:@"重新测试" forState:UIControlStateNormal];
        [_reTestBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_reTestBtn setTitleColor:hsShineBlueColor forState:UIControlStateHighlighted];
        [self.bottomToolView addSubview:_reTestBtn];
    }
    return _reTestBtn;
}

-(UIButton *)setNextLevelBtnStatus{
    if (!_nextLevelBtn) {
        //将重新开始按钮宽度缩短
        self.reTestBtn.width = self.bottomToolView.width/2;
        
        _nextLevelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextLevelBtn.frame = self.reTestBtn.frame;
        _nextLevelBtn.left = self.reTestBtn.right;
        _nextLevelBtn.backgroundColor = kClearColor;
        [_nextLevelBtn setTitle:@"下一关" forState:UIControlStateNormal];
        [_nextLevelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_nextLevelBtn setTitleColor:hsShineBlueColor forState:UIControlStateHighlighted];
        [self.bottomToolView addSubview:_nextLevelBtn];
        
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(_nextLevelBtn.left, 0, 0.5f, self.bottomToolView.height-15)];
        verticalLine.centerY = self.bottomToolView.height/2;
        verticalLine.backgroundColor = [UIColor lightGrayColor];
        [_bottomToolView addSubview:verticalLine];
    }
    return _reTestBtn;
}



#pragma mark - table代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *CellIdentifier = @"cell";
    
    wordCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[wordCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        [cell loadData];
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


#pragma mark - cell代理
-(void)wordCellEditWordBtnClick{
    DLog(@"加入生词本");
}
@end
