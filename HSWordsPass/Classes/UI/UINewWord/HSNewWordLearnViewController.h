//
//  HSNewWordLearnViewController.h
//  HSWordsPass
//
//  Created by Lu on 14-9-25.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSNewWordLearnViewController : UIViewController<UIScrollViewDelegate>


- (id)initWithNewWordModelArray:(NSArray *)wordModelArray index:(NSInteger)index isFromChoice:(BOOL)isFromChoice;


@end
