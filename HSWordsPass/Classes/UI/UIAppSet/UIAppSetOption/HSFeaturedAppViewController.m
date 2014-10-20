//
//  HSFeaturedAppViewController.m
//  HSWordsPass
//
//  Created by Lu on 14-9-24.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSFeaturedAppViewController.h"
#import "HSCustomWebImgCell.h"
#import "UINavigationController+Extern.h"
#import "ResponseModel.h"
#import "AppRecommendNet.h"
#import "RecommendModel.h"
#import "UIImageView+WebCache.h"
@interface HSFeaturedAppViewController ()

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *arrApp;;

@end

@implementation HSFeaturedAppViewController{
    
    AppRecommendNet * net;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    self.tableView.backgroundColor = kClearColor;
    [self.navigationController setNavigationBarBackItemWihtTarget:self image:[UIImage imageNamed:@"hsGlobal_back_icon.png"]];
    
    net = [[AppRecommendNet alloc] init];
    _arrApp = [NSMutableArray arrayWithCapacity:2];
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



#pragma mark - action
-(void)loadData{

    [net checkAppRecommendInfo:^(BOOL finished, id result, NSError *error) {
        [_arrApp setArray:result];
        [self.tableView reloadData];
    }];
}


- (void)refreshInterface
{
    [self.tableView reloadData];
}


#pragma mark - 初始化ui
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


#pragma mark - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrApp.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cell";
    HSCustomWebImgCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[HSCustomWebImgCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];

        cell.textLabel.textColor = kBlackColor;
        cell.textLabel.highlightedTextColor = kWhiteColor;
        
        cell.detailTextLabel.textColor = hsGlobalWordColor;
        cell.detailTextLabel.highlightedTextColor = kWhiteColor;
        
        //右侧箭头
        UIImageView *accessorIimageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hsGlobal_arrow_blue"]highlightedImage:[UIImage imageNamed:@"hsGlobal_arrow_white"]];
        cell.accessoryView = accessorIimageView;
        
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = hsShineBlueColor;
    }
    RecommendModel *recommend = (RecommendModel *)[_arrApp objectAtIndex:indexPath.row];
    cell.imgPlacehold = [UIImage imageNamed:@"default_img"];
    cell.imagePath = recommend.appIcoURL;
    cell.textLabel.text = recommend.appName;
    cell.detailTextLabel.text = recommend.appDescription;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    
    RecommendModel *recommend = [_arrApp objectAtIndex:row];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:recommend.appURL]];
}

@end
