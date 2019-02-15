//
//  YHAuthorizetionMicrophone.h
//  chanDemo
//
//  Created by apple on 2019/1/5.
//  Copyright © 2019 银河. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * the microphone authorizetion.
 */
NS_CLASS_AVAILABLE_IOS(8_0) @interface YHAuthorizetionMicrophone : NSObject

// Determine whether authorization is currently available.
+ (BOOL)isAuthorized;

// Request microphone authorizetion.
+ (void)requestAuthorizetionWithCompletion:(void(^)(BOOL granted, BOOL isFirst))completion;

@end
NS_ASSUME_NONNULL_END
