//
//  HSWordLearnViewController.h
//  HSWordsPass
//
//  Created by yang on 14-9-9.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>


@class HSWordLearnViewController;
@protocol HSWordLearnVCDelegate <NSObject>

- (void)jumpToNextLevel;

@end


@interface HSWordLearnViewController : UIViewController

@property (nonatomic, weak) id<HSWordLearnVCDelegate> delegate;

@property (nonatomic, assign) NSInteger curIndex;

- (id)initWithModelArray:(NSArray *)modelArray index:(NSInteger)index;

- (void)loadWordLearnViewWithPointWordIndex:(NSInteger)index;

- (void)backJumpToNextLevel:(BOOL)isnextLevel;

@end
