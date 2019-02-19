//
//  NSDictionary+YHExtension.m
//  Kit
//
//  Created by apple on 2019/1/17.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "NSDictionary+YHExtension.h"

#ifdef DEBUG
    #define YHDebugLog(format, ...)  printf("[YHDebugLog] [NSDictionary (YHExtension)] [%s] [%d] %s\n" ,[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
#else
    #define YHDebugLog(format, ...)
#endif

@implementation NSDictionary (YHExtension)

#pragma mark - 字典解析
//*************************************************************************************
//*************************************************************************************
//*************************************************************************************

- (NSString *)yh_decodeToStringWithKey:(NSString *)key defaultStringValue:(NSString *)defaultStringValue{
    NSString *result = defaultStringValue;
    if (self && [self.allKeys containsObject:key]) {
        id object = self[key];
        result = [NSString stringWithFormat:@"%@",object];
    }
    return result;
}

- (NSArray *)yh_decodeToArrayWithKey:(NSString *)key defaultArrayValue:(NSArray *)defaultArrayValue{
    NSArray *result = defaultArrayValue;
    if (self &&[self.allKeys containsObject:key]) {
        id object = self[key];
        if ([object isKindOfClass:[NSArray class]]) {
            result = object;
        }
    }
    return result;
}

- (NSDictionary *)yh_decodeToDictionaryWithKey:(NSString *)key defaultDictionaryValue:(NSDictionary *)defaultDictionaryValue{
    NSDictionary *result = defaultDictionaryValue;
    if (self && [self.allKeys containsObject:key]) {
        id object = self[key];
        if ([object isKindOfClass:[NSDictionary class]]) {
            result = object;
        }
    }
    return result;
}

//*************************************************************************************
//*************************************************************************************
//*************************************************************************************















- (NSString *)yh_jsonStringEncode{
    NSString *result = nil;
    if (self && [NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments
                                                         error:&error];
        if (!error && data) {
            YHDebugLog(@"NSDictionary to json successful.");
            result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        } else {
            YHDebugLog(@"NSDictionary to json failed, error : %@.", error);
        }
    }
    return result;
}













@end
