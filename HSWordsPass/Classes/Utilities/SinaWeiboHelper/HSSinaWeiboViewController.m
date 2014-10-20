//
//  HSSinaWeiboViewController.m
//  HSWordsPass
//
//  Created by yang on 14-8-29.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSSinaWeiboViewController.h"
#import "NFSinaWeiboHelper.h"

@interface HSSinaWeiboViewController ()<UIWebViewDelegate>
{
    WeiboType weiboType;
}

@end

@implementation HSSinaWeiboViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initwithWeiboType:(WeiboType)type
{
    id obj = [self init];
    if (obj)
    {
        weiboType = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.navigationController)
    {
        [self.navigationController.navigationBar setHidden:NO];
        UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(back:)];
        [self.navigationItem setLeftBarButtonItem:leftBar animated:YES];
    }
    else
    {
        // 其他的方式

    }
    
    NSString *strUrl = @"";
    if (weiboType == kWeiboTypeLogin){
        strUrl = [NFSinaWeiboHelper oauthUrlString];
    }else
    {
        strUrl = [NFSinaWeiboHelper oauthUrlString];
    }
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:strUrl]];
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [webView setDelegate:self];
    [webView loadRequest:request];
    [self.view addSubview:webView];
}

- (void)back:(id)sender
{
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

#pragma mark - WebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *backURL = [request URL];  //接受重定向的URL
    return [NFSinaWeiboHelper startAuthorizeWithURL:backURL finished:^(NSString *screen_name) {
        [self back:nil];
    }];
}

#pragma mark - Memory Manager
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
