//
//  HSBaseTableViewController.h
//  HSWordsPass
//
//  Created by Lu on 14-10-16.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSBaseTableViewController : UITableViewController

/*!
 *  指向VC的内容View
 */
@property (nonatomic, strong) UIView *baseContentView;

//添加一个没有数据的背景图片
- (void)addOrRemoveNoDataBackBtn:(NSInteger)count;

//点击屏幕重新加载数据  子类需要继承
-(void)againToObtain;

@end
