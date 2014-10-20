//
//  UpdateAppNet.h
//  HelloHSK
//
//  Created by yang on 14-4-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateAppNet : NSObject

hsSharedInstanceDefClass(UpdateAppNet);

-(void)checkAppUpdateInfo:(void (^)(BOOL finished, id result, NSError *error))completion;

- (void)cancelCheck;

@end
