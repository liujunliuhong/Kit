//
//  NSObject+YHExtension.m
//  chanDemo
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 银河. All rights reserved.
//

#import "NSObject+YHExtension.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import <CoreData/CoreData.h>

#ifdef DEBUG
    #define YHDebugLog(format, ...)  printf("[YHDebugLog] [NSObject (YHExtension)] [%s] [%d] %s\n" ,[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
#else
    #define YHDebugLog(format, ...)
#endif

@interface NSObject()

@end

@implementation NSObject (YHExtension)

// Determine whether an object is Foundation class.
- (BOOL)yh_isFoundationClass{
    __block BOOL result = NO;
    NSSet<Class> *foundationClasses = [NSSet setWithObjects:
                                       [NSURL class],
                                       [NSDate class],
                                       [NSValue class],
                                       [NSData class],
                                       [NSError class],
                                       [NSArray class],
                                       [NSDictionary class],
                                       [NSString class],
                                       [NSAttributedString class], nil];
    
    if ((self.class == [NSObject class]) || (self.class == [NSManagedObject class])) {
        result = YES;
    } else {
        [foundationClasses enumerateObjectsUsingBlock:^(Class  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([self.class isSubclassOfClass:obj]) {
                result = YES;
                *stop = YES;
            }
        }];
    }
    return result;
}

// Always use in debug.
- (id)yh_description{
    if (self.yh_isFoundationClass) {
        return [NSString stringWithFormat:@"[Description] %@",self];
    }
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
    if (outCount == 0) {
        return @"[Description] This objct has no properties.";
    }
    NSMutableDictionary *descriptionDic = [NSMutableDictionary dictionary];
    for (int i = 0; i < outCount; i ++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        id value = [self valueForKeyPath:propertyName];
        if (!value) {
            value = @"";
        }
        [descriptionDic setObject:value forKey:propertyName];
    }
    if (descriptionDic.count == 0) {
        return @"[Description] This objct has no properties.";
    } else {
        return [NSString stringWithFormat:@"[Description] %@",descriptionDic];
    }
}

// Determine whether a object is an empty.
- (BOOL)yh_isNilOrNull{
    return ((self == nil) || ([self isEqual:[NSNull null]]) || (!self));
}

// Determine whether a object is an NSString class.
- (BOOL)yh_is_NSString{
    return [self isKindOfClass:[NSString class]];
}

// Determine whether a object is an NSArray class.
- (BOOL)yh_is_NSArray{
    return [self isKindOfClass:[NSArray class]];
}

// Determine whether a object is an NSDictionary class.
- (BOOL)yh_is_NSDictionary{
    return [self isKindOfClass:[NSDictionary class]];
}

// Determine whether a object is an NSNumber class.
- (BOOL)yh_is_NSNumber{
    return [self isKindOfClass:[NSNumber class]];
}

// Get topViewController.
- (UIViewController *)yh_topViewController{
    UIViewController *vc = [self topViewControllerWithRootViewController:[UIApplication sharedApplication].delegate.window.rootViewController];
    YHDebugLog(@"TopViewController:%@",vc);
    return vc;
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    if (rootViewController.childViewControllers.count > 0) {
        return [self topViewControllerWithRootViewController:rootViewController.childViewControllers.lastObject];
    } else {
        if ([rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabBarController = (UITabBarController*)rootViewController;
            return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
        } else if (rootViewController.presentedViewController) {
            UIViewController *presentedViewController = rootViewController.presentedViewController;
            return [self topViewControllerWithRootViewController:presentedViewController];
        } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navigationController = (UINavigationController*)rootViewController;
            return [self topViewControllerWithRootViewController:navigationController.topViewController];
        } else {
            return rootViewController;
        }
    }
}


// make call.
+ (void)yh_makeCallWithPhone:(NSString *)phone{
    if (!phone) {
        return;
    }
    NSString *string = [NSString stringWithFormat:@"tel://%@",phone];
    NSURL *url = [NSURL URLWithString:string];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}

// open app settings.
+ (void)yh_openAppSettings{
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

// Open App Store.
+ (void)yh_openAppStoreWithAppID:(NSString *)appID{
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@",appID];
    NSURL *url = [NSURL URLWithString:urlString];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}

// Send SMS without SMS content.
// If you want to send SMS with content, please use 'YHSendSMS'.
+ (void)yh_sendSmsWithoutContentWithPhone:(NSString *)phone{
    NSString *string = [NSString stringWithFormat:@"sms://%@",phone];
    NSURL *url = [NSURL URLWithString:string];
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url];
    }
}

// Get local json file.
+ (id)yh_getLocalJsonFileWithFileName:(NSString *)fileName{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        YHDebugLog(@"Get local json file faild : %@", error);
    } else {
        YHDebugLog(@"Get local json file successful.");
    }
    return result;
}

// Get local plist file.
+ (id)yh_getLocalPlistFileWithFileName:(NSString *)fileName{
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error = nil;
    //id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    id result = [NSPropertyListSerialization propertyListWithData:data options:0 format:NULL error:&error];
    if (error) {
        YHDebugLog(@"Get local plist file faild : %@", error);
    } else {
        YHDebugLog(@"Get local plist file successful.");
    }
    return result;
}

@end
