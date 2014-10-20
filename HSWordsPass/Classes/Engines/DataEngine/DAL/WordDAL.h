//
//  WordListDAL.h
//  HSWordsPass
//
//  Created by yang on 14-9-10.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WordReviewModel.h"

@class WordModel;
@class WordTranslationModel;
@class SentenceModel;
@class SentenceTranslationModel;
@class WordLearnInfoModel;
@class CheckPoint_WordModel;

@interface WordDAL : NSObject

#pragma mark - 关卡-词对应关系的查询
+ (NSString *)getCheckPointWordsLinkedRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email checkPointID:(NSString *)cpID productID:(NSString *)productID;

+ (void)parseCheckPointWordsLinkedByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;
/**
 *  获取关卡——词的对应关系,根据关卡DI和词ID进行精确查找。
 *
 *  @param cpID      关卡ID
 *  @param wID       词汇ID
 *
 *  @return 关卡-词汇的对应关系
 */
+ (CheckPoint_WordModel *)queryCheckPoint_WordWithCheckPointID:(NSString *)cpID wordID:(NSString *)wID;

/**
 *  获取关卡——词的对应关系,根据词ID查找出对应的关卡。
 *
 *  @param wID       词汇ID
 *
 *  @return 关卡-词汇的所有对应关系
 */
+ (NSArray *)queryCheckPoint_WordWithWordID:(NSString *)wID;

#pragma mark - 词数据
/**
 *  获取词的请求的url的格式化的参数列表
 *
 *  @param apKey     验证字符串
 *  @param email     用户email
 *  @param cpID      关卡ID
 *  @param language  本地语言
 *  @param productID 产品ID
 *
 *  @return 格式化后的参数列表
 */
+ (NSString *)getWordRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email checkPointID:(NSString *)cpID wordID:(NSString *)wID language:(NSString *)language productID:(NSString *)productID;

+ (NSString *)getWordSentenceRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email wordID:(NSString *)wID language:(NSString *)language productID:(NSString *)productID;

/**
 *  解词的数据
 *
 *  @param resultData 网络请求的结果：json格式的数据
 *  @param completion 结束后的block回调
 */
+ (void)parseWordByData:(id)resultData checkPointID:(NSString *)cpID completion:(void (^)(BOOL, id, NSError *))completion;

+ (void)parseWordSentenceByData:(id)resultData checkPointID:(NSString *)cpID wordID:(NSString *)wID completion:(void (^)(BOOL, id, NSError *))completion;

#pragma mark - 数据的数据库操作
/**
 *  查询所有的词本身信息
 *
 *  @return 所有的词本身的信息
 */
+ (NSArray *)queryWordInfos;

/**
 *  根据关卡ID 来查询词的信息
 *
 *  @param cpID 关卡ID
 *
 *  @return 特定词书种类下的所有的词
 */
+ (NSArray *)queryWordInfosWithCheckPointID:(NSString *)cpID;

/**
 *  查询词汇数据
 *
 *  @param wID 词汇的ID
 *
 *  @return 返回单个词汇数据
 */
+ (WordModel *)queryWordWithWordID:(NSString *)wID;

/**
 *  指定关卡下面的词的数量
 *
 *  @param cpID 关卡ID
 *
 *  @return 数量
 */
+ (NSInteger)wordCountWithCheckPointID:(NSString *)cpID;

/**
 *  查询词的翻译数据
 *
 *  @param wID      词ID
 *  @param language 当前系统语言
 *
 *  @return 返回的翻译数据
 */
+ (WordTranslationModel *)queryWordTranslationWithWordID:(NSString *)wID language:(NSString *)language;

/**
 *  根据词ID查询该词所具有的所有词的信息
 *
 *  @param wID 词ID
 *
 *  @return 所有的词
 */
+ (NSArray *)querySentencesWithWordID:(NSString *)wID;

/**
 *  查询句子的翻译
 *
 *  @param sID      句子ID
 *  @param language 当前系统语言
 *
 *  @return 句子翻译
 */
+ (SentenceTranslationModel *)querySentenceTranslationWithSentenceID:(NSString *)sID language:(NSString *)language;

/**
 *  使用fetch方式来查询所有的数据
 *   -- 所有返回的值（结果）都会在返回的fetchResultsController的代理中得到处理。
 *
 *  @param delegate fetchController的代理，所有通过fetchController得到的值都在这个代理里面处理
 *  @param cID 词书种类ID。
 *
 *  @return 返回的值，一般为NSFetchedResultsController的对象。
 */
+ (id)fetchAllWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate checkPointID:(NSString *)cpID;

/**
 *  获取词例句之间的关系
 *
 *  @param wID 词ID
 *
 *  @return 返回数据
 */
+ (NSArray *)queryWord_SentenceWithWordID:(NSString *)wID;

/**
 *  获取例句词之间的关系，即由例句的信息反查词的信息
 *
 *  @param sID 例句ID
 *
 *  @return 返回的数据
 */
+ (NSArray *)querySentence_WordWithSentenceID:(NSString *)sID;

/**
 *  例句-关卡之间的关系，即由例句的信息查询出所在关卡的信息
 *
 *  @param sID 例句ID
 *
 *  @return 返回值
 */
+ (NSArray *)querySentence_CheckPointWithSentenceID:(NSString *)sID;

#pragma mark - 词的音频数据的下载
+ (NSString *)getDownloadWordAudioDataURLParamsWithApKey:(NSString *)apKey email:(NSString *)email audio:(NSString *)audio productID:(NSString *)productID version:(NSString *)version;

+ (void)parseWordAudioDownloadByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

#pragma mark - 词的学习记录数据
+ (NSString *)getWordLearnedRecordsRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email checkPointID:(NSString *)cpID bookID:(NSString *)bID categoryID:(NSString *)cID records:(NSString *)records language:(NSString *)language productID:(NSString *)productID;


/**
 *  解词学习记录的数据
 *
 *  @param resultData 网络请求的结果：json格式的数据
 *  @param completion 结束后的block回调
 */
+ (void)parseWordLearnedRecordsByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

/**
 *  加载词的测试记录,即学习正确、错误的记录
 *
 *  使用方法:
 *  [WordDAL loadWordCheckRecordInfoWithUserID:nil checkPointID:nil WordID:nil completion:^(BOOL success, id obj, NSError *error) {
         WordLearnInfoModel *wordLearned = (WordLearnInfoModel *)obj;
         // 使用该模型的数据。。。。。。
     }];
 *
 *  @param uID        用户ID
 *  @param bID        词书ID
 *  @param wID        词ID
 *  @param completion 完成后的回调
 */
+ (void)loadWordCheckRecordInfoWithUserID:(NSString *)uID checkPointID:(NSString *)cpID WordID:(NSString *)wID completion:(void (^)(BOOL success, id obj, NSError *error))completion;

/**
 *  保存词的学习记录
 *
 *  @param uID    用户ID
 *  @param cpID   关卡ID
 *  @param wID    词ID
 *  @param rights 正确次数
 *  @param wrongs 错误次数
 *  @param status 状态
 *  @param sync   是否同步
 */
+ (void)saveWordLearnedRecordsWithUserID:(NSString *)uID checkPointID:(NSString *)cpID wordID:(NSString *)wID rights:(NSInteger)rights wrongs:(NSInteger)wrongs status:(NSInteger)status sync:(NSInteger)sync completion:(void(^)(BOOL finished, id obj, NSError *error))completion;

+ (WordLearnInfoModel *)queryWordLearnedRecordInfoWithUserID:(NSString *)uID checkPointID:(NSString *)cpID WordID:(NSString *)wID;

/**
 *  已经归档了的词的数量
 *
 *  @param uID <#uID description#>
 *  @param bID <#bID description#>
 *
 *  @return <#return value description#>
 */
+ (NSInteger)countOfFiledWordLearnedRecordWithUserID:(NSString *)uID bookID:(NSString *)bID;

/**
 *  已经掌握的了词的数量
 *
 *  @param uID <#uID description#>
 *  @param bID <#bID description#>
 *
 *  @return <#return value description#>
 */
+ (NSInteger)countOfMasteredWordLearnedRecordWithUserID:(NSString *)uID bookID:(NSString *)bID;

/**
 *  <#Description#>
 *
 *  @param uID  <#uID description#>
 *  @param cpID <#cpID description#>
 *
 *  @return <#return value description#>
 */
+ (NSArray *)queryWordLearnRecordInfosWithUserID:(NSString *)uID checkPointID:(NSString *)cpID;

#pragma mark - 生词本的数据
+ (NSString *)getWordReviewRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email bookID:(NSString *)bID records:(NSString *)records language:(NSString *)language productID:(NSString *)productID;

/**
 *  解析生词本的数据
 *
 *  @param resultData json格式的数据
 *  @param completion block回调
 */
+ (void)parseWordReviewByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

/**
 *  保存生词的数据
 *
 *  @param uID        用户ID
 *  @param wID        词ID
 *  @param created    创建时间
 *  @param status     状态: 0:未同步的新增记录；1:已同步的记录；2:未同步的移除记录
 *  @param completion 回调
 */
+ (void)saveWordReviewWithUserID:(NSString *)uID cpID:(NSString *)cpID wordID:(NSString *)wID created:(NSInteger)created status:(NewWordStatus)status completion:(void (^)(BOOL finished, id obj, NSError *error))completion;

/**
 *  查询单个生词的数据
 *
 *  @param uID 用户ID
 *  @param wID 词ID
 *
 *  @return 生词记录
 */
+ (WordReviewModel *)queryWordReviewInfoWithUserID:(NSString *)uID WordID:(NSString *)wID;

/**
 *  判断是否存在该生词
 *
 *  @param uID 用户ID
 *  @param wID 词ID
 *
 *  @return 是否存在该生词
 */
+ (BOOL)existNewWordWithUserID:(NSString *)uID WordID:(NSString *)wID;

/**
 *  查询所有的生词，包括待删除的。
 *
 *  @param uID 用户ID
 *
 *  @return 该用户所有的生词
 */
+ (NSArray *)queryAllNewWordsInfosWithUserID:(NSString *)uID bookID:(NSString *)bID;

/**
 *  查询所有需要显示的生词，不包括待删除的。
 *
 *  @param uID 用户ID
 *
 *  @return 该用户所有的生词
 */
+ (NSArray *)queryNewWordsShowInfosWithUserID:(NSString *)uID;

+ (NSInteger)newWordCountWithUserID:(NSString *)uID checkPointID:(NSString *)cpID;
/**
 *  fetch方式查询生词
 *
 *  @param delegate 代理
 *  @param uID      用户ID
 *
 *  @return 返回值
 */
+ (id)fetchNewWordsShowWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate UserID:(NSString *)uID;

/**
 *  自定义查询数据
 *
 *  @param uID         用户ID
 *  @param fetchOffset 查询的起始偏移量，比如0：从当前数据库的第0条开始查询。
 *  @param fetchLimit  查询的条数，比如20：即查询20条，
 *
 *  @discuss 
 *     fetchOffset与fetchLimit结合起来，可以查询从任意位置开始的，指定数量的数据。
 *
 *  @return 返回当前的查询结果
 */
+ (id)fetchNewWordsShowWithUserID:(NSString *)uID fetchOffset:(NSInteger)fetchOffset fetchLimit:(NSInteger)fetchLimit;

@end
