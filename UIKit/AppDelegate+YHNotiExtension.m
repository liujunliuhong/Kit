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
                if (!error) {
                    NSLog(@"succeeded!");
                }
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
        }
        if (localInfo) {
            self.yh_localNotiInfoBlock ? self.yh_localNotiInfoBlock(localInfo) : nil;
        }
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    NSLog(@"通知注册成功");
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"通知注册失败:%@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *deviceTokenString = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@" " withString: @""];
    self.yh_deviceTokenBlock ? self.yh_deviceTokenBlock(deviceTokenString) : nil;
    NSLog(@"用户同意接收通知:%@", deviceToken);
}


// 收到本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    self.yh_localNotiInfoBlock ? self.yh_localNotiInfoBlock(notification.userInfo) : nil;
}

// 收到远程通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    self.yh_remoteNotiInfoBlock ? self.yh_remoteNotiInfoBlock(userInfo) : nil;
    completionHandler(UIBackgroundFetchResultNewData);
}






// iOS 10
// APP在前台获取到通知
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler API_AVAILABLE(ios(10.0)){
    NSLog(@"前台获取到通知");
    completionHandler(UNNotificationPresentationOptionAlert);//在前台收到通知时，提醒用户，如果注释掉，在前台时，不提醒
}

// iOS 10
// 点击通知，进入APP
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0)){
    NSLog(@"点击通知，进入APP");
    NSDictionary *info = response.notification.request.content.userInfo;
    self.yh_remoteNotiInfoBlock ? self.yh_remoteNotiInfoBlock(info) : nil;
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


- (void)setYh_deviceTokenBlock:(void (^)(NSString * _Nonnull))yh_deviceTokenBlock{
    objc_setAssociatedObject(self, @selector(yh_deviceTokenBlock), yh_deviceTokenBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(NSString * _Nonnull))yh_deviceTokenBlock{
    return objc_getAssociatedObject(self, @selector(yh_deviceTokenBlock));
}


@end
