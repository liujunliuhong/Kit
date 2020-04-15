//
//  YHAuthorizetionPhotos.h
//  chanDemo
//
//  Created by apple on 2019/1/5.
//  Copyright © 2019 银河. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * the photo authorizetion.
 */
NS_CLASS_AVAILABLE_IOS(8_0) @interface YHAuthorizetionPhotos : NSObject

// Determine whether authorization is currently available.
+ (BOOL)isAuthorized;

// Request photo authorizetion.
+ (void)requestAuthorizetionWithCompletion:(void(^_Nullable)(BOOL granted, BOOL isFirst))completion;

@end
NS_ASSUME_NONNULL_END
