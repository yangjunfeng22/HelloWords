//
//  HSWordCheckDataFormat.h
//  HSWordsPass
//
//  Created by Lu on 14-9-15.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WordModel.h"
//测试题类型
typedef NS_ENUM(NSUInteger, HSWordCheckTopicType)
{
    HSWordCheckTopicTypeChoiceCHWord = 0, //选词填空
    HSWordCheckTopicTypeChoiceFromLocal, //释意选词语
    HSWordCheckTopicTypeChoiceFromCH,//根据中文选择释义
};

@interface HSWordCheckDataFormat : NSObject
hsSharedInstanceDefClass(HSWordCheckDataFormat)


//传入一个数组 并返回需要长度的数组  且 不能重复
- (NSMutableArray *)chaosArrayFromArry:(NSArray *)oldArry withReturnNumber:(NSInteger)returnNumber;



/**
 * 注意 --- 只能应用于词汇模型数组
 * 传入一个词汇模型数组 并且排除掉相同中文词汇的wordmodel  该方法一般用于生成无雷同的其余三个答案
 */
- (NSMutableArray *)chaosArrayFromWordModelArry:(NSArray *)oldWordModelArry andSelfWordModel:(WordModel *)selfWordModel;

@end
