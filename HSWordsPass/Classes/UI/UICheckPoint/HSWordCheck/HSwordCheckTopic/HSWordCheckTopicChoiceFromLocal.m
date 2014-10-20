//
//  HSWordCheckTopicChoiceFromLocal.m
//  HSWordsPass
//
//  Created by Lu on 14-9-15.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSWordCheckTopicChoiceFromLocal.h"

@interface HSWordCheckTopicChoiceFromLocal ()

@property (nonatomic, strong)UILabel *wordLabel;

@end

@implementation HSWordCheckTopicChoiceFromLocal


#pragma mark - //释意选词语
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


-(void)loadTopicDataWithWordModel:(WordModel *)wordModel{
    self.wordLabel.text = wordModel.tChinese;
}



-(UILabel *)wordLabel{
    if (!_wordLabel) {
        _wordLabel = [[UILabel alloc] init];
        _wordLabel.size = CGSizeMake(300, 100);
        _wordLabel.center = self.center;
        _wordLabel.backgroundColor = kClearColor;
        _wordLabel.textColor = hsShineBlueColor;
        _wordLabel.textAlignment = UITextAlignmentCenter;
        _wordLabel.font = [UIFont systemFontOfSize:21.0f];
        _wordLabel.numberOfLines = 2;
        [self addSubview:_wordLabel];
    }
    return _wordLabel;
}



@end
