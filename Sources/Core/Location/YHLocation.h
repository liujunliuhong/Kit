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
// 使用前请先调用requestLocationAuthorizationStatusWhenInUseWithTarget方法
+ (void)startLocationWithTarget:(id)target completionBlock:(void(^_Nullable)(CLPlacemark *_Nullable placemark, NSError *_Nullable error))completionBlock;

// 获取当前的定位授权状态
+ (CLAuthorizationStatus)locationAuthorizationStatus;

// 获取定位使用中的授权状态
+ (void)requestLocationAuthorizationStatusWhenInUseWithTarget:(id)target completionBlock:(void(^_Nullable)(BOOL granted, NSError *_Nullable error))completionBlock;

@end

NS_ASSUME_NONNULL_END
