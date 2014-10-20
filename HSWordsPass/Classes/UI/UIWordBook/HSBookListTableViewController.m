//
//  HSBookListTableViewController.m
//  HSWordsPass
//
//  Created by Lu on 14-10-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSBookListTableViewController.h"
#import "BookDAL.h"
#import "BookNet.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "BookModel.h"
#import "HSCustomWebImgCell.h"

@interface HSBookListTableViewController ()
{
    dispatch_queue_t queue;
    NSString *strCategoryID;
    BookNet *bookNet;
}


@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;



@end



@implementation HSBookListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        bookNet = [[BookNet alloc] init];
        queue = dispatch_queue_create("com.wordpass.book", NULL);
        [self reloadFetchedResults:nil];
        kAddObserverNotification(self, @selector(reloadFetchedResults:), @"RefetchAllBookListDatabaseData", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    CreatViewControllerImageBarButtonItem([UIImage imageNamed:@"hsGlobal_back_icon.png"], @selector(backBtnClick:), self, YES);
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    bookNet = [[BookNet alloc] init];
    
    [self requestBookData];
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [CommonHelper googleAnalyticsPageView:@"词书等级选择页面"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - action
- (void)backBtnClick:(id)sender
{
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setCategoryID:(NSInteger)categoryID
{
    _categoryID = categoryID;
    strCategoryID = [[NSString alloc] initWithFormat:@"%d", categoryID];
    
}

#pragma mark - Request/Load Data
- (void)requestBookData
{
    __weak HSBookListTableViewController *weakSelf = self;
    dispatch_async(queue, ^{
        NSInteger count = [BookDAL wordBookCountWithCategoryID:strCategoryID];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (count <= 0)
            {
                if (bookNet)
                {
                    __block MBProgressHUD *hud;
                    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeIndeterminate;
                    hud.labelText = NSLocalizedString(@"正在获取关卡信息。。。", @"");
                    hud.removeFromSuperViewOnHide = YES;
                    [bookNet startWordBookRequestWithUserEmail:kEmail categoryID:strCategoryID completion:^(BOOL finished, id result, NSError *error) {
                        [hud hide:YES];
                        [weakSelf loadBookData];
                    }];
                }
                
            }
            else
            {
                [weakSelf loadBookData];
                
                [bookNet startWordBookRequestWithUserEmail:kEmail categoryID:strCategoryID completion:^(BOOL finished, id result, NSError *error) {
                    
                    [weakSelf loadBookData];
                }];
            }
            
        });
    });
}


- (void)loadBookData
{
    [self refreshBookListWithData:nil];
}

#pragma mark - Refresh Manager
- (void)refreshBookListWithData:(NSArray *)data
{
    self.fetchedResultsController = nil;
    kPostNotification(@"RefetchAllBookListDatabaseData", nil, nil);
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger count = [[self.fetchedResultsController sections] count];
	if (count == 0) {
		count = 1;
	}
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger numberOfRows = 0;
    
    if ([[self.fetchedResultsController sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    }
    
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    HSCustomWebImgCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[HSCustomWebImgCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.highlightedTextColor = kWhiteColor;
        cell.textLabel.textColor = hsGlobalWordColor;
        //右侧箭头
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hsGlobal_arrow_blue"]highlightedImage:[UIImage imageNamed:@"hsGlobal_arrow_white"]];
        cell.accessoryView = imageView;
        
        
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = hsShineBlueColor;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookModel *book = (BookModel *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    kSetUDShowTone(book.showToneValue); 
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookListselectedBook:version:)])
    {
        [self.delegate bookListselectedBook:[book.bID integerValue] version:book.version];
    }
    
    //谷歌
    [CommonHelper googleAnalyticsLogCategory:@"书本等级选择" action:self.title event:book.name pageView:NSStringFromClass([self class])];
}


- (void)configureCell:(HSCustomWebImgCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	BookModel *book = (BookModel *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.imgPlacehold = [UIImage imageNamed:@"default_img_52"];
    DLog(@"book.picture===%@",book.picture);
    cell.imagePath = book.picture;
    cell.textLabel.text = book.tName;
}



- (void)reloadFetchedResults:(NSNotification*)note
{
    NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
    
		DLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    if (note) {
        [self.tableView reloadData];
    }
}


- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController == nil) {
        
        self.fetchedResultsController = [BookDAL fetchAllWithDelegate:self categoryID:strCategoryID];
    }
	
	return _fetchedResultsController;
}



- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {

	[self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = self.tableView;
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
	}
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {

	[self.tableView endUpdates];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    kRemoveObserverNotification(self, nil, nil);
    
    dispatch_release(queue);
    
    [bookNet cancelRequest];
    bookNet = nil;
    
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    
    self.fetchedResultsController = nil;
}



@end
