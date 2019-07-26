//
//  AppDelegate+YHNotiExtension.m
//  Kit
//
//  Created by apple on 2019/1/31.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "AppDelegate+YHNotiExtension.h"
#import <objc/message.h>
#import <UserNotifications/UserNotifications.h>
#import "YHMacro.h"

@interface AppDelegate() <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate (YHNotiExtension)

// 注册远程推送
- (void)yh_registerRemoteNotificationWithOptions:(NSDictionary *)launchOptions{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        if (@available(iOS 10.0, *)) {
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            center.delegate = self;
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                YHDebugLog(@"推送设置状态:granted:%d,error:%@", granted, error);
            }];
        }
    } else {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    
    
    if (launchOptions) {
        NSDictionary *remoteInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSDictionary *localInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
        if (remoteInfo) {
            self.yh_remoteNotiInfoBlock ? self.yh_remoteNotiInfoBlock(remoteInfo) : nil;
            YHDebugLog(@"进入应用，获取到远程推送:%@", remoteInfo);
        }
        if (localInfo) {
            self.yh_localNotiInfoBlock ? self.yh_localNotiInfoBlock(localInfo) : nil;
            YHDebugLog(@"进入应用，获取到本地推送:%@", remoteInfo);
        }
    }
}

#pragma mark ------------------------------------
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    YHDebugLog(@"推送设置成功");
}

#pragma mark ------------------------------------
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    YHDebugLog(@"注册推送失败:%@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *deviceTokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString: @""];
    self.yh_deviceTokenBlock ? self.yh_deviceTokenBlock(deviceTokenString, deviceToken) : nil;
    YHDebugLog(@"注册推送成功:%@", deviceToken);
}

#pragma mark ------------------------------------
// 收到本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    YHDebugLog(@"收到本地推送\n:%s\n%@", __func__, notification.userInfo);
    self.yh_localNotiInfoBlock ? self.yh_localNotiInfoBlock(notification.userInfo) : nil;
}

// 收到远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    YHDebugLog(@"收到远程推送\n:%s\n%@", __func__, userInfo);
    self.yh_remoteNotiInfoBlock ? self.yh_remoteNotiInfoBlock(userInfo) : nil;
    self.yh_handleNotiInfoBlock ? self.yh_handleNotiInfoBlock(userInfo) : nil;
    completionHandler(UIBackgroundFetchResultNewData);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    YHDebugLog(@"收到远程推送\n:%s\n%@", __func__, userInfo);
    self.yh_remoteNotiInfoBlock ? self.yh_remoteNotiInfoBlock(userInfo) : nil;
    self.yh_handleNotiInfoBlock ? self.yh_handleNotiInfoBlock(userInfo) : nil;
}




#pragma mark ------------------------------------
// iOS 10
// APP在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    YHDebugLog(@"iOS 10，前台获取到推送:%@", notification.request.content.userInfo);
    NSDictionary *info = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        self.yh_handleNotiInfoBlock ? self.yh_handleNotiInfoBlock(info) : nil;
    }
    //completionHandler(UNNotificationPresentationOptionAlert);//在前台收到通知时，提醒用户，如果注释掉，在前台时，不提醒
}

// iOS 10
// 点击通知，进入APP
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    NSDictionary *info = response.notification.request.content.userInfo;
    YHDebugLog(@"iOS 10，点击推送，进入APP:%@", info);
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        self.yh_remoteNotiInfoBlock ? self.yh_remoteNotiInfoBlock(info) : nil;
        self.yh_handleNotiInfoBlock ? self.yh_handleNotiInfoBlock(info) : nil;
    }
    completionHandler();
}











- (void)setYh_localNotiInfoBlock:(void (^)(NSDictionary * _Nonnull))yh_localNotiInfoBlock{
    objc_setAssociatedObject(self, @selector(yh_localNotiInfoBlock), yh_localNotiInfoBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(NSDictionary * _Nonnull))yh_localNotiInfoBlock{
    return objc_getAssociatedObject(self, @selector(yh_localNotiInfoBlock));
}


- (void)setYh_remoteNotiInfoBlock:(void (^)(NSDictionary * _Nonnull))yh_remoteNotiInfoBlock{
    objc_setAssociatedObject(self, @selector(yh_remoteNotiInfoBlock), yh_remoteNotiInfoBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(NSDictionary * _Nonnull))yh_remoteNotiInfoBlock{
    return objc_getAssociatedObject(self, @selector(yh_remoteNotiInfoBlock));
}


- (void)setYh_deviceTokenBlock:(void (^)(NSString * _Nonnull, NSData * _Nonnull))yh_deviceTokenBlock{
    objc_setAssociatedObject(self, @selector(yh_deviceTokenBlock), yh_deviceTokenBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(NSString * _Nonnull, NSData * _Nonnull))yh_deviceTokenBlock{
    return objc_getAssociatedObject(self, @selector(yh_deviceTokenBlock));
}


- (void)setYh_handleNotiInfoBlock:(void (^)(NSDictionary * _Nullable))yh_handleNotiInfoBlock{
    objc_setAssociatedObject(self, @selector(yh_handleNotiInfoBlock), yh_handleNotiInfoBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSDictionary * _Nullable))yh_handleNotiInfoBlock{
    return objc_getAssociatedObject(self, @selector(yh_handleNotiInfoBlock));
}



@end
