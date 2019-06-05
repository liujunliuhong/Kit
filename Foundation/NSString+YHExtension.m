//
//  NSString+YHExtension.m
//  Kit
//
//  Created by 银河 on 2018/12/28.
//  Copyright © 2018 yinhe. All rights reserved.
//

#import "NSString+YHExtension.h"
#import "NSDate+YHExtension.h"

#ifdef DEBUG
    #define YHDebugLog(format, ...)  printf("[YHDebugLog] [NSString (YHExtension)] [%s] [%d] %s\n" ,[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
#else
    #define YHDebugLog(format, ...)
#endif

@implementation NSString (YHExtension)

// determine whether a string is an integer.
- (BOOL)yh_isInt{
    // Avoid objects that are not string types.
    NSString *tmp = [NSString stringWithFormat:@"%@",self];
    NSScanner *scan = [NSScanner scannerWithString:tmp];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

// Determine whether a string is empty.
- (BOOL)yh_isEmpty{
    return !self || self.length == 0 || [self isEqualToString:@""] || [self isEqual:[NSNull null]] || self == nil || [self isEqualToString:@"null"] || [self isEqualToString:@"NSNull"] || [self isEqualToString:@"<null>"];
}

// Determine whether a string contain chinese.
- (BOOL)yh_isContainChinese{
    NSArray<NSTextCheckingResult *> *matches = [[NSRegularExpression regularExpressionWithPattern:k_YH_Chinese_Regex options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return matches.count > 0;
}

// Determine whether a string contain emoji.
- (BOOL)yh_isContainEmoji{
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

// Get pinyin.
- (NSString *)yh_pinYin{
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = [mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return pinyinString;
}

// JSON string decode.
- (id)yh_jsonStringDecode{
    if (!self) {
        return nil;
    }
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id value = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (!err && value) {
        YHDebugLog(@"JSON string decode successful.");
        return value;
    } else {
        YHDebugLog(@"JSON string decode failed, error : %@.", err);
        return nil;
    }
}

// Determine whether a string is an email.
- (BOOL)yh_isEmail{
    NSPredicate *emailReg = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", k_YH_Email_Regex];
    return [emailReg evaluateWithObject:self];
}

// Determine whether a string is an URL.
- (BOOL)yh_isURL{
    NSPredicate *urlReg = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", k_YH_URL_Regex];
    return [urlReg evaluateWithObject:self];
}

// URL transcoding if contain chinese.
- (NSString *)yh_urlTranscoding{
    NSString *transcodingString = @"";
    if (self.length == 0 || !self) {
        return transcodingString;
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    NSString * kCharactersGeneralDelimitersToEncode = @":#[]@";
    NSString * kCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    NSMutableCharacterSet *allowedCharacterSet = (NSMutableCharacterSet *)[NSMutableCharacterSet URLQueryAllowedCharacterSet];
    [allowedCharacterSet removeCharactersInString:[kCharactersGeneralDelimitersToEncode stringByAppendingString:kCharactersSubDelimitersToEncode]];
    transcodingString = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
#else
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    transcodingString = [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
#endif
    return transcodingString;
}

// timeStamp -> timeString.
// yyyy-MM-dd HH:mm:ss
- (NSString *)yh_timeStampToTimeStringWithFormat:(NSString *)format{
    NSString *timeString = nil;
    NSDate *date = [self yh_timeStampToDateWithFormat:format];
    if (date) {
        timeString = [date yh_dateStringWithFormat:format];
    }
    return timeString;
}

- (NSString *)yh_timeStringToTimeStampWithFormat:(NSString *)format{
    NSDate *date = [self yh_timeStringToDateWithWithFormat:format];
    if (date) {
        return date.yh_timeStamp;
    } else {
        return nil;
    }
}

// timeString -> NSDate.
// yyyy-MM-dd HH:mm:ss
- (NSDate *)yh_timeStringToDateWithWithFormat:(NSString *)format{
    if (self.yh_isEmpty) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    NSDate *date = [dateFormatter dateFromString:self];
    return date;
}

// timeStamp -> NSDate.
// 时间戳可以是13位.
// yyyy-MM-dd HH:mm:ss
- (NSDate *)yh_timeStampToDateWithFormat:(NSString *)format{
    NSDate *date = nil;
    if (self.yh_isInt) {
        if (self.length == 13) {
            // if length is 13.
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = format;
            date = [NSDate dateWithTimeIntervalSince1970:[self integerValue] / 1000];
        } else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = format;
            date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
        }
    }
    return date;
}

// Determine whether a string is legal.
- (BOOL)yh_validateWithRegex:(NSString *)regex{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:self];
}














@end
