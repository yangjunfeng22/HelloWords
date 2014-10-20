//
//  HSWordBookTableViewController.h
//  HSWordsPass
//
//  Created by Lu on 14-10-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSBaseTableViewController.h"


@protocol HSBookSelectDelegate <NSObject>

@optional
- (void)bookSelectWithSelBookCategory:(NSString *)cID selBook:(NSString *)bID version:(NSString *)version;

@end

@interface HSWordBookTableViewController : HSBaseTableViewController

@property (nonatomic, weak) id<HSBookSelectDelegate>delegate;

@end
