//
//  NSArray+YHExtension.h
//  Kit
//
//  Created by 银河 on 2019/1/17.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (YHExtension)

// NSArray to json string.
@property (nonatomic, strong, readonly, nullable) NSString *yh_jsonStringEncode;

@end

NS_ASSUME_NONNULL_END
