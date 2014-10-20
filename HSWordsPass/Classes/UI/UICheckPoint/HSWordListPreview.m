//
//  HSWodListPreview.m
//  HSWordsPass
//
//  Created by yang on 14-9-9.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSWordListPreview.h"
#import "WordDAL.h"
#import "UserDAL.h"
#import "UserLaterStatuModel.h"
#import "CheckPoint_WordModel.h"
#import "WordModel.h"
#import "SentenceModel.h"
#import "HSWordListCell.h"
#import "HSCustomVoiceBtn.h"
#import "HSAppDelegate.h"

@interface HSWordListPreview ()<NSFetchedResultsControllerDelegate>
{
    NSString *curCpID;
}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation HSWordListPreview


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (HSWordListPreview *)instance
{
    NSArray *loginView = [[NSBundle mainBundle] loadNibNamed:@"HSWordListPreview" owner:nil options:nil];
    return [loginView lastObject];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        curCpID = kAppDelegate.curCpID;
        
        [self reloadFetchedResults:nil];
        // observe the app delegate telling us when it's finished asynchronously setting up the persistent store
        kAddObserverNotification(self, @selector(reloadFetchedResults:), @"RefetchAllWordDatabaseData", nil);
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tbvWordList.tableFooterView = [[UIView alloc] init];
    self.tbvWordList.separatorColor = RGBACOLOR(244.0f, 244.0f, 244.0f, 1.0f);
    [self.btnStartCheck setTitleColor:hsGlobalBlueColor forState:UIControlStateNormal];
    [self.btnStartLearn setTitleColor:hsGlobalBlueColor forState:UIControlStateNormal];
    
    [self.btnStartCheck setTitle:NSLocalizedString(@"开始测试", @"") forState:UIControlStateNormal];
    [self.btnStartLearn setTitle:NSLocalizedString(@"开始学习", @"") forState:UIControlStateNormal];
    
}

- (void)refreshWordList
{
    //DLOG_CMETHOD;
    [self clearnCachedData];
    kPostNotification(@"RefetchAllWordDatabaseData", nil, nil);
}

- (void)clearnCachedData
{
    [NSFetchedResultsController deleteCacheWithName:nil];
    self.fetchedResultsController = nil;
}

#pragma mark - Button Action Manager
- (IBAction)ibStartToLearn:(id)sender
{
    [CommonHelper googleAnalyticsLogCategory:@"词汇学习模块操作" action:@"列表页操作" event:@"开始学习" pageView:NSStringFromClass([self class])];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wordListPreView:startToLearn:)])
    {
        [self.delegate wordListPreView:self startToLearn:6];
    }
}

- (IBAction)ibStartToCheck:(id)sender
{
    [CommonHelper googleAnalyticsLogCategory:@"词汇学习模块操作" action:@"列表页操作" event:@"开始测试" pageView:NSStringFromClass([self class])];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wordListPreView:startToCheck:)])
    {
        [self.delegate wordListPreView:self startToCheck:6];
    }
}

#pragma mark - UITableView DataSource/Delegate
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
    HSWordListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[HSWordListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.highlightedTextColor = kWhiteColor;
        
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.highlightedTextColor = kWhiteColor;
        
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        cell.selectedBackgroundView.backgroundColor = hsGlobalBlueColor;
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [CommonHelper googleAnalyticsLogCategory:@"词汇学习模块操作" action:@"列表页操作" event:@"用户选择词汇学习" pageView:NSStringFromClass([self class])];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wordListPreView:selectedWordIndex:)]) {
        [self.delegate wordListPreView:self selectedWordIndex:indexPath.row];
    }
}

- (void)configureCell:(HSWordListCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    WordModel *word = (WordModel *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    //DLog(@"例句: %@", word.sentence.chinese);
    
    NSString *text = [[NSString alloc] initWithFormat:@"%@\n%@", word.pinyin, word.chinese];
    cell.textLabel.text = text;
    [cell.textLabel sizeToFit];
    
    cell.detailTextLabel.text = word.tChinese;
    cell.cpID = curCpID;
    cell.audio = word.audio;
    cell.tAudio = [word tAudio];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark - Fetch Manager
// because the app delegate now loads the NSPersistentStore into the NSPersistentStoreCoordinator asynchronously
// we will see the NSManagedObjectContext set up before any persistent stores are registered
// we will need to fetch again after the persistent store is loaded
- (void)reloadFetchedResults:(NSNotification*)note
{
    NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		/*
		 Replace this implementation with code to handle the error appropriately.
		 
		 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
		 */
		DLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    if (note) {
        [self.tbvWordList reloadData];
    }
}

#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    // Set up the fetched results controller if needed.
    if (_fetchedResultsController == nil) {
        self.fetchedResultsController = [WordDAL fetchAllWithDelegate:self checkPointID:curCpID];
    }
	return _fetchedResultsController;
}

/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[self.tbvWordList beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = self.tbvWordList;
	
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:(HSWordListCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
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
			[self.tbvWordList insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[self.tbvWordList deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[self.tbvWordList endUpdates];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    kRemoveObserverNotification(self, @"RefetchAllWordDatabaseData", nil);
    self.fetchedResultsController = nil;
    
}

@end
