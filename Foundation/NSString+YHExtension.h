//
//  NSString+YHExtension.h
//  Kit
//
//  Created by 银河 on 2018/12/28.
//  Copyright © 2018 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const k_YH_Email_Regex = @"^[a-zA-Z0-9]+@[a-zA-Z0-9.]+\\.[a-zA-Z0-9]+$";
static NSString *const k_YH_URL_Regex = @"^(https?|ftps?|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]";
static NSString *const k_YH_Chinese_Regex = @"[\\u4e00-\\u9fa5\\w\\-]+";

@interface NSString (YHExtension)

// Determine whether a string is an integer.
@property (nonatomic, assign, readonly) BOOL yh_isInt;

// Determine whether a string is empty.
// 注意:空对象不会调用    比如 NSString *str = nil;   str.yh_isEmpty    此时返回NO
@property (nonatomic, assign, readonly) BOOL yh_isEmpty;

// Determine whether a string contain chinese.
@property (nonatomic, assign, readonly) BOOL yh_isContainChinese;

// Determine whether a string contain emoji.
@property (nonatomic, assign, readonly) BOOL yh_isContainEmoji;

// Get pinyin.
@property (nonatomic, copy, readonly) NSString *yh_pinYin;

// JSON string decode.
@property (nonatomic, strong, readonly, nullable) id yh_jsonStringDecode;

// Determine whether a string is an email.
@property (nonatomic, assign, readonly) BOOL yh_isEmail;

// Determine whether a string is an URL.
@property (nonatomic, assign, readonly) BOOL yh_isURL;

// URL transcoding if contain chinese.
@property (nonatomic, copy, readonly) NSString *yh_urlTranscoding;

// timeStamp -> timeString.
// yyyy-MM-dd HH:mm:ss
- (nullable NSString *)yh_timeStampToTimeStringWithFormat:(NSString *)format;

// timeString -> NSDate.
// yyyy-MM-dd HH:mm:ss
- (nullable NSDate *)yh_timeStringToDateWithWithFormat:(NSString *)format;

// timeStamp -> NSDate.
// 时间戳可以是10位或者13位.
// yyyy-MM-dd HH:mm:ss
- (nullable NSDate *)yh_timeStampToDateWithFormat:(NSString *)format;

// Determine whether a string is legal.
- (BOOL)yh_validateWithRegex:(NSString *)regex;









@end
NS_ASSUME_NONNULL_END
