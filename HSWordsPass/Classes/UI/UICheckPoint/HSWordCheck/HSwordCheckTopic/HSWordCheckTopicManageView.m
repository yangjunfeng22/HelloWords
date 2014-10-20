//
//  HSWordCheckTopicBaseView.m
//  HSWordsPass
//
//  Created by Lu on 14-9-15.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSWordCheckTopicmanageView.h"


#pragma mark - HSWordCheckTopicCell
@interface HSWordCheckTopicCell()

@end

@implementation HSWordCheckTopicCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        self.selectedBackgroundView.backgroundColor = hsShineBlueColor;
        self.textLabel.highlightedTextColor = [UIColor whiteColor];
        self.height = 60;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 20, 60)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.backgroundColor = kClearColor;
        _titleLabel.highlightedTextColor = kWhiteColor;
        _titleLabel.textColor = hsGlobalWordColor;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(TopicLabel *)resultLabel{
    if (!_resultLabel) {
        CGFloat left = self.titleLabel.right + 15;
        _resultLabel = [[TopicLabel alloc] initWithFrame:CGRectMake(left, 0, self.width - left - 10, 60)];
        _resultLabel.numberOfLines = 1;
        _resultLabel.backgroundColor = kClearColor;
        _resultLabel.highlightedTextColor = kWhiteColor;
        _resultLabel.textColor = hsGlobalWordColor;
        [self addSubview:_resultLabel];
    }
    return _resultLabel;
}



-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.resultLabel.textColor = kWhiteColor;
    }else{
        self.resultLabel.textColor = hsGlobalWordColor;
    }
}

@end






#pragma mark - HSWordCheckTopicManageView
@interface HSWordCheckTopicManageView ()

@property (nonatomic, strong) UIView *line;
@end

@implementation HSWordCheckTopicManageView
{
    NSArray *abcArry;
    HSWordCheckTopicType hSWordCheckTopicType;
    WordModel *currentModel;
    NSArray *resultModelArr;
    
    HSWordCheckTopicBaseView *temptopicView;
}



-(id)initWithHSWordCheckTopicType:(HSWordCheckTopicType)type{

    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        hSWordCheckTopicType = type;
        abcArry = @[@"A",@"B",@"C",@"D"];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)dealloc{
    abcArry = nil;
    resultModelArr = nil;
    currentModel = nil;
}


#pragma mark - action
-(void)loadDataWithModel:(WordModel *)model aneResultModelArr:(NSArray *)modelArr{
    currentModel = model;
    resultModelArr = [NSArray arrayWithArray:modelArr];
    
    if (hSWordCheckTopicType == HSWordCheckTopicTypeChoiceCHWord) {
        temptopicView = [[HSWordCheckTopicChoiceCHWord alloc] init];
    }
    //释意选词语
    else if (hSWordCheckTopicType == HSWordCheckTopicTypeChoiceFromLocal) {
        temptopicView = [[HSWordCheckTopicChoiceFromLocal alloc] init];
    }
    //根据中文选择释义
    else if (hSWordCheckTopicType == HSWordCheckTopicTypeChoiceFromCH) {
        temptopicView = [[HSWordCheckTopicChoiceFromCH alloc] init];
    }
    temptopicView.frame = self.topTopicView.frame;
    [temptopicView loadTopicDataWithWordModel:model];
    
    self.resultTableView.top = temptopicView.bottom;
    self.topTopicView.height = temptopicView.height;
    
    CGFloat tempHeight = kIOS7 ? kNavigationBarHeight + kStatusBarHeight : kNavigationBarHeight;
    self.resultTableView.height = self.bottom - self.topTopicView.bottom - tempHeight;
    
    self.line.bottom = self.topTopicView.bottom;
    [self.topTopicView addSubview:temptopicView];
}


- (void)playWordAudio
{
    if (hSWordCheckTopicType == HSWordCheckTopicTypeChoiceCHWord) {
        HSWordCheckTopicChoiceCHWord *tempVC = (HSWordCheckTopicChoiceCHWord *)temptopicView;
        [tempVC playWordAudio];
    }else if (hSWordCheckTopicType == HSWordCheckTopicTypeChoiceFromLocal){
        [[AudioPlayHelper sharedManager] stopAudio];
    }else if (hSWordCheckTopicType == HSWordCheckTopicTypeChoiceFromCH) {
        HSWordCheckTopicChoiceFromCH *tempVC = (HSWordCheckTopicChoiceFromCH *)temptopicView;
        [tempVC playWordAudio];
    }
}



#pragma mark - 初始化各种控件
-(UIView *)topTopicView{
    if (!_topTopicView) {
        _topTopicView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 172)];
        _topTopicView.backgroundColor = kClearColor;
        [self addSubview:_topTopicView];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, _topTopicView.bottom - 0.5f, self.width, 0.5)];
        _line.backgroundColor = [UIColor lightGrayColor];
        [_topTopicView addSubview:_line];
    }
    return _topTopicView;
}


-(UITableView *)resultTableView{
    if (!_resultTableView) {
        _resultTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topTopicView.bottom, self.width, self.height-self.topTopicView.bottom) style:UITableViewStylePlain];
        _resultTableView.tableFooterView = [[UIView alloc] init];
        _resultTableView.delegate = self;
        _resultTableView.dataSource = self;
        [self addSubview:_resultTableView];
    }
    return _resultTableView;
}


#pragma mark - UITableView代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  4;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"cell";
    
    HSWordCheckTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[HSWordCheckTopicCell alloc] initWithStyle:UITableViewCellStyleDefault
                               reuseIdentifier:CellIdentifier];
        cell.width = self.width;
    }
    WordModel *tempItemModel = [resultModelArr objectAtIndex:indexPath.row];
    
    NSString *resultStr;
    if (hSWordCheckTopicType == HSWordCheckTopicTypeChoiceFromCH) {
        resultStr = tempItemModel.tChinese;
        cell.resultLabel.text = resultStr;
    }else{
        if (kShowTone) {
            BOOL isEmptyPinyin = [[tempItemModel.pinyin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""];
            NSString *strFormt = isEmptyPinyin ? @"%@%@":@"%@^%@";
            
            NSString *strChinese = [[NSString alloc] initWithFormat:strFormt, tempItemModel.chinese, tempItemModel.pinyin];
            
            resultStr = strChinese;
            
            cell.resultLabel.text = resultStr;
            [cell.resultLabel sizeToFit];
            cell.resultLabel.centerY = 30;
            cell.resultLabel.centerX = cell.width/2;
        }else{
            resultStr = tempItemModel.chinese;
            cell.resultLabel.text = resultStr;
            cell.resultLabel.width = 200;
            cell.resultLabel.centerX = cell.width/2;
            cell.resultLabel.textAlignment = NSTextAlignmentCenter;
        }
    }
    cell.titleLabel.text = [abcArry objectAtIndex:indexPath.row];
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WordModel *choiceModelItem = [resultModelArr objectAtIndex:indexPath.row];
    BOOL isTrue = false;
    if (choiceModelItem == currentModel) {
        isTrue = YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(choiceResultItemAndResult:)]) {
        [self.delegate choiceResultItemAndResult:isTrue];
    }
}

@end
