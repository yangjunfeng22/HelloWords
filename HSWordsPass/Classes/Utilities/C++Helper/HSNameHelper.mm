//
//  HSNameHelper.m
//  HSWordsPass
//
//  Created by yang on 14-9-1.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSNameHelper.h"

#include "nam.h"

using namespace mynamespace;

@implementation HSNameHelper
{
    netHelper *net;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSLog(@"Name Helper init");
        net = new netHelper(1);
        net->foo();
    }
    return self;
}

- (void)dealloc
{
    delete net;
}

@end
