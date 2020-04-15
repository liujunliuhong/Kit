//
//  NSArray+YHExtension.m
//  Kit
//
//  Created by 银河 on 2019/1/17.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "NSArray+YHExtension.h"

#ifdef DEBUG
    #define YHDebugLog(format, ...)  printf("[YHDebugLog] [NSArray (YHExtension)] [%s] [%d] %s\n" ,[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
#else
    #define YHDebugLog(format, ...)
#endif

@implementation NSArray (YHExtension)

- (NSString *)yh_jsonStringEncode{
    NSString *result = nil;
    if (self && [NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                         error:&error];
        
        if (!error && data) {
            YHDebugLog(@"NSArray to json successful.");
            result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        } else {
            YHDebugLog(@"NSArray to json failed, error : %@.", error);
        }
    }
    return result;
}


@end
