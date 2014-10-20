//
//  HSWordCheckTopicBaseView.m
//  HSWordsPass
//
//  Created by Lu on 14-9-16.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSWordCheckTopicBaseView.h"

@implementation HSWordCheckTopicBaseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)loadTopicDataWithWordModel:(WordModel *)wordModel
{
    //供继承类改写
}

@end
