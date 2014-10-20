//
//  NSString+expand.m
//  I8
//
//

#import "NSString+expand.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (expand)

- (NSString *)MD5EncodedString
{
	unsigned char result[CC_MD5_DIGEST_LENGTH];
    NSData *dataStr = [self dataUsingEncoding:NSUTF8StringEncoding];
	CC_MD5([dataStr bytes], [dataStr length], result);
    NSString *md5String = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
	return md5String;
}

+ (NSString *)stringWithUUID_i8
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f) {
        NSUUID *uuid = [NSUUID UUID];
        NSString *string = [uuid UUIDString];
        return string;
    }else{
        CFUUIDRef	uuidObj = CFUUIDCreate(nil);
        NSString	*uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
        CFRelease(uuidObj);
        return uuidString;
    }
}

- (BOOL)isWhitespaceAndNewlines {
    NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i) {
        unichar c = [self characterAtIndex:i];
        if (![whitespace characterIsMember:c]) {
            return NO;
        }
    }
    return YES;
}

+(NSString *)safeString:(NSString *)str{
    if (str == nil || [str isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return str;
}

+(BOOL)isNullString:(NSString *)string{
    BOOL isNull = [string isKindOfClass:[NSString class]] && ([string length] > 0);
    return !isNull;
    
    if (string == nil) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    return NO;
}


- (BOOL)isEqualForCaseInsensitive:(NSString *)string{
    return ([self caseInsensitiveCompare:string] == NSOrderedSame);
}


@end
