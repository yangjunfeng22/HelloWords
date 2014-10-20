//
//  HSWordLearnView.h
//  HSWordsPass
//
//  Created by Lu on 14-9-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSWordCheckViewController.h"

@class HSWordLearnViewController;
@interface HSWordLearnView : UIView<UIScrollViewDelegate,HSWordCheckDelegate>


@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, assign) NSInteger currentPageNum;//当前页面
@property (nonatomic, assign)NSInteger willPageNum;//将要滑动至的页面

- (void) loadDataWithModelArray:(NSArray *)modelArray;

//却换单词
- (BOOL) switchWordViewIsNext:(BOOL)isNext;


@end
