//
//  NSObject+YHExtension.h
//  chanDemo
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 银河. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSObject (YHExtension)

// Determine whether an object is Foundation class.
@property (nonatomic, assign, readonly) BOOL yh_isFoundationClass;

// The description with object.
// Always use in debug.
@property (nonatomic, strong, readonly, nullable) id yh_description;

// Determine whether a object is an empty.
@property (nonatomic, assign, readonly) BOOL yh_isNilOrNull;

// Determine whether a object is an NSString class.
@property (nonatomic, assign, readonly) BOOL yh_is_NSString;

// Determine whether a object is an NSArray class.
@property (nonatomic, assign, readonly) BOOL yh_is_NSArray;

// Determine whether a object is an NSDictionary class.
@property (nonatomic, assign, readonly) BOOL yh_is_NSDictionary;

// Determine whether a object is an NSNumber class.
@property (nonatomic, assign, readonly) BOOL yh_is_NSNumber;

// Get topViewController.
@property (nonatomic, strong, readonly) UIViewController *yh_topViewController;

// make call.
+ (void)yh_makeCallWithPhone:(NSString *)phone;

// open app settings.
+ (void)yh_openAppSettings;

// Open App Store.
+ (void)yh_openAppStoreWithAppID:(NSString *)appID;

// Open App Store Review.
+ (void)yh_openAppStoreReviewWithAppID:(NSString *)appID;

// Send SMS without SMS content.
// If you want to send SMS with content, please use 'YHSendSMS'.
+ (void)yh_sendSmsWithoutContentWithPhone:(NSString *)phone;

// Get local json file.
+ (nullable id)yh_getLocalJsonFileWithFileName:(NSString *)fileName;

// Get local plist file.
+ (nullable id)yh_getLocalPlistFileWithFileName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
