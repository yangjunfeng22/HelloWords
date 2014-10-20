//
//  AppRecommendNet.h
//  HSWordsPass
//
//  Created by Lu on 14-10-15.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppRecommendNet : NSObject

- (void)checkAppRecommendInfo:(void (^)(BOOL finished, id result, NSError *error))completion;
;

- (void)cancelCheck;

@end
