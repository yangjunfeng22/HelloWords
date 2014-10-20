//
//  HSWordCheckDataFormat.m
//  HSWordsPass
//
//  Created by Lu on 14-9-15.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSWordCheckDataFormat.h"

@implementation HSWordCheckDataFormat
hsSharedInstanceImpClass(HSWordCheckDataFormat);

- (NSMutableArray *)chaosArrayFromArry:(NSArray *)oldArry withReturnNumber:(NSInteger)returnNumber{
    if (returnNumber > oldArry.count) {
        return nil;
    }
    
    NSMutableArray *newArray = [NSMutableArray array];
    NSMutableArray *oldMutableArray = [NSMutableArray arrayWithArray:oldArry];
    for (int i = 0; i < returnNumber; i++) {
       NSInteger random = arc4random()%oldMutableArray.count;
       id tempItem = [oldMutableArray objectAtIndex:random];
       [newArray insertObject:tempItem atIndex:i];
        [oldMutableArray removeObject:tempItem];
    }
    return newArray;
}


-(NSMutableArray *)chaosArrayFromWordModelArry:(NSArray *)oldWordModelArry andSelfWordModel:(WordModel *)selfWordModel
{
    //凑答案的模型个数必须大于3个
    if (oldWordModelArry.count < 3) {
        return nil;
    }
    NSMutableArray *otherWordModelArry = [self deleteSameResult:selfWordModel wordModelArry:[NSMutableArray arrayWithArray:oldWordModelArry]];
    
    NSMutableArray *newotherArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    //循环  去除掉雷同的答案
    for (int i = 0; i < otherWordModelArry.count; i++) {
        
        WordModel *tempWordModel = (WordModel *)[otherWordModelArry objectAtIndex:i];
        //先去除掉和题目一样的答案
        if ([tempWordModel.chinese isEqualToString:selfWordModel.chinese] || [tempWordModel.tChinese isEqualToString:selfWordModel.chinese]) {
            [otherWordModelArry removeObject:tempWordModel];
        }
        
        //去除掉后判断数量是否大于三个 否则无法生成足够数量的题目
        if (otherWordModelArry.count < 3) {
            return nil;
        }
    }
    //将没有雷同答案的数据再循环出三个答案
    newotherArray = [self chaosArrayFromArry:otherWordModelArry withReturnNumber:3];
    return newotherArray;
}


//去除掉雷同的答案
- (NSMutableArray *)deleteSameResult:(WordModel *)selfWordModel wordModelArry:(NSMutableArray *)wordModelArry
{
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    NSMutableArray *categoryStrArray = [[NSMutableArray alloc] init];
    NSMutableArray *categoryENArray = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < [wordModelArry count]; i++){
        WordModel *tempModel = [wordModelArry objectAtIndex:i];
        if ([categoryStrArray containsObject:tempModel.chinese] == NO
            && [categoryENArray containsObject:tempModel.tChinese] == NO
            && ![tempModel.chinese isEqualToString:selfWordModel.chinese]
            && ![tempModel.tChinese isEqualToString:selfWordModel.tChinese]
            )
        {
            [categoryStrArray addObject:tempModel.chinese];
            [categoryENArray addObject:tempModel.tChinese];
            [categoryArray addObject:tempModel];
        }
    }
    return categoryArray;
}

@end
