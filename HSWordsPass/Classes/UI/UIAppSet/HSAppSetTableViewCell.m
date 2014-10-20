//
//  HSAppSetTableViewCell.m
//  HSWordsPass
//
//  Created by Lu on 14-9-23.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSAppSetTableViewCell.h"

@implementation HSAppSetTableViewCell


-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = hsShineBlueColor;
        self.textLabel.textAlignment = UITextAlignmentCenter;
        
        self.selectedBackgroundView = [[UIView alloc] init];
        self.selectedBackgroundView.backgroundColor = hsShineBlueColor;
        self.textLabel.highlightedTextColor = [UIColor whiteColor];
    }
    return self;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
