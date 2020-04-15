//
//  NSDictionary+YHExtension.h
//  Kit
//
//  Created by apple on 2019/1/17.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSDictionary (YHExtension)


#pragma mark - 字典解析
//*************************************************************************************
//*************************************************************************************
//*************************************************************************************

// 用于后台返回的json解析，一般情况下后台返回的数据包含NSDictionary、NSArray、NSNumber、NSString、NSNull.
// 个人不喜欢使用MJExtension或者YYModel，更喜欢手动解析数据，因此写了下面三个方法.
// yh_decodeToStringWithKey:defaultStringValue     强制把字典里面的某个key关联的数据解析为字符串
// yh_decodeToArrayWithKey:defaultArrayValue       把字典里面的某个key关联的数据解析成为数组，内部做了判断，如果解析出来的数据不是NSArray类型，则使用defaultArrayValue，保证返回的数据一定是NSArray类型的数据
// yh_decodeToDictionaryWithKey:defaultDictionaryValue      把字典里面的某个key关联的数据解析成为字典，内部做了判断，如果解析出来的数据不是NSDictionary类型，则使用defaultDictionaryValue，保证返回的数据一定是NSDictionary类型的数据
- (NSString *)yh_decodeToStringWithKey:(NSString *)key defaultStringValue:(NSString *)defaultStringValue;
- (NSArray *)yh_decodeToArrayWithKey:(NSString *)key defaultArrayValue:(NSArray *)defaultArrayValue;
- (NSDictionary *)yh_decodeToDictionaryWithKey:(NSString *)key defaultDictionaryValue:(NSDictionary *)defaultDictionaryValue;


//*************************************************************************************
//*************************************************************************************
//*************************************************************************************








// NSDictionary to json string.
@property (nonatomic, strong, readonly, nullable) NSString *yh_jsonStringEncode;











@end
NS_ASSUME_NONNULL_END
