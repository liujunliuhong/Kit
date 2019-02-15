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


@end
NS_ASSUME_NONNULL_END
