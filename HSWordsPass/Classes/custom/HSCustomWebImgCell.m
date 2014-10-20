//
//  HSAppRecommendCell.m
//  HelloHSK
//
//  Created by yang on 14-4-17.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSCustomWebImgCell.h"
#import "UIImage+Extra.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "SDWebImageDownloader.h"

@interface HSCustomWebImgCell ()<SDWebImageManagerDelegate, SDWebImageDownloaderDelegate>

@end

@implementation HSCustomWebImgCell
{
    UIActivityIndicatorView *activityIndicatorView;
    CGSize imgPSize;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    }
    return self;
}

- (void)awakeFromNib
{
}

-(void)setImgPlacehold:(UIImage *)imgPlacehold{
    _imgPlacehold = imgPlacehold;
    imgPSize = [_imgPlacehold size];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setImagePath:(NSString *)imagePath
{
    NSURL *imgUrl = [NSURL URLWithString:imagePath];
    
    self.imageView.image = _imgPlacehold;
    //[self.imageView setImageWithURL:imgUrl placeholderImage:imgPlacehold];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    UIImage *cachedImage = [manager imageWithURL:imgUrl];
    
    if (cachedImage)
    {
        self.imageView.image = [UIImage originImage:cachedImage scaleToSize:imgPSize];
    }
    else
    {
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicatorView.frame = CGRectMake((self.imageView.bounds.size.width - activityIndicatorView.bounds.size.width) /2, (self.imageView.bounds.size.height - activityIndicatorView.bounds.size.height) /2, activityIndicatorView.bounds.size.width,activityIndicatorView.bounds.size.height);
        activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [activityIndicatorView startAnimating];
        [self.imageView addSubview:activityIndicatorView];
        
        [manager downloadWithURL:imgUrl delegate:self];
    }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFailWithError:(NSError *)error
{
    [self removeActivityIndicatorView:nil];
    
    self.imageView.image = _imgPlacehold;
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [self removeActivityIndicatorView:nil];
    self.imageView.image = [UIImage originImage:image scaleToSize:imgPSize];
}

- (void)removeActivityIndicatorView:(UIActivityIndicatorView *)activityView
{
    if (activityIndicatorView)
    {
        [activityIndicatorView stopAnimating];
        [activityIndicatorView removeFromSuperview];
        activityIndicatorView = nil;
    }
}

- (void)dealloc
{
    _imgPlacehold = nil;
    
    [self removeActivityIndicatorView:activityIndicatorView];
}

@end

