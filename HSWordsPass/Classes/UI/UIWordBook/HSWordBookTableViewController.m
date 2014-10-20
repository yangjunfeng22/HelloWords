//
//  HSWordBookTableViewController.m
//  HSWordsPass
//
//  Created by Lu on 14-10-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSWordBookTableViewController.h"
#import "BookDAL.h"
#import "BookNet.h"
#import "MBProgressHUD.h"
#import "BookCategoryModel.h"
#import "HSBookListTableViewController.h"
#import "UserDAL.h"
#import "MJRefresh.h"
#import "GAIDictionaryBuilder.h"
#import "HSCustomWebImgCell.h"



static NSString *cellStr = @"hSWordBookTableViewCell";

@interface HSWordBookTableViewController ()<HSBookListViewDelegate>
{
    BookNet *bookNet;
    NSMutableArray *arrCategory;
    NSInteger curCategoryID;
}

@end

@implementation HSWordBookTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"选择书本", @"");
    self.tableView.backgroundColor = kWhiteColor;
    self.baseContentView = self.tableView;
    
    NSString *userID = kUserID;
    NSInteger count = [UserDAL userLaterStatusCountWithUserID:userID];

    if (count > 0) {
        CreatViewControllerImageBarButtonItem([UIImage imageNamed:@"hsGlobal_back_icon.png"], @selector(backBtnClick:), self, YES);
    }
    
    self.tableView.tableFooterView = [[UIView alloc] init];

    self.clearsSelectionOnViewWillAppear = NO;

    bookNet = [[BookNet alloc] init];
    [self requestBookCategoryData];
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [CommonHelper googleAnalyticsPageView:@"词书页面"];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - action

- (void)backBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


- (void)requestBookCategoryData
{
    __weak HSWordBookTableViewController *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSInteger count = [BookDAL bookCategoryCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (count <= 0)
            {
                if (bookNet)
                {
                    __block MBProgressHUD *hud;
                    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeIndeterminate;
                    hud.labelText = NSLocalizedString(@"正在下载数据", @"");
                    hud.removeFromSuperViewOnHide = YES;
                    [bookNet startWordBookCategoryRequestWithUserEmail:kEmail completion:^(BOOL finished, id result, NSError *error) {
                        [hud hide:YES];
                        
                        [weakSelf loadBookCategoryData];
                    }];
                }
            }
            else
            {
                // 如果有数据，直接加载
                [weakSelf loadBookCategoryData];
                
                [bookNet startWordBookCategoryRequestWithUserEmail:kEmail completion:^(BOOL finished, id result, NSError *error) {
                    [weakSelf loadBookCategoryData];
                }];
            }
        });
    });
}


- (void)loadBookCategoryData
{
    arrCategory = [[NSMutableArray alloc] initWithCapacity:2];
    [arrCategory setArray:[BookDAL queryWordBookCategoryInfos]];
    
    [self.tableView reloadData];
    //判断有无数ju
    [self addOrRemoveNoDataBackBtn:arrCategory.count];
}

-(void)againToObtain{
    DLog(@"重新获取数据");
    [self requestBookCategoryData];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrCategory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSCustomWebImgCell *cell = [tableView dequeueReusableCellWithIdentifier:cellStr];
    if (!cell) {
        cell = [[HSCustomWebImgCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellStr];
        
        cell.textLabel.textColor = hsGlobalWordColor;
        
        //右侧箭头
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hsGlobal_arrow_blue"]highlightedImage:[UIImage imageNamed:@"hsGlobal_arrow_white"]];
        cell.accessoryView = imageView;
        cell.textLabel.highlightedTextColor = kWhiteColor;
        
        //背景
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = hsShineBlueColor;
    }
    BookCategoryModel *model = [arrCategory objectAtIndex:indexPath.row];
    NSString *picth = model.picture;
    DLog(@"====%@",picth);
    cell.textLabel.text = model.tName;
    cell.imgPlacehold = [UIImage imageNamed:@"default_img_52"];
    cell.imagePath = model.picture;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookCategoryModel *model = [arrCategory objectAtIndex:indexPath.row];
    
    HSBookListTableViewController *bookListView = [[HSBookListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    bookListView.title = model.name;
    bookListView.categoryID = [model.cID integerValue];
    curCategoryID = [model.cID integerValue];
    bookListView.delegate = self;
    
    [self.navigationController pushViewController:bookListView animated:YES];

    //谷歌
    [CommonHelper googleAnalyticsLogCategory:@"词书选择" action:@"选择书本" event:model.name pageView:NSStringFromClass([self class])];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - HSBookListViewDelegate
-(void)bookListselectedBook:(NSInteger)bID version:(NSString *)version
{
    NSString *strBID = [[NSString alloc] initWithFormat:@"%d", bID];
    NSString *strCID = [[NSString alloc] initWithFormat:@"%d", curCategoryID];
    // 保存最后的状态.
    // -- 只在用户选择了某一本具体的教材之后才保存这种状态，如果用户只选择了种类，那么是不计的。
    NSString *userID = kUserID;
    kSetUDCategoryID(strCID);
    kSetUDBookID(strBID);
    
    __weak HSWordBookTableViewController *weakSelf = self;
    [UserDAL saveUserLaterStatusWithUserID:userID categoryID:strCID bookID:strBID checkPointID:@"" nexCheckPointID:@"" timeStamp:NSTimeIntervalSince1970 completion:^(BOOL finished, id result, NSError *error) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(bookSelectWithSelBookCategory:selBook:version:)])
        {
            [weakSelf.delegate bookSelectWithSelBookCategory:strCID selBook:strBID version:version];
        }
    }];
}

@end
