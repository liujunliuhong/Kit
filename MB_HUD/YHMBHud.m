//
//  YHMBHud.m
//  YHKit_OC
//
//  Created by 银河 on 2017/11/10.
//  Copyright © 2017年 银河. All rights reserved.
//

#import "YHMBHud.h"

//HUD的背景颜色，默认黑色
#define YHMBHUD_COLOR             [UIColor blackColor]

@implementation YHMBHud

#if __has_include(<MBProgressHUD/MBProgressHUD.h>) || __has_include("MBProgressHUD.h")

/** 菊花旋转，提示信息可为空，view可为空 */
+ (MBProgressHUD *)hudWithMessage:(NSString *)message inView:(UIView *)view{
    return [YHMBHud hudWithMessage:message hudColor:[YHMBHUD_COLOR colorWithAlphaComponent:1] messageColor:[UIColor whiteColor] inView:view];
}

+ (MBProgressHUD *)hudWithMessage:(NSString *)message hudColor:(UIColor *)hudColor messageColor:(UIColor *)messageColor inView:(UIView *)view{
    NSAssert([NSThread isMainThread], @"MBProgressHUD must be in main thread.");
    UIView *tmpView = view;
    if (!view) {
        tmpView = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:tmpView animated:YES];//必须在主线程，源码规定
    
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.contentColor = messageColor;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = hudColor;
    hud.removeFromSuperViewOnHide = YES;
    if (message.length > 0) {
        hud.label.text = message;
        hud.label.numberOfLines = 0;
    }
    return hud;
}




















/** 仅仅只有一段提示信息，一段时间后消失 */
+ (void)hudOnlyMessage:(NSString *)message inView:(UIView *)view dismissBlock:(void (^)(void))dismissBlock{
    [YHMBHud hudOnlyMessage:message hudColor:[YHMBHUD_COLOR colorWithAlphaComponent:1] messageColor:[UIColor whiteColor] inView:view dismissTime:1.5 dismissBlock:dismissBlock];
}
+ (void)hudOnlyMessage:(NSString *)message inView:(UIView *)view dismissTime:(NSTimeInterval)dismissTime dismissBlock:(void (^)(void))dismissBlock{
    [YHMBHud hudOnlyMessage:message hudColor:[YHMBHUD_COLOR colorWithAlphaComponent:1] messageColor:[UIColor whiteColor] inView:view dismissTime:dismissTime dismissBlock:dismissBlock];
}
+ (void)hudOnlyMessage:(NSString *)message hudColor:(UIColor *)hudColor messageColor:(UIColor *)messageColor inView:(UIView *)view dismissBlock:(void (^)(void))dismissBlock{
    [YHMBHud hudOnlyMessage:message hudColor:hudColor messageColor:messageColor inView:view dismissTime:1.5 dismissBlock:dismissBlock];
}
+ (void)hudOnlyMessage:(NSString *)message hudColor:(UIColor *)hudColor messageColor:(UIColor *)messageColor inView:(UIView *)view dismissTime:(NSTimeInterval)dismissTime dismissBlock:(void (^)(void))dismissBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!message || message.length == 0) {
            return;
        }
        UIView *tmpView = view;
        if (!view) {
            tmpView = [UIApplication sharedApplication].keyWindow;
        }
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:tmpView animated:YES];//必须在主线程，源码规定
        
        hud.mode = MBProgressHUDModeText;
        hud.contentColor = messageColor;
        hud.label.text = message;
        hud.label.numberOfLines = 0;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.color = hudColor;
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:dismissTime];//必须在主线程，源码规定
        hud.completionBlock = dismissBlock;
    });
}

// 在主线程隐藏hud
+ (void)hideHud:(MBProgressHUD *)hud{
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
    });
}

#endif

@end
