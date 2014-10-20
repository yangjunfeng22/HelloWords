//
//  BookDAL.h
//  HSWordsPass
//
//  Created by yang on 14-8-28.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BookCategoryModel;
@class BookCategoryTransModel;

@class BookModel;
@class BookTranslationModel;

@interface BookDAL : NSObject

#pragma mark - 书本种类的数据操作
+ (NSString *)getCategoryRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email language:(NSString *)language productID:(NSString *)productID;

// 解词书种类的数据
+ (void)parseCategoryByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;


#pragma mark - 数据库操作
/**
 *  查询所有的词书种类的信息
 *
 *  @return 所有的词书种类
 */
+ (NSArray *)queryWordBookCategoryInfos;

/**
 *  词书种类的个数
 *
 *  @return 个数
 */
+ (NSInteger)bookCategoryCount;

/**
 *  根据词书种类ID 来查询指定的词书种类
 *
 *  @param cID 词书种类ID
 *
 *  @return 指定的词书种类
 */
+ (BookCategoryModel *)queryWordBookCategoryWithCategoryID:(NSString *)cID;

/**
 *  查询某个词书种类的字段的翻译
 *
 *  @param cID      词书种类ID
 *  @param language 语言
 *
 *  @return 词书种类翻译数据
 */
+ (BookCategoryTransModel *)queryBookCategoryTranslationWithCategoryID:(NSString *)cID language:(NSString *)language;


#pragma mark - 书本的数据操作
+ (NSString *)getWordBookRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email categoryID:(NSString *)categoryID language:(NSString *)language productID:(NSString *)productID;


+ (NSString *)getBookVersionRequestURLParamsWithApKey:(NSString *)apKey email:(NSString *)email bookID:(NSString *)bID productID:(NSString *)productID;

/**
 *  解词书的数据
 *
 *  @param resultData 网络请求的结果：json格式的数据
 *  @param completion 结束后的block回调
 */
+ (void)parseWordBookByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;

+ (void)parseBookVersionByData:(id)resultData completion:(void (^)(BOOL, id, NSError *))completion;


#pragma mark - 数据的数据库操作
/**
 *  保存词书的数据
 *
 *  @param bID     词书ID
 *  @param cID     词书种类ID
 *  @param name    词书的名称，比如HSK1级
 *  @param picture 词书的封页。
 */
+ (void)saveWordBookWithBookID:(NSString *)bID categoryID:(NSString *)cID name:(NSString *)name picture:(NSString *)picture weight:(NSInteger)weight wordCount:(NSInteger)count showTone:(BOOL)showTone version:(NSString *)version completion:(void(^)(BOOL finished, id obj, NSError *error))completion;

/**
 *  查询所有的词书信息
 *
 *  @return 所有的词书信息
 */
+ (NSArray *)queryWordBookInfos;

/**
 *  根据词书种类ID 来查询词书的信息
 *
 *  @param cID 词书种类ID, 需要从词书种类数据库中查找出来
 *
 *  @return 特定词书种类下的所有的词书
 */
+ (NSArray *)queryWordBookInfosWithCategoryID:(NSString *)cID;

/**
 *  查询指定的词书，根据词书种类ID，和词书ID
 *
 *  @param cID 词书种类ID
 *  @param bID 词书ID
 *
 *  @return 某一本词书
 */
+ (BookModel *)queryWordBookWithCategoryID:(NSString *)cID bookID:(NSString *)bID;

/**
 *  所有的词书的数量
 *
 *  @return 数量
 */
+ (NSInteger)wordBookCount;

/**
 *  指定词书种类下面的词书的数量
 *
 *  @param cID 词书种类ID
 *
 *  @return 数量
 */
+ (NSInteger)wordBookCountWithCategoryID:(NSString *)cID;

/**
 *  词书翻译的数据
 *
 *  @param bID    词书ID
 *  @param language 语言，可能为中文，
 *
 *  @return 词书字段的翻译
 */
+ (BookTranslationModel *)queryWordBookTranslationWithBookID:(NSString *)bID language:(NSString *)language;

#pragma mark - Fetch
/**
 *  使用fetch方式来查询所有的数据
 *   -- 所有返回的值（结果）都会在返回的fetchResultsController的代理中得到处理。
 *
 *  @param delegate fetchController的代理，所有通过fetchController得到的值都在这个代理里面处理
 *
 *  @return 返回的值，一般为NSFetchedResultsController的对象。
 */
+ (id)fetchAllWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate;

/**
 *  使用fetch方式来查询所有的数据
 *   -- 所有返回的值（结果）都会在返回的fetchResultsController的代理中得到处理。
 *
 *  @param delegate fetchController的代理，所有通过fetchController得到的值都在这个代理里面处理
 *  @param cID 词书种类ID。
 *
 *  @return 返回的值，一般为NSFetchedResultsController的对象。
 */
+ (id)fetchAllWithDelegate:(id<NSFetchedResultsControllerDelegate>)delegate categoryID:(NSString *)cID;

@end
