//
//  YHLocation.h
//  Kit
//
//  Created by 银河 on 2019/2/12.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHLocation : NSObject

// System location.
// 单次定位.
// 使用中才定位.
+ (void)startLocationWithTarget:(id)target completionBlock:(void(^_Nullable)(CLPlacemark *_Nullable placemark, NSError *_Nullable error))completionBlock;

@end

NS_ASSUME_NONNULL_END
