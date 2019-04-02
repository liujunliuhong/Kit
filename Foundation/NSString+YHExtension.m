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
    return !self || self.length == 0 || [self isEqualToString:@""] || [self isEqual:[NSNull null]] || self == nil || [self isEqualToString:@"null"] || [self isEqualToString:@"NSNull"];
}

// Determine whether a string contain chinese.
- (BOOL)yh_isContainChinese{
    NSArray<NSTextCheckingResult *> *matches = [[NSRegularExpression regularExpressionWithPattern:k_YH_Chinese_Regex options:NSRegularExpressionDotMatchesLineSeparators error:nil] matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return matches.count > 0;
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
    transcodingString = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
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
// 时间戳可以是10位或者13位.
// yyyy-MM-dd HH:mm:ss
- (NSDate *)yh_timeStampToDateWithFormat:(NSString *)format{
    NSDate *date = nil;
    if (self.yh_isInt) {
        if (self.length == 10) {
            // if length is 10.
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = format;
            date = [NSDate dateWithTimeIntervalSince1970:[self integerValue]];
        } else if (self.length == 13) {
            // if length is 13.
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = format;
            date = [NSDate dateWithTimeIntervalSince1970:[self integerValue] / 1000];
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
