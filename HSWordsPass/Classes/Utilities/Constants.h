//
//  Constants.h
//  HSWordsPass
//
//  Created by yang on 14-8-28.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#ifndef HSWordsPass_Constants_h
#define HSWordsPass_Constants_h

#define kLoginMethod    @"user/login"
#define kRegistMethod   @"user/register"
#define kFindPassword   @"user/passwordBack"
#define kDownloadFile   @"file/address"

#define kBookCategory   @"book/category"
#define kBookList       @"book/list"
#define kWordList       @"word/list"
#define kWordSentence   @"word/sentence"
#define kCheckPointList @"checkpoint/list"
#define kProgressUpdate @"checkpoint/progress/update"
// 关卡版本
#define kCheckPointVersion @"checkpoint/version"
// 关卡-词对应关系
#define kCheckPointWords @"checkpoint/words"
#define kPracticeRecord @"learnt/update"
#define kWordNoteUpdate @"word/note/update"
// 更新版本
#define kUpdateApp    @"version/check"
// 推荐应用
#define KAppRecommend @"product/list"
// 关卡版本
#define kCheckPointVersion @"checkpoint/version"
// 词书版本
#define kBookVersion @"book/version"


//#define kHostUrl @"http://www.hellohsk.com/app/api/"
#define kHostUrl @"http://api.hellohsk.com/wordpass/"
//#define kHostUrl @"http://192.168.10.155/wordpass/"
//#define kHostUrl @"http://test.hellohsk.com/app/api/"
//#define kHostUrl @"http://192.168.10.89/hellohsk/app/api/"
//#define kTempHostUrl @"http://192.168.10.89/hellohsk/app/api/"
//#define kMissageUrl @"http://192.168.10.98/hellohsk/code/app/api/"


#define kMD5_KEY @"hansheng"

#define kSoftwareVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#ifdef DEBUG
#define kDownloadingPath [kDocumentPath stringByAppendingPathComponent:@"Downloading"]
#define kDownloadedPath  [kDocumentPath stringByAppendingPathComponent:@"Downloaded"]
#else
#define kDownloadingPath [kCachePath stringByAppendingPathComponent:@"Downloading"]
#define kDownloadedPath [kCachePath stringByAppendingPathComponent:@"Downloaded"]
#endif


#define kWhiteColor [[UIColor alloc] initWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]
#define kBlackColor [[UIColor alloc] initWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f]
#define kClearColor [UIColor clearColor]
#define kNavigationBarHeight ((UINavigationController *)((UIWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0]).rootViewController).navigationBar.bounds.size.height
#define kNavigationBarWidth  ((UINavigationController *)((UIWindow *)[[UIApplication sharedApplication].windows objectAtIndex:0]).rootViewController).navigationBar.bounds.size.width

#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#define kiOS7_Y_Offset (kStatusBarHeight + kNavigationBarHeight)

#define kCheckPointTag 1000
#define kBookCategoryTag 2000

#define kWordCheckTopic 3000
#define kWordCheckTopicCardBtnTag 4000

#define wordLearnTag 10000
#define newWordLearnTag 20000
#define exampleSentenceViewTag 30000

// 归档所需次数
#define kFileTimes 5
// 归档所需百分比
#define kFilePercent 0.8f

#define kAppDelegate ((HSAppDelegate *)[UIApplication sharedApplication].delegate)

// UserDefaults中词书种类/词书ID的Key。
#define kUDKEY_CategoryID @"CategoryID"
#define kUDKEY_BookID @"BookID"
#define kUDKEY_UserID @"UserID"
#define kUDKEY_Email @"Email"
// 当前的测试是否需要显示拼音
#define kUDKEY_ShowTone @"ShowTone"

#define kGlobalFontName @"Helvetica"
#define kGlobalFontNameB @"Helvetica-Bold"

#define kGlobalFontSize 12
#define kCheckPointFontSize 17

//
#define kSetUDUserID(ID) ([[NSUserDefaults standardUserDefaults] setObject:ID forKey:kUDKEY_UserID], [[NSUserDefaults standardUserDefaults] synchronize])
#define kSetUDUserEamil(email) ([[NSUserDefaults standardUserDefaults] setObject:email forKey:kUDKEY_Email], [[NSUserDefaults standardUserDefaults] synchronize])
#define kSetUDCategoryID(ID) ([[NSUserDefaults standardUserDefaults] setObject:ID forKey:kUDKEY_CategoryID], [[NSUserDefaults standardUserDefaults] synchronize])
#define kSetUDBookID(ID) ([[NSUserDefaults standardUserDefaults] setObject:ID forKey:kUDKEY_BookID], [[NSUserDefaults standardUserDefaults] synchronize])
#define kSetUDShowTone(show) ([[NSUserDefaults standardUserDefaults] setBool:show forKey:kUDKEY_ShowTone], [[NSUserDefaults standardUserDefaults] synchronize])

#define kUserID [[NSUserDefaults standardUserDefaults] objectForKey:kUDKEY_UserID]
#define kEmail [[NSUserDefaults standardUserDefaults] objectForKey:kUDKEY_Email]
#define kCategoryID [[NSUserDefaults standardUserDefaults] objectForKey:kUDKEY_CategoryID]
#define kBookID  [[NSUserDefaults standardUserDefaults] objectForKey:kUDKEY_BookID]
#define kShowTone [[NSUserDefaults standardUserDefaults] boolForKey:kUDKEY_ShowTone]

#define DEPRECATED(_version) __attribute__((deprecated))

#endif



#define hsShineBlueColor HEXCOLOR(@"00aee0")
//RGBACOLOR(21.0f, 129.0f, 198.0f, 1.0f)
#define hsGlobalBlueColor RGBACOLOR(0.0f, 174.0f, 224.0f, 1.0f)
#define hsGlobalLineColor HEXCOLOR(@"f4f4f4")
#define hsGlobalWordColor HEXCOLOR(@"777777")
