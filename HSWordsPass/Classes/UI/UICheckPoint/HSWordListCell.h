//
//  HSWordListCell.h
//  HSWordsPass
//
//  Created by yang on 14-9-15.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSWordListCell : UITableViewCell
@property (nonatomic, copy) NSString *audio;
@property (nonatomic, copy) NSString *tAudio;
@property (nonatomic, copy) NSString *cpID;

- (void)playVoice:(id)sender;

@end
