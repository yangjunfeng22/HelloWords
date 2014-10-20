//
//  RecommendModel.m
//  HelloHSK
//
//  Created by yang on 14-4-16.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "RecommendModel.h"

@implementation RecommendModel
@synthesize appID;
@synthesize appIcoURL;
@synthesize appName;
@synthesize appDescription;
@synthesize appURL;
@synthesize appUpdated;

- (void)dealloc
{
    self.appID = nil;
    self.appIcoURL = nil;
    self.appName = nil;
    self.appDescription = nil;
    self.appURL = nil;
    self.appUpdated = nil;
}

@end
