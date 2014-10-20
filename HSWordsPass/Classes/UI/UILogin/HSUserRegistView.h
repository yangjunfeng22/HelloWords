//
//  HSUserRegistView.h
//  HSWordsPass
//
//  Created by yang on 14-9-1.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSUserRegistViewDelegate;

@interface HSUserRegistView : UIView<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, weak)id<HSUserRegistViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UITableView *tbvRegist;

/**
 *  初始化函数，从nib文件中获取对象
 *
 *  @return 该对象实例。
 */
+ (HSUserRegistView *)instance;

/**
 *  隐藏键盘
 */
- (void)hideKeyBoard;

@end

@protocol HSUserRegistViewDelegate <NSObject>

@optional

/**
 *  用户使用了email注册的方式注册，然后使用该注册的email登陆。
 *
 *  @param email    email
 *  @param password 密码。
 */
- (void)userRegistSuccessedWithEmail:(NSString *)email password:(NSString *)password;

@end
