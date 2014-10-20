//
//  HSCheckPointCell.m
//  HSWordsPass
//
//  Created by yang on 14-10-13.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSCheckPointCell.h"
#import "CheckPointDAL.h"
#import "CheckPointModel.h"
#import "CheckPointProgressModel.h"

#import "DACircularProgressView.h"
#import "HSLearnCircleProgressView.h"

#import "WordLearnInfoModel.h"
#import "WordDAL.h"
#import "WordNet.h"

#define kPointLeft 30.0f
#define kPointTop 20.0f
#define kPointDistance 36.25f
#define kPointCountPerRow 3

NSString *const kRefreshCheckPointProgressNotification = @"RefreshCheckPointProgressNotification";

@interface HSCheckPointCell ()

@end

@implementation HSCheckPointCell
{
    
    DACircularProgressView *progressFirstView;
    DACircularProgressView *progressSecondView;
    DACircularProgressView *progressThirdView;
    
    UIImageView *imgvLKFirst;
    UIImageView *imgvLKSecond;
    UIImageView *imgvLKThird;
    
    UIImage *imgCPBkg;
    UIImage *imgUnLocked;
    UIImage *imgLocked;
    UIImage *imgCpLinkS;
    UIImage *imgCpLink;
    UIImage *imgHCpLinkS;
    UIImage *imgHCpLink;
    
    CGSize linkSize;
    // 竖向的图片的大小
    CGSize linkSizeS;
    CGSize imgSize;
    CGFloat totalWidth;
    CGFloat width;
    CGFloat distance;
    
    UIFont *nameFont;
    
    //NSString *curCpID;
    //NSString *nexCpID;
    //NSString *name;
    NSString *bID;
    //NSInteger index;
    
    CGFloat progress;
    // 已解锁的集合
    __block NSMutableIndexSet *indexSet;
    __block NSMutableDictionary *dicCpProgress;
    
    CGRect cpRectOne;
    CGRect cpRectTwo;
    CGRect cpRectThree;
    
    CGRect cpNameRectOne;
    CGRect cpNameRectTwo;
    CGRect cpNameRectThree;
    
    WordNet *wordNet;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        imgUnLocked = [UIImage imageNamed:@"imgPointUnLocked.png"];
        imgLocked = [UIImage imageNamed:@"imgPointLocked.png"];
        imgCpLinkS = [UIImage imageNamed:@"imgPointLink_S"];
        imgCpLink = [UIImage imageNamed:@"imgPointLink.png"];
        imgHCpLinkS = [UIImage imageNamed:@"imgProgress_S"];
        imgHCpLink = [UIImage imageNamed:@"imgProgress.png"];
        
        imgSize = [imgLocked size];
        
        linkSize = [imgCpLink size];
        linkSizeS = [imgCpLinkS size];
        
        nameFont = [UIFont fontWithName:kGlobalFontName size:kCheckPointFontSize*0.8f];
        
        totalWidth = self.contentView.bounds.size.width;
        width = totalWidth - kPointLeft*2;
        distance = (width - imgSize.width*kPointCountPerRow)/(CGFloat)(kPointCountPerRow-1);
        
        cpRectOne = CGRectMake(kPointLeft, kPointTop, imgSize.width, imgSize.height);
        
        cpRectTwo = CGRectMake(kPointLeft + 1*(imgSize.width+distance), kPointTop, imgSize.width, imgSize.height);
        
        cpRectThree = CGRectMake(kPointLeft + 2*(imgSize.width+distance), kPointTop, imgSize.width, imgSize.height);
        
        cpNameRectOne = CGRectMake(CGRectGetMinX(cpRectOne)-10, CGRectGetMaxY(cpRectOne), CGRectGetWidth(cpRectOne)+20, CGRectGetHeight(cpRectOne)*0.5f);
        cpNameRectTwo = CGRectMake(CGRectGetMinX(cpRectTwo)-10, CGRectGetMaxY(cpRectTwo), CGRectGetWidth(cpRectTwo)+20, CGRectGetHeight(cpRectTwo)*0.5f);
        cpNameRectThree = CGRectMake(CGRectGetMinX(cpRectThree)-10, CGRectGetMaxY(cpRectThree), CGRectGetWidth(cpRectThree)+20, CGRectGetHeight(cpRectThree)*0.5f);
        
        indexSet = [[NSMutableIndexSet alloc] init];
        dicCpProgress = [[NSMutableDictionary alloc] init];
        
        wordNet = [[WordNet alloc] init];
        
        //self.clearsContextBeforeDrawing = YES;
        self.clipsToBounds = NO;
        self.contentView.clipsToBounds = NO;
        self.backgroundColor = kClearColor;
        self.contentView.backgroundColor = kClearColor;
        
        [self initCheckPointAndStatus];
        
        kAddObserverNotification(self, @selector(refreshProgress:), kRefreshCheckPointProgressNotification, nil);
        kAddObserverNotification(self, @selector(nextCheckPoint:), kNextCheckPointNotification, nil);
    }
    return self;
}
- (void)setIsLast:(BOOL)isLast
{
    _isLast = isLast;
    [self setNeedsDisplay];
}

- (void)setFirstCheckPoint:(CheckPointModel *)firstCheckPoint
{
    _firstCheckPoint = firstCheckPoint;
    
    [self refreshCheckPointProgressWithCpID:firstCheckPoint.cpID index:1];
}

- (void)setSecondCheckPoint:(CheckPointModel *)secondCheckPoint
{
    _secondCheckPoint = secondCheckPoint;
    [self refreshCheckPointProgressWithCpID:secondCheckPoint.cpID index:2];
}

- (void)setThirdCheckPoint:(CheckPointModel *)thirdCheckPoint
{
    _thirdCheckPoint = thirdCheckPoint;
    [self refreshCheckPointProgressWithCpID:thirdCheckPoint.cpID index:3];
}

- (void)initCheckPointAndStatus
{
    imgCPBkg = imgLocked;
    
    if (!imgvLKFirst)
    {
        imgvLKFirst = [[UIImageView alloc] init];
        [self addSubview:imgvLKFirst];
    }
    
    if (!imgvLKSecond)
    {
        imgvLKSecond = [[UIImageView alloc] init];
        imgvLKSecond.bounds = CGRectMake(0.0f, 0.0f, distance, linkSize.height);
        [self addSubview:imgvLKSecond];
    }
    
    if (!imgvLKThird)
    {
        imgvLKThird= [[UIImageView alloc] init];
        [self addSubview:imgvLKThird];
    }
    
    imgvLKSecond.image = [imgCpLink resizableImageWithCapInsets:UIEdgeInsetsMake(linkSize.height*0.5f, linkSize.width*0.5f, linkSize.height*0.5f, linkSize.width*0.5f)];
    
    [dicCpProgress removeAllObjects];
    
    [progressFirstView setProgress:0.0f animated:NO initialDelay:0.0f];
    [progressSecondView setProgress:0.0f animated:NO initialDelay:0.0f];
    [progressThirdView setProgress:0.0f animated:NO initialDelay:0.0f];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    if (totalWidth != self.contentView.bounds.size.width)
    {
        totalWidth = self.contentView.bounds.size.width;
        //DLog(@"width: %f", totalWidth);
        width = totalWidth - kPointLeft*2;
        distance = (width - imgSize.width*kPointCountPerRow)/(CGFloat)(kPointCountPerRow-1);
        
        cpRectOne = CGRectMake(kPointLeft, kPointTop, imgSize.width, imgSize.height);
        
        cpRectTwo = CGRectMake(kPointLeft + 1*(imgSize.width+distance), kPointTop, imgSize.width, imgSize.height);
        
        cpRectThree = CGRectMake(kPointLeft + 2*(imgSize.width+distance), kPointTop, imgSize.width, imgSize.height);
        
        cpNameRectOne = CGRectMake(CGRectGetMinX(cpRectOne)-10, CGRectGetMaxY(cpRectOne), CGRectGetWidth(cpRectOne)+20, CGRectGetHeight(cpRectOne)*0.5f);
        cpNameRectTwo = CGRectMake(CGRectGetMinX(cpRectTwo)-10, CGRectGetMaxY(cpRectTwo), CGRectGetWidth(cpRectTwo)+20, CGRectGetHeight(cpRectTwo)*0.5f);
        cpNameRectThree = CGRectMake(CGRectGetMinX(cpRectThree)-10, CGRectGetMaxY(cpRectThree), CGRectGetWidth(cpRectThree)+20, CGRectGetHeight(cpRectThree)*0.5f);
        
        progressFirstView.frame = cpRectOne;
        progressSecondView.frame = cpRectTwo;
        progressThirdView.frame = cpRectThree;
    }
    
    CGFloat height = linkSize.height;
    if (!_isOdd)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"%@", _firstCheckPoint.name];
        CGSize nameSize = [name sizeWithFont:nameFont forWidth:CGRectGetWidth(cpRectOne) lineBreakMode:NSLineBreakByCharWrapping];
        height = [name isEqualToString:@""] ? self.height-imgSize.height:self.height-imgSize.height-nameSize.height;
    }
    imgvLKFirst.bounds = _isOdd ? CGRectMake(0.0f, 0.0f, distance, height) : CGRectMake(0.0f, 0.0f, linkSizeS.width, height);
    
    imgvLKSecond.bounds = CGRectMake(0.0f, 0.0f, distance, linkSize.height);
    
    height = linkSize.height;
    if (_isOdd)
    {
        NSString *name = [[NSString alloc] initWithFormat:@"%@", _thirdCheckPoint.name];
        CGSize nameSize = [name sizeWithFont:nameFont forWidth:CGRectGetWidth(cpRectOne) lineBreakMode:NSLineBreakByCharWrapping];
        height = [name isEqualToString:@""] ? self.height-imgSize.height:self.height-imgSize.height-nameSize.height;
    }
    imgvLKThird.bounds = _isOdd ? CGRectMake(0.0f, 0.0f, linkSizeS.width, height): CGRectMake(0.0f, 0.0f, distance, height);
    
    imgvLKFirst.image = _isOdd ? [imgCpLink resizableImageWithCapInsets:UIEdgeInsetsMake(linkSize.height*0.5f, linkSize.width*0.5f, linkSize.height*0.5f, linkSize.width*0.5f)] : [imgCpLinkS resizableImageWithCapInsets:UIEdgeInsetsMake(linkSizeS.height*0.5f, linkSizeS.width*0.5f, linkSizeS.height*0.5f, linkSizeS.width*0.5f)];
    
    imgvLKThird.image = _isOdd ?  [imgCpLinkS resizableImageWithCapInsets:UIEdgeInsetsMake(linkSizeS.height*0.5f, linkSizeS.width*0.5f, linkSizeS.height*0.5f, linkSizeS.width*0.5f)]: [imgCpLink resizableImageWithCapInsets:UIEdgeInsetsMake(linkSize.height*0.5f, linkSize.width*0.5f, linkSize.height*0.5f, linkSize.width*0.5f)];
    
    for (NSNumber *obj in [dicCpProgress allKeys])
    {
        if ([obj integerValue] == 1)
        {
            imgvLKFirst.image = _isOdd ? [imgHCpLink resizableImageWithCapInsets:UIEdgeInsetsMake(linkSize.height*0.5f, linkSize.width*0.5f, linkSize.height*0.5f, linkSize.width*0.5f)] : [imgHCpLinkS resizableImageWithCapInsets:UIEdgeInsetsMake(linkSizeS.height*0.5f, linkSizeS.width*0.5f, linkSizeS.height*0.5f, linkSizeS.width*0.5f)];
        }
        else if ([obj integerValue] == 2)
        {
            imgvLKSecond.image = [imgHCpLink resizableImageWithCapInsets:UIEdgeInsetsMake(linkSize.height*0.5f, linkSize.width*0.5f, linkSize.height*0.5f, linkSize.width*0.5f)];;
        }
        else if ([obj integerValue] == 3)
        {
            imgvLKThird.image = _isOdd ?  [imgHCpLinkS resizableImageWithCapInsets:UIEdgeInsetsMake(linkSizeS.height*0.5f, linkSizeS.width*0.5f, linkSizeS.height*0.5f, linkSizeS.width*0.5f)]: [imgHCpLink resizableImageWithCapInsets:UIEdgeInsetsMake(linkSize.height*0.5f, linkSize.width*0.5f, linkSize.height*0.5f, linkSize.width*0.5f)];
        }
    }
    
    [UIView animateWithDuration:0.1f animations:^{
        // 奇数行，在右边，否则在上面
        imgvLKFirst.centerX = _isOdd ? CGRectGetMaxX(cpRectOne)+imgvLKFirst.width*0.5f:CGRectGetMidX(cpRectOne);
        // 奇数行在中间，否则在上面
        imgvLKFirst.centerY = _isOdd ? CGRectGetMidY(cpRectOne):CGRectGetMinY(cpRectOne)-imgvLKFirst.height*0.5f;
    }];
    
    [UIView animateWithDuration:0.1f animations:^{
        imgvLKSecond.centerX = _isOdd ? CGRectGetMaxX(cpRectTwo)+imgvLKSecond.width*0.5f:cpRectTwo.origin.x-imgvLKSecond.width*0.5f;
        imgvLKSecond.centerY = CGRectGetMidY(cpRectTwo);
    }];

    
    [UIView animateWithDuration:0.1f animations:^{
        imgvLKThird.centerX = _isOdd ? CGRectGetMidX(cpRectThree):cpRectThree.origin.x-imgvLKThird.width*0.5f;
        imgvLKThird.centerY = _isOdd ? cpRectThree.origin.y-imgvLKThird.height*0.5f:CGRectGetMidY(cpRectThree);
    }];
    
    if (_isLast)
    {
        NSInteger index1 = _row*kPointCountPerRow+0;
        NSInteger index2 = _row*kPointCountPerRow+1;
        NSInteger index3 = _row*kPointCountPerRow+2;
        
        if (_isOdd)
        {
            NSInteger index = index1;
            index1 = index3;
            index3 = index;
        }
        
        if (index1 >= _totalCount)
        {
            imgvLKFirst.hidden = YES;
            [progressFirstView setProgress:0.0f animated:NO initialDelay:0.0f];
        }
        
        if (index2 >= _totalCount)
        {
            imgvLKSecond.hidden = YES;
            [progressSecondView setProgress:0.0f animated:NO initialDelay:0.0f];
        }
        
        if (index3 >=  _totalCount)
        {
            imgvLKThird.hidden = YES;
            [progressThirdView setProgress:0.0f animated:NO initialDelay:0.0f];
        }
    }
    else
    {
        if (_row == 0) {
            imgvLKFirst.hidden = YES;
        }else{
            imgvLKFirst.hidden = NO;
        }
        imgvLKSecond.hidden = NO;
        imgvLKThird.hidden = NO;
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    NSArray *arrAllUnlocked = [dicCpProgress allKeys];
    
    NSString *nameONe;
    NSString *nameTwo;
    NSString *nameThree;
    
    UIColor *colorOne;
    UIColor *colorTwo;
    UIColor *colorThree;
    
    //DLOG_CMETHOD;
    if (_isLast)
    {
        NSInteger index1 = _row*kPointCountPerRow+0;
        NSInteger index2 = _row*kPointCountPerRow+1;
        NSInteger index3 = _row*kPointCountPerRow+2;
        
        if (_isOdd)
        {
            NSInteger index = index1;
            index1 = index3;
            index3 = index;
        }
        
        if (index1 < _totalCount)
        {
            [imgCPBkg drawInRect:cpRectOne];
            
            colorOne = [UIColor darkGrayColor];
            if ([arrAllUnlocked containsObject:[NSNumber numberWithInteger:1]]) {
                colorOne = kBlackColor;
            }
            nameONe = [[NSString alloc] initWithFormat:@"%@", _firstCheckPoint.name];
        }
        
        if (index2 < _totalCount)
        {
            [imgCPBkg drawInRect:cpRectTwo];
            
            colorTwo = [UIColor darkGrayColor];
            if ([arrAllUnlocked containsObject:[NSNumber numberWithInteger:2]]) {
                colorTwo = kBlackColor;
            }
            
            nameTwo = [[NSString alloc] initWithFormat:@"%@", _secondCheckPoint.name];
        }
        
        if (index3 <  _totalCount)
        {
            [imgCPBkg drawInRect:cpRectThree];
            
            colorThree = [UIColor darkGrayColor];
            if ([arrAllUnlocked containsObject:[NSNumber numberWithInteger:3]]) {
                colorThree = kBlackColor;
            }
            
            nameThree = [[NSString alloc] initWithFormat:@"%@", _thirdCheckPoint.name];
        }
        
    }
    else
    {
        [imgCPBkg drawInRect:cpRectOne];
        [imgCPBkg drawInRect:cpRectTwo];
        [imgCPBkg drawInRect:cpRectThree];
        
        colorOne = [UIColor darkGrayColor];
        if ([arrAllUnlocked containsObject:[NSNumber numberWithInteger:1]]) {
            colorOne = kBlackColor;
        }
        nameONe = [[NSString alloc] initWithFormat:@"%@", _firstCheckPoint.name];
        
        colorTwo = [UIColor darkGrayColor];
        if ([arrAllUnlocked containsObject:[NSNumber numberWithInteger:2]]) {
            colorTwo = kBlackColor;
        }
        
        nameTwo = [[NSString alloc] initWithFormat:@"%@", _secondCheckPoint.name];
        
        colorThree = [UIColor darkGrayColor];
        if ([arrAllUnlocked containsObject:[NSNumber numberWithInteger:3]]) {
            colorThree = kBlackColor;
        }
        
        nameThree = [[NSString alloc] initWithFormat:@"%@", _thirdCheckPoint.name];
    }
    CGContextSetFillColorWithColor(context, colorOne.CGColor);
    [nameONe drawInRect:cpNameRectOne withFont:nameFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    CGContextSetFillColorWithColor(context, colorTwo.CGColor);
    [nameTwo drawInRect:cpNameRectTwo withFont:nameFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    CGContextSetFillColorWithColor(context, colorThree.CGColor);
    [nameThree drawInRect:cpNameRectThree withFont:nameFont lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    
    
    CGContextSetFillColorWithColor(context, hsGlobalBlueColor.CGColor);
    
    [arrAllUnlocked enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj integerValue] == 1) {
            [imgUnLocked drawInRect:cpRectOne];
            
            NSString *title = [[NSString alloc] initWithFormat:@"%d", _firstCheckPoint.indexValue];
            [title drawInRect:CGRectMake(CGRectGetMinX(cpRectOne), CGRectGetMidY(cpRectOne)-CGRectGetHeight(cpRectOne)*0.2f, CGRectGetWidth(cpRectOne), CGRectGetHeight(cpRectOne)*0.5f) withFont:[UIFont fontWithName:kGlobalFontName size:kCheckPointFontSize] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
            
        }else if ([obj integerValue] == 2){
            [imgUnLocked drawInRect:cpRectTwo];
            
            NSString *title = [[NSString alloc] initWithFormat:@"%d", _secondCheckPoint.indexValue];
            [title drawInRect:CGRectMake(CGRectGetMinX(cpRectTwo), CGRectGetMidY(cpRectTwo)-CGRectGetHeight(cpRectTwo)*0.2f, CGRectGetWidth(cpRectTwo), CGRectGetHeight(cpRectTwo)*0.5f) withFont:[UIFont fontWithName:kGlobalFontName size:kCheckPointFontSize] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
            
            
        }else if ([obj integerValue] == 3){
            
            [imgUnLocked drawInRect:cpRectThree];
            
            NSString *title = [[NSString alloc] initWithFormat:@"%d", _thirdCheckPoint.indexValue];
            [title drawInRect:CGRectMake(CGRectGetMinX(cpRectThree), CGRectGetMidY(cpRectThree)-CGRectGetHeight(cpRectThree)*0.2f, CGRectGetWidth(cpRectThree), CGRectGetHeight(cpRectThree)*0.5f) withFont:[UIFont fontWithName:kGlobalFontName size:kCheckPointFontSize] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        }
    }];
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *arrUnloacked = [dicCpProgress allKeys];
    NSInteger count = [arrUnloacked count];
    // 只有解锁的才进入关卡
    if (count <= 0)
    {
        return;
    }
    else
    {
        UITouch *touch = [touches anyObject];
        CGPoint location=[touch locationInView:self];
        
        if (CGRectContainsPoint(cpRectOne, location) && [arrUnloacked containsObject:[NSNumber numberWithInteger:1]]){
            [self checkpointSelected:_firstCheckPoint];
        }else if (CGRectContainsPoint(cpRectTwo, location) && [arrUnloacked containsObject:[NSNumber numberWithInteger:2]]){
            [self checkpointSelected:_secondCheckPoint];
        }else if (CGRectContainsPoint(cpRectThree, location) && [arrUnloacked containsObject:[NSNumber numberWithInteger:3]]){
            [self checkpointSelected:_thirdCheckPoint];
        }
    }
}

- (void)refreshProgress:(NSNotification *)notification
{
    NSDictionary *dicUserInfo = [notification userInfo];
    if (!dicUserInfo)
    {
        for (NSNumber *numIndex in [dicCpProgress allKeys])
        {
            CGFloat lProgress = [[dicCpProgress objectForKey:numIndex] floatValue];
            [self setCheckPointProgress:lProgress index:[numIndex integerValue] animate:YES];
        }
    }
    
    /*
    else
    {
        
        NSString *cpID = [dicUserInfo objectForKey:@"CheckPointID"];
        NSNumber *numIndex = [NSNumber numberWithInteger:0];
        if ([_firstCheckPoint.cpID isEqualToString:cpID])
        {
            numIndex = [NSNumber numberWithInteger:1];
            CGFloat lProgress = [[dicCpProgress objectForKey:numIndex] floatValue];
            [self setCheckPointProgress:lProgress index:[numIndex integerValue] animate:YES];
        }
        else if ([_secondCheckPoint.cpID isEqualToString:cpID])
        {
            numIndex = [NSNumber numberWithInteger:2];
            CGFloat lProgress = [[dicCpProgress objectForKey:numIndex] floatValue];
            [self setCheckPointProgress:lProgress index:[numIndex integerValue] animate:YES];
        }
        else if ([_thirdCheckPoint.cpID isEqualToString:cpID])
        {
            numIndex = [NSNumber numberWithInteger:3];
            CGFloat lProgress = [[dicCpProgress objectForKey:numIndex] floatValue];
            [self setCheckPointProgress:lProgress index:[numIndex integerValue] animate:YES];
        }
    }
     */
    [self setNeedsLayout];
}

- (void)refreshCheckPointProgressWithCpID:(NSString *)aCurCpID index:(NSInteger)aIndex
{
    __weak HSCheckPointCell *weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *userID = kUserID;
        NSString *strBookID = kBookID;
        __block CheckPointProgressModel *cpProgress = [CheckPointDAL queryCheckPointProgressWithUserID:userID bookID:strBookID checkPointID:aCurCpID];
        
        if (_row == 0 && aIndex == 1 && !cpProgress)
        {
            [CheckPointDAL saveCheckPointProgressWithUserID:userID CheckPointID:aCurCpID bookID:strBookID version:nil progress:0 status:0 completion:^(BOOL finished, id obj, NSError * error) {
                
                cpProgress = [CheckPointDAL queryCheckPointProgressWithUserID:userID bookID:strBookID checkPointID:aCurCpID];
                
                [weakSelf showCheckPointProgress:cpProgress index:aIndex];
            }];
        }
        [weakSelf showCheckPointProgress:cpProgress index:aIndex];
    });
}

- (void)showCheckPointProgress:(CheckPointProgressModel *)cpProgress index:(NSInteger)aIndex
{
    CGFloat aProgress = 0.0f;
    BOOL progressExit = NO;
    
    if (cpProgress)
    {
        progressExit = YES;
        aProgress = cpProgress.progressValue;
        //[self syncWordLearnRecordsWithCheckPointID:cpProgress.cpID];
    }
    // 将本身显示出来
    dispatch_async(dispatch_get_main_queue(), ^{
        //DLOG_CMETHOD;
        if (progressExit)
        {
            NSNumber *numIndex = [[NSNumber alloc] initWithInteger:aIndex];
            NSNumber *numProgress = [[NSNumber alloc] initWithFloat:aProgress];
            [dicCpProgress setObject:numProgress forKey:numIndex];
        }
        
        if (aIndex == 1){
            [self setNeedsDisplayInRect:CGRectUnion(cpRectOne, cpNameRectOne)];
            //[self setNeedsDisplay];
        }else if (aIndex == 2){
            [self setNeedsDisplayInRect:CGRectUnion(cpRectTwo, cpNameRectTwo)];
            //[self setNeedsDisplay];
        }else if (aIndex == 3){
            [self setNeedsDisplayInRect:CGRectUnion(cpRectThree, cpNameRectThree)];
            //[self setNeedsDisplay];
        }
        //[self setNeedsLayout];
    });
}

- (void)setCheckPointProgress:(CGFloat)aProgress index:(NSInteger)index animate:(BOOL)animate
{
    if (index == 1)
    {
        if (!progressFirstView)
        {
            progressFirstView = [[DACircularProgressView alloc] initWithFrame:cpRectOne];
            progressFirstView.roundedCorners = YES;
            progressFirstView.thicknessRatio = 0.2f;
            progressFirstView.indeterminateDuration = 0.1f;
            progressFirstView.progressTintColor = hsGlobalBlueColor;
            progressFirstView.trackTintColor = kClearColor;
            [self addSubview:progressFirstView];
        }
        
        [progressFirstView setProgress:aProgress animated:animate initialDelay:0.0f];
        
    }
    else if (index == 2)
    {
        if (!progressSecondView)
        {
            progressSecondView = [[DACircularProgressView alloc] initWithFrame:cpRectTwo];
            progressSecondView.roundedCorners = YES;
            progressSecondView.thicknessRatio = 0.2f;
            progressSecondView.indeterminateDuration = 0.1f;
            progressSecondView.progressTintColor = hsGlobalBlueColor;
            progressSecondView.trackTintColor = kClearColor;
            [self addSubview:progressSecondView];
        }
        [progressSecondView setProgress:aProgress animated:animate initialDelay:0.0f];
        
    }
    else if (index == 3)
    {
        if (!progressThirdView)
        {
            progressThirdView = [[DACircularProgressView alloc] initWithFrame:cpRectThree];
            progressThirdView.roundedCorners = YES;
            progressThirdView.thicknessRatio = 0.2f;
            progressThirdView.indeterminateDuration = 0.1f;
            progressThirdView.progressTintColor = hsGlobalBlueColor;
            progressThirdView.trackTintColor = kClearColor;
            [self addSubview:progressThirdView];
        }
        [progressThirdView setProgress:aProgress animated:animate initialDelay:0.0f];
    }
}

- (void)checkpointSelected:(CheckPointModel *)checkPoint
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:selectedCheckPoint:)])
    {
        [self.delegate cell:self selectedCheckPoint:checkPoint];
    }
}

- (void)nextCheckPoint:(NSNotification *)notification
{
    NSString *cpID = [notification.userInfo objectForKey:@"NextCpID"];
    if ([_firstCheckPoint.cpID isEqualToString:cpID]) {
        [self checkpointSelected:_firstCheckPoint];
    }else if ([_secondCheckPoint.cpID isEqualToString:cpID]){
        [self checkpointSelected:_secondCheckPoint];
    }else if ([_thirdCheckPoint.cpID isEqualToString:cpID]){
        [self checkpointSelected:_thirdCheckPoint];
    }
}

#pragma mark - Memory Manager
- (void)dealloc
{
    kRemoveObserverNotification(self, nil, nil);
}

@end
