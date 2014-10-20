//
//  HSAppSetViewController.m
//  HSWordsPass
//
//  Created by Lu on 14-9-23.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSAppSetViewController.h"
#import "HSAppSetTableViewCell.h"

#import "HSAppSetAboutUSViewController.h"
#import "HSAppSetHeadView.h"
#import "HSShareViewController.h"
#import "HSFeaturedAppViewController.h"
#import "UINavigationController+Extern.h"

#import "SystemInfoHelper.h"

@interface HSAppSetViewController ()

@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation HSAppSetViewController

#pragma mark - 初始化
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
    self.title = NSLocalizedString(@"设置", @"");
    
    self.cellArray = [NSMutableArray arrayWithCapacity:2];

    [self.navigationController setPresentNavigationBarBackItemWihtTarget:self image:[UIImage imageNamed:@"hsGlobal_back_icon.png"]];
    
    [self dataInitialization];
    
    self.tableView.backgroundColor = kClearColor;
    [self initLogOutView];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [CommonHelper googleAnalyticsPageView:@"设置"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 初始化数据源
- (void)dataInitialization{
    //tableviewHead
    HSAppSetHeadView *headView = [[HSAppSetHeadView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 160)];
    self.tableView.tableHeaderView = headView;
    
    //cell
    HSAppSetTableViewCell *cell00 = [[HSAppSetTableViewCell alloc] initWithReuseIdentifier:@"cell00"];
    cell00.textLabel.text = NSLocalizedString(@"关于我们", @"");
    cell00.subClass = [HSAppSetAboutUSViewController class];
    
//    HSAppSetTableViewCell *cell01 = [[HSAppSetTableViewCell alloc] initWithReuseIdentifier:@"cell01"];
//    cell01.textLabel.text = NSLocalizedString(@"分享", @"");
//    cell01.subClass = [HSShareViewController class];
    
    HSAppSetTableViewCell *cell02 = [[HSAppSetTableViewCell alloc] initWithReuseIdentifier:@"cell02"];
    cell02.textLabel.text = NSLocalizedString(@"意见反馈", @"");
    cell02.selector = @selector(feedbackAction);
    
    HSAppSetTableViewCell *cell03 = [[HSAppSetTableViewCell alloc] initWithReuseIdentifier:@"cell03"];
    cell03.textLabel.text = NSLocalizedString(@"评价我们", @"");
    cell03.selector = @selector(rateUs);
    
    HSAppSetTableViewCell *cell04 = [[HSAppSetTableViewCell alloc] initWithReuseIdentifier:@"cell04"];
    cell04.textLabel.text = NSLocalizedString(@"应用推荐", @"");
    cell04.subClass = [HSFeaturedAppViewController class];

    [self.cellArray setArray:@[cell00,cell02,cell03,cell04]];
}




#pragma mark - action
- (void)logOutBtnClick:(id)sender
{
    
    [CommonHelper googleAnalyticsLogCategory:@"退出" action:@"退出操作" event:@"退出" pageView:NSStringFromClass([self class])];
    
    [self.parentViewController dismissViewControllerAnimated:YES completion:^{
        kPostNotification(kQuitLoginNotification, nil, nil);
    }];
}


- (void)rateUs{
    DLog(@"rateUsrateUsrateUs");
    NSInteger appID = 930872352;
    NSString *appUrl = [[NSString alloc] initWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d", appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appUrl]];
}


- (void)feedbackAction{
    DLog(@"feedbackAction");

    //NSLog(@"version: %@; device: %@; version: %@", productVersion(), device(), [UIDevice currentDevice].systemVersion);
    // 检测是否可以发送邮件
    BOOL canSend = [MFMailComposeViewController canSendMail];
    if (canSend)
    {
        NSString *appName = NSLocalizedString(@"词汇通关", @"");
        //NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kDeviceTokenStringKey];;
        NSString *info = [[NSString alloc] initWithFormat:@"App Name: %@;\nApp Version: %@;\nDevice Name: %@;\nOS Version: %@", appName, kSoftwareVersion, device(), [UIDevice currentDevice].systemVersion];
        
        NSString *msgBody = [[NSString alloc] initWithFormat:@"Please fill in the content\n\n\n\n\n%@", info];
        
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        
        mc.mailComposeDelegate = self;
        [mc setSubject:@"feedback"];
        
        [mc setToRecipients:[NSArray arrayWithObject:@"feedback@hschinese.com"]];
        //[mc setToRecipients:[NSArray arrayWithObject:@"yjf@hschinese.com"]];
        [mc setMessageBody:msgBody isHTML:NO];
        [self presentModalViewController:mc animated:YES];
    }
    else
    {
        NSString *title = NSLocalizedString(@"请设置您的邮箱", @"");
        [hsGetSharedInstanceClass(HSBaseTool) HUDForView:self.view Title:title isHide:YES];
    }
    
}

#pragma mark - 初始化ui

-(UITableView *)tableView{
    if (!_tableView) {
        CGFloat height = kIOS7 ? 0 : 44;
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.height = self.view.height - height;
        _tableView.backgroundColor = kClearColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = YES;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


-(void)initLogOutView{
        
    UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 54)];
    sectionFooterView.backgroundColor = [UIColor clearColor];
        
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 7, 300, 45);
    button.width = self.view.width*0.9f;
    button.center = CGPointMake(sectionFooterView.width/2.0f, sectionFooterView.height/2.0f);
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [button setBackgroundColor:hsShineBlueColor];
    [button setTitle:NSLocalizedString(@"退出", @"") forState:UIControlStateNormal];
    [button setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [button.titleLabel setFont:[button.titleLabel.font fontWithSize:18.0f]];
    [button addTarget:self action:@selector(logOutBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [sectionFooterView addSubview:button];
        
    _tableView.tableFooterView = sectionFooterView;
}


#pragma mark - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellArray objectAtIndex:indexPath.row];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HSAppSetTableViewCell *tempCell = (HSAppSetTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
     [CommonHelper googleAnalyticsLogCategory:@"设置操作" action:@"设置页面操作" event:tempCell.textLabel.text pageView:NSStringFromClass([self class])];
    
    if (tempCell.subClass && [tempCell.subClass isSubclassOfClass:[UIViewController class]]) {
        UIViewController *viewController = [[tempCell.subClass alloc] init];
        viewController.title = tempCell.textLabel.text;
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
    if (tempCell.selector) {
        [self performSelectorOnMainThread:tempCell.selector withObject:nil waitUntilDone:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




//MFMailComposeViewControllerDelegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}


- (void)dealloc
{
    DLOG_CMETHOD;
}



@end
