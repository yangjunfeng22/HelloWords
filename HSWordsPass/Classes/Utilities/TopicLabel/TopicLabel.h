//
//  TopicLabel.h
//  HelloHSK
//
//  Created by yang on 14-6-18.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  为了处理一、二级的拼音问题
 */
@protocol TopicLabelDelegate;

@interface TopicLabel : UILabel

@property (weak, nonatomic)id<TopicLabelDelegate>delegate;

@property (nonatomic, copy) NSString *keyWordHighlightStr;//需要高亮的词
@end

@protocol TopicLabelDelegate <NSObject>

@optional
- (void)topicLabel:(TopicLabel *)label selected:(id)sender;

@end
