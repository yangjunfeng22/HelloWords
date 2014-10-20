//
//  NSString+expand.h
//

#import <Foundation/Foundation.h>

@interface NSString (expand)

- (NSString *)MD5EncodedString;
+ (NSString *)stringWithUUID_i8;

+(NSString *)safeString:(NSString *)str;
+(BOOL)isNullString:(NSString *)string;
//+(NSString *)stringFromInt:(NSInteger)integer;

- (BOOL)isWhitespaceAndNewlines;

/*!
 *  不区分大小写比较字符串
 *
 *  @param string 另一个字符串
 *
 *  @return 相同返回YES，否则返回NO
 */
- (BOOL)isEqualForCaseInsensitive:(NSString *)string;

@end
