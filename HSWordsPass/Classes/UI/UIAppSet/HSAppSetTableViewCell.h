//
//  HSAppSetTableViewCell.h
//  HSWordsPass
//
//  Created by Lu on 14-9-23.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSAppSetTableViewCell : UITableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, strong) Class subClass;
@property (nonatomic, assign) SEL selector;
@end
