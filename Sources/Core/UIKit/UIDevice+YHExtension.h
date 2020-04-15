//
//  UIDevice+YHExtension.h
//  chanDemo
//
//  Created by apple on 2019/1/2.
//  Copyright © 2019 银河. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIDevice (YHExtension)


// Get the device name. Such as 'iPhone 7 Plus'.
@property (nonatomic, copy, readonly) NSString *yh_deviceName;


/**
 * 是否是iPhone X系列手机(刘海屏手机)
 * 备用判断方法，要跟着Apple每年发布新版手机的变化而调整
 */
+ (BOOL)yh_isIphoneX;

@end
NS_ASSUME_NONNULL_END
