//
//  AppDelegate+YHNotiExtension.h
//  Kit
//
//  Created by apple on 2019/1/31.
//  Copyright © 2019 yinhe. All rights reserved.
//


#if __has_include(<AppDelegate/AppDelegate.h>)

#import "AppDelegate.h"



@interface AppDelegate (YHNotiExtension)

// 注册远程推送
// 请在AppDelegate的 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{} 里面调用
- (void)yh_registerRemoteNotificationWithOptions:(NSDictionary *)launchOptions NS_AVAILABLE_IOS(8_0);

// 点击通知，远程通知的回调
@property (nonatomic, copy) void(^yh_remoteNotiInfoBlock)(NSDictionary *_Nullable remoteNotiInfo);

// 点击通知，本地通知的回调
@property (nonatomic, copy) void(^yh_localNotiInfoBlock)(NSDictionary *_Nullable localNotiInfo);

// 处理通知的回调，主要适用于第三方
@property (nonatomic, copy) void(^yh_handleNotiInfoBlock)(NSDictionary *_Nullable notiInfo);

// 成功注册通知，收到deviceToken的回调
@property (nonatomic, copy) void(^yh_deviceTokenBlock)(NSString *deviceToken, NSData *deviceTokenData);

@end

#endif


