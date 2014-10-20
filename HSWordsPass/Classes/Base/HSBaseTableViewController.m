//
//  HSBaseTableViewController.m
//  HSWordsPass
//
//  Created by Lu on 14-10-16.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSBaseTableViewController.h"

@interface HSBaseTableViewController ()

@end

@implementation HSBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(void)addOrRemoveNoDataBackBtn:(NSInteger)count{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),dispatch_get_main_queue() , ^{
        if (count == 0) {
            UIView *oldImageView = [self.baseContentView viewWithTag:99999];
            if (!oldImageView) {
                UIButton *backgroundBtn = [[UIButton alloc] initWithFrame:self.baseContentView.bounds];
                backgroundBtn.contentMode = UIViewContentModeTop;
                backgroundBtn.tag = 999;
                backgroundBtn.backgroundColor = kWhiteColor;
                [backgroundBtn addTarget:self action:@selector(againToObtain) forControlEvents:UIControlEventTouchUpInside];
                [self.baseContentView insertSubview:backgroundBtn atIndex:[[self.baseContentView subviews] count]];
                
                //添加logo图片 及提示语
                UIImage *img = [UIImage imageNamed:@"noDataImg"];
                UIImageView *imgView = [[UIImageView alloc] init];
                imgView.image = img;
                imgView.size = img.size;
                imgView.centerY = 200;
                imgView.centerX = backgroundBtn.width/2;
                [backgroundBtn addSubview:imgView];
                
                
                UILabel *label = [[UILabel alloc] init];
                label.size = CGSizeMake(backgroundBtn.width, 30);
                label.top = imgView.bottom + 20;
                label.centerX = imgView.centerX;
                label.text = NSLocalizedString(@"点击屏幕，重新加载", @"");
                label.textColor = hsGlobalWordColor;
                label.textAlignment = UITextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:14.0f];
                [backgroundBtn addSubview:label];
            }
        }else{
            UIView *oldImageView = [self.baseContentView viewWithTag:99999];
            if (oldImageView) {
                [oldImageView removeFromSuperview];
                oldImageView = nil;
            }
        }
    });
};


-(void)againToObtain{
    
}

@end
