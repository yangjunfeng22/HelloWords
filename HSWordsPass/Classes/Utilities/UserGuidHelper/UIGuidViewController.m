//
//  UIGuidViewController.m
//  DicisionMaking
//
//  Created by yang on 13-4-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UIGuidViewController.h"

#define SCROLL_WIDTH self.view.frame.size.width
#define SCROLL_HEIGHT self.view.frame.size.height
#define EXPERIENCE_BUTTON_FRAME CGRectMake(SCROLL_WIDTH - 120.0f, SCROLL_HEIGHT - 80.0f, 100.0f, 36.0f)

@interface UIGuidViewController ()
{
    UIPageControl *pageControl;
    
    dispatch_queue_t queue;
}

@end

@implementation UIGuidViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil guidPages:(NSArray *)aPages
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        arrGuidPages = [[NSMutableArray alloc] init];
        [arrGuidPages setArray:aPages];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    queue = dispatch_queue_create("com.wordpass.userguid", NULL);
    
    UIScrollView *scrGuid = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCROLL_WIDTH, SCROLL_HEIGHT)];
    scrGuid.delegate = self;
    scrGuid.pagingEnabled = YES;
    scrGuid.bounces = NO;
    scrGuid.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrGuid];
    [self updateScrollViewBackgroundColor:scrGuid];
    
    NSArray *arrTitle = @[@"他们在地铁里玩游戏，你在背单词……",
                          @"他们在酒吧里闲聊，你在背单词……",
                          @"他们在等待时发呆，你在背单词……",
                          @"时间碎片的叠加，你就是学霸！",
                          @"准备好了吗，开始今天的自我挑战吧！"];
    
//    NSArray *arrPlace = @[@"0.8f", @"0.65f", @"0.65f", @"0.62f", @"0.59f"];
    
    NSInteger guidCount = [arrGuidPages count];
    
    [arrGuidPages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSString *strImageName = (NSString *)obj;
        UIImage *img = [UIImage imageNamed:strImageName];
        //CGSize imgSize = [img size];
        
        //CGFloat imgWidth = imgSize.width ;
        //CGFloat imgHeight = imgSize.height;
        UIImageView *imgvGuid = [[UIImageView alloc] init];
        imgvGuid.bounds = CGRectMake(0.0f, 0.0f, SCROLL_WIDTH, SCROLL_HEIGHT);
        imgvGuid.center = CGPointMake(idx*SCROLL_WIDTH+SCROLL_WIDTH*0.5f, SCROLL_HEIGHT*0.5f);
        imgvGuid.image = img;
        [scrGuid addSubview:imgvGuid];

        NSString *title = NSLocalizedString([arrTitle objectAtIndex:idx], @"");
        UILabel *lblTitle = [[UILabel alloc] init];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.bounds = CGRectMake(0.0f, 0.0f, SCROLL_WIDTH*0.8f, 40.0f);
        lblTitle.numberOfLines = 0;
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.textColor = hsGlobalWordColor;
        lblTitle.text = title;
        [scrGuid addSubview:lblTitle];
        [lblTitle sizeToFit];
//        CGFloat yPlace = [[arrPlace objectAtIndex:idx] floatValue];
//        lblTitle.center = CGPointMake(imgvGuid.center.x, imgvGuid.center.y + imgvGuid.bounds.size.height*yPlace + lblTitle.bounds.size.height*0.5f);
        lblTitle.centerX = imgvGuid.centerX;
        lblTitle.bottom = self.view.bottom - 80;
        
        if (idx == guidCount-1)
        {
            UIButton *experienceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            experienceBtn.bounds = CGRectMake(0.0f, 0.0f, 178, 56);
            experienceBtn.center = CGPointMake(idx*SCROLL_WIDTH + SCROLL_WIDTH*0.5f, scrGuid.bounds.size.height - 19-56+25);
            [experienceBtn setBackgroundImage:[UIImage imageNamed:@"btnBeginExprenceImage.png"] forState:UIControlStateNormal];
            [experienceBtn setTitleColor:[UIColor colorWithRed:115.0f/255.0f green:122.0f/255.0f blue:135.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [experienceBtn setTitleShadowColor:[UIColor grayColor] forState:UIControlStateNormal];
            [experienceBtn setTitle:NSLocalizedString(@"开始体验", @"") forState:UIControlStateNormal];
            
            [experienceBtn addTarget:self action:@selector(experienceAction:) forControlEvents:UIControlEventTouchUpInside];
            [scrGuid addSubview:experienceBtn];
        }
    }];
    
    CGFloat scrContentWidth = SCROLL_WIDTH * [arrGuidPages count];
    [scrGuid setContentSize:CGSizeMake(scrContentWidth, SCROLL_HEIGHT)];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, SCROLL_HEIGHT - 36.0f, SCROLL_WIDTH, 36.0f)];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = hsShineBlueColor;
    pageControl.numberOfPages = [arrGuidPages count];
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    [self pageChanged:pageControl];
}

- (void)pageChanged:(UIPageControl*)pc
{
    NSArray *subViews = pc.subviews;
    //CFTimeInterval start = CFAbsoluteTimeGetCurrent();
    NSInteger i = 0;
    for (UIView *subView in subViews)
    {
        if ([NSStringFromClass([subView class]) isEqualToString:NSStringFromClass([UIImageView class])]) {
            ((UIImageView*)subView).image = (pc.currentPage == i ? [UIImage imageNamed:@"pageControlSelected.png"] : [UIImage imageNamed:@"pageControlUnSelected.png"]);
        }
        i++;
    }
    //CFTimeInterval end = CFAbsoluteTimeGetCurrent();
    //NSLog(@"for loop: %f", end - start);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateScrollViewBackgroundColor:(UIScrollView *)scrollView
{
    UIColor *bkgColor = [UIColor clearColor];
    
#ifdef LEVEL_1
    bkgColor = [UIColor colorWithRed:255/255.0f green:181/255.0f blue:0/255.0f alpha:1.0f];
#elif LEVEL_2
    bkgColor = [UIColor colorWithRed:255/255.0f green:111/255.0f blue:33/255.0f alpha:1.0f];
#elif LEVEL_3
    bkgColor = [UIColor colorWithRed:95/255.0f green:194/255.0f blue:86/255.0f alpha:1.0f];
#elif LEVEL_4
    bkgColor = [UIColor colorWithRed:0/255.0f green:174/255.0f blue:224/255.0f alpha:1.0f];
#elif LEVEL_5
    bkgColor = [UIColor colorWithRed:185/255.0f green:86/255.0f blue:194/255.0f alpha:1.0f];
#elif LEVEL_6
    bkgColor = [UIColor colorWithRed:106/255.0f green:110/255.0f blue:198/255.0f alpha:1.0f];
#endif
    scrollView.backgroundColor = bkgColor;
}

#pragma mark - 
#pragma mark UIButton Action
- (void)experienceAction:(id)sender
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(UIGuidViewControllerDelegate)]
        && [self.delegate respondsToSelector:@selector(guidViewController:experienceAction:)])
    {
        [self.delegate guidViewController:self experienceAction:sender];
    }
}

#pragma mark -
#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    dispatch_async(queue, ^{
        CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger page = floor((scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            pageControl.currentPage = page;
            [self pageChanged:pageControl];
        });
    });
}

#pragma mark - Memory Manager
- (void)dealloc
{
    dispatch_release(queue);
}

@end
