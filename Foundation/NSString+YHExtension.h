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

@interface NSString (YHExtension)

// Determine whether a string is an integer.
@property (nonatomic, assign, readonly) BOOL yh_isInt;

// Determine whether a string is empty.
@property (nonatomic, assign, readonly) BOOL yh_isEmpty;

// timeStamp -> NSDate.
// yyyy-MM-dd HH:mm:ss.
@property (nonatomic, strong, readonly, nullable) NSDate *yh_date;

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
- (nullable NSString *)yh_timeStringWithFormat:(NSString *)format;

// Determine whether a string is legal.
- (BOOL)yh_validateWithRegex:(NSString *)regex;









@end
NS_ASSUME_NONNULL_END
