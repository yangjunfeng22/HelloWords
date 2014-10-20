//
//  HSBookListTableViewController.h
//  HSWordsPass
//
//  Created by Lu on 14-10-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSBookListViewDelegate <NSObject>
@optional
- (void)bookListselectedBook:(NSInteger)bID version:(NSString *)version;

@end


@interface HSBookListTableViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (nonatomic, weak)id<HSBookListViewDelegate>delegate;
@property (nonatomic) NSInteger categoryID;

@end
