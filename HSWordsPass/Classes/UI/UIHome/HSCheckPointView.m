//
//  HSCheckPointView.m
//  HSWordsPass
//
//  Created by yang on 14-9-3.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSCheckPointView.h"
#import "HSCheckPointCell.h"

#import "WordDAL.h"
#import "WordNet.h"

#import "UserDAL.h"
#import "UserLaterStatuModel.h"

#import "CheckPointDAL.h"
#import "CheckPointModel.h"
#import "CheckPointNet.h"
#import "MessageHelper.h"

#import "CheckPointModel.h"
#import "UIView+Additions.h"
#import "CheckPointProgressModel.h"

#import "WordLearnInfoModel.h"

#import "MBProgressHUD.h"

#define kPointLeft 30.0f
#define kPointTop 20.0f
#define kPointDistance 36.25f
#define kPointCountPerRow 3

@interface HSCheckPointView ()<DownloadDelegate, HSCheckPointCellDelegate>
{
    BOOL isScrolled;
    NSInteger curCpTag;
    NSInteger totalCount;
    NSInteger totalRow;
    NSMutableIndexSet *indexSet;
    
    NSArray *arrCheckPoint;
    
    UIImage *imgUnLocked;
    UIImage *imgLocked;
    UIImage *imgCpLink;
    
    UIScrollView *svCheckPoint;
    
    WordNet *wordNet;
}

@end

@implementation HSCheckPointView
{
    CheckPointNet *checkPointNet;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}

+ (HSCheckPointView *)instance
{
    NSArray *loginView = [[NSBundle mainBundle] loadNibNamed:@"HSCheckPointView" owner:nil options:nil];
    return [loginView lastObject];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        isScrolled = NO;
        totalCount = 0;
        
        indexSet = [[NSMutableIndexSet alloc] init];
        
        checkPointNet = [[CheckPointNet alloc] init];
        checkPointNet.delegate = self;
        
        wordNet = [[WordNet alloc] init];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tbvCheckPoint.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)synchronousAllCheckPointProgress
{
    // 同步本关进度
#ifdef DEBUG
    CFTimeInterval start = CFAbsoluteTimeGetCurrent();
#endif
    __weak HSCheckPointView *weakSelf = self;
    [checkPointNet startSynchronousCheckPointProgressWithEmail:kEmail bookID:kBookID records:@"" completion:^(BOOL finished, id result, NSError *error) {
        // 同步完，刷新本关进度。
#ifdef DEBUG
        CFTimeInterval end = CFAbsoluteTimeGetCurrent();
#endif
        DLog(@"同步用时: %f", end-start);
        [weakSelf refreshCheckPointProgress];
        
        NSArray *arrProgress = [CheckPointDAL queryAllCheckPointProgressWithUserID:kUserID bookID:kBookID];
        [arrProgress enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CheckPointProgressModel *cpProgress = (CheckPointProgressModel *)obj;
            [weakSelf syncWordLearnRecordsWithCheckPointID:cpProgress.cpID];
        }];
        
        if (!isScrolled)
        {
            // 自动滚动到最后一个解锁的地方。
            [weakSelf scrollToLastUnlockedCheckpointDelay:0.0f];
        }
    }];
}

- (void)syncWordLearnRecordsWithCheckPointID:(NSString *)cpID
{
    __weak HSCheckPointView *weakSelf = self;
    __block NSMutableString *strRecords = [[NSMutableString alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *arrWordRecord = [WordDAL queryWordLearnRecordInfosWithUserID:kUserID checkPointID:cpID];
        for (WordLearnInfoModel *wordLearn in arrWordRecord)
        {
            @autoreleasepool
            {
                int rightTimes = wordLearn.rightsValue;
                int wrongTimes = wordLearn.wrongsValue;
                int status = wordLearn.statusValue;
                NSString *strRecord = [[NSString alloc] initWithFormat:@"%@|%@|%d|%d|%d,", wordLearn.cpID, wordLearn.wID, rightTimes, wrongTimes, status];
                [strRecords appendString:strRecord];
            }
        }
        
        if ([strRecords length] > 0) {
            [strRecords setString:[strRecords substringToIndex:[strRecords length]-1]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //DLog(@"同步的学习记录: %@", strRecords);
            [wordNet startWordLearnedRecordsRequestWithUserEmail:kEmail checkPointID:cpID bookID:kBookID categoryID:kCategoryID records:strRecords completion:^(BOOL finished, id result, NSError *error) {
                [weakSelf synchronousCheckPointProgress:cpID];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(checkPointView:syncWordLearnRecordsFinished:)])
                {
                    [weakSelf.delegate checkPointView:weakSelf syncWordLearnRecordsFinished:cpID];
                }
            }];
        });
    });
}

- (void)synchronousCheckPointProgress:(NSString *)cpID
{
    // 同步本关进度
    __weak HSCheckPointView *weakSelf = self;
    [checkPointNet startSynchronousCheckPointProgressWithEmail:kEmail bookID:kBookID records:cpID completion:^(BOOL finished, id result, NSError *error) {
        [weakSelf reloadVisibleCheckPoint];
        [weakSelf refreshCheckPointProgress];
    }];
}

- (void)reloadCheckPoint
{
    NSInteger cpCount = [CheckPointDAL checkPointCountWithBookID:kBookID];
    
    if (cpCount > 0)
    {
        // 显示本地的所有的关卡
        [self loadCheckPointDataWithBookID:kBookID];
    }
    else
    {
        // 请求服务器所有关卡
        [self requestCheckPointsWithBookID:kBookID];
    }
}

- (void)reloadVisibleCheckPoint
{
    NSArray *arrCell = [self.tbvCheckPoint visibleCells];
    for (HSCheckPointCell *cell in arrCell)
    {
        NSIndexPath *indexPath = [self.tbvCheckPoint indexPathForCell:cell];
        [self configureCell:cell atIndexPath:indexPath];
    }
}

#pragma mark - 刷新
- (void)refreshCheckPointProgress
{
    kPostNotification(kRefreshCheckPointProgressNotification, nil, nil);
}

- (void)refreshCheckPointProgressWithCheckPointID:(NSString *)cpID
{
    NSDictionary *dicUserInfo = [NSDictionary dictionaryWithObject:cpID forKey:@"CheckPointID"];
    kPostNotification(kRefreshCheckPointProgressNotification, nil, dicUserInfo);
}

#pragma mark - 数据的获取及显示
- (void)loadCheckPointDataWithBookID:(NSString *)bID
{
    isScrolled = NO;
    arrCheckPoint = [CheckPointDAL queryCheckPointsWithBookID:bID];
    totalCount = [arrCheckPoint count];
    totalRow = totalCount/kPointCountPerRow + (totalCount % kPointCountPerRow == 0 ? 0:1);
    [self.tbvCheckPoint reloadData];
    // 同步进度
    [self synchronousAllCheckPointProgress];
    
    if (!isScrolled){
        // 自动滚动到最后一个解锁的地方。
        [self scrollToLastUnlockedCheckpointDelay:1.8f];
    }
}

#pragma mark - 网络数据请求
- (void)requestCheckPointsWithBookID:(NSString *)bID
{
    [MBProgressHUD hideAllHUDsForView:self animated:NO];
    __block MBProgressHUD *hud;
    hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText = NSLocalizedString(@"正在获取关卡信息。。。", @"");
    hud.removeFromSuperViewOnHide = YES;
    __weak HSCheckPointView *weakSelf = self;
    [checkPointNet startCheckPointRequestWithUserEmail:kEmail bookID:bID completion:^(BOOL finished, id result, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        [weakSelf loadCheckPointDataWithBookID:bID];
    }];
}

#pragma mark - 数据下载
- (void)downloadCheckPointMediaDataWithCheckPointID:(NSString *)cpID
{
    [checkPointNet downloadCheckPointDataWithEmail:kEmail bookID:kBookID checkPointID:cpID completion:^(BOOL finished, id result, NSError *error) {
        
        if (error.code != 0)
        {
            [MessageHelper showMessage:error.domain view:self];
        }
    }];
}

#pragma mark - Download Delegate
- (void)downloadProgress:(float)progress
{
    
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //[self reloadVisibleCheckPoint];
    [self refreshCheckPointProgress];
    /*
    NSArray *arrCell = [self.tbvCheckPoint visibleCells];
    for (HSCheckPointCell *cell in arrCell)
    {
        NSIndexPath *indexPath = [self.tbvCheckPoint indexPathForCell:cell];
        [self configureCell:cell atIndexPath:indexPath];
    }
     */
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        //[self reloadVisibleCheckPoint];
        [self refreshCheckPointProgress];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //[self reloadVisibleCheckPoint];
    [self refreshCheckPointProgress];
}

#pragma mark - UITableview Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return totalRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"CPCell";
    HSCheckPointCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[HSCheckPointCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    [cell initCheckPointAndStatus];
    return cell;
}

- (void)configureCell:(HSCheckPointCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger index1 = row*kPointCountPerRow+0;
    NSInteger index2 = row*kPointCountPerRow+1;
    NSInteger index3 = row*kPointCountPerRow+2;

    BOOL isOdd  = row % 2 == 0 ? NO : YES;
    
    // 奇数行, 1和3调换位置
    if (isOdd)
    {
        NSInteger index = index1;
        index1 = index3;
        index3 = index;
    }
    
    BOOL isLast = (row >= totalRow-1);
    cell.row = row;
    cell.totalCount = totalCount;
    cell.isOdd  = isOdd;
    cell.isLast = isLast;

    if (!isLast)
    {
        CheckPointModel *cpModel1 = [arrCheckPoint objectAtIndex:index1];
        cell.firstCheckPoint = cpModel1;
        
        CheckPointModel *cpModel2 = [arrCheckPoint objectAtIndex:index2];
        cell.secondCheckPoint = cpModel2;
        
        CheckPointModel *cpModel3 = [arrCheckPoint objectAtIndex:index3];
        cell.thirdCheckPoint = cpModel3;
    }
    else
    {
        if (index1 < totalCount)
        {
            CheckPointModel *cpModel = [arrCheckPoint objectAtIndex:index1];
            cell.firstCheckPoint = cpModel;
        }
        
        if (index2 < totalCount)
        {
            CheckPointModel *cpModel = [arrCheckPoint objectAtIndex:index2];
            cell.secondCheckPoint = cpModel;
        }
        
        if (index3 <  totalCount)
        {
            CheckPointModel *cpModel = [arrCheckPoint objectAtIndex:index3];
            cell.thirdCheckPoint = cpModel;
        }
    }
}

#pragma mark - UITableview Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f*1.5f+20.0f*2;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self configureCell:(HSCheckPointCell *)cell atIndexPath:indexPath];
}

#pragma mark - Cell Delegate


- (void)cell:(HSCheckPointCell *)cell selectedCheckPoint:(CheckPointModel *)checkPoint
{
    NSString *cpID = [[NSString alloc] initWithFormat:@"%@", checkPoint.cpID];
    NSString *nexCpID = [[NSString alloc] initWithFormat:@"%@", checkPoint.nexCpID];
    DLog(@"cpID: %@; nexCpID: %@", cpID, nexCpID);
    // 没有下载数据的话，下载数据
    __weak HSCheckPointView *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *dataDir = [kDownloadedPath stringByAppendingPathComponent:cpID];
        BOOL isDownloaded = ([[NSFileManager defaultManager] fileExistsAtPath:dataDir]) ? YES : NO;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!isDownloaded) {
                [weakSelf downloadCheckPointMediaDataWithCheckPointID:cpID];
            }
        });
    });
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(checkPointView:selectCheckPoint:nexCheckPoint:)]){
        [self.delegate checkPointView:self selectCheckPoint:cpID nexCheckPoint:nexCpID];
    }
}

- (void)scrollToLastUnlockedCheckpointDelay:(CGFloat)delay
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSInteger cpCount = [CheckPointDAL countOfCheckPointProgressWithUserID:kUserID bookID:kBookID];
        NSInteger row = cpCount/kPointCountPerRow + (cpCount % kPointCountPerRow == 0 ? 0:1);
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
        
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            if (row > 0 && row < totalRow)
            {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row-1 inSection:0];
                [self.tbvCheckPoint scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                isScrolled = YES;
            }
        });
    });
}

#pragma mark - Memory Manager
- (void)dealloc
{
    kRemoveObserverNotification(self, nil, nil);
    
    [checkPointNet cancelDownload];
    [checkPointNet cancelRequest];
    checkPointNet = nil;
    
    [wordNet cancelDownload];
    [wordNet cancelRequest];
    wordNet = nil;
    
    imgLocked = nil;
    imgUnLocked = nil;
    imgCpLink = nil;
}

@end
