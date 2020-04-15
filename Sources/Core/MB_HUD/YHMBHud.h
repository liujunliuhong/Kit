//
//  YHMBHud.h
//  YHKit_OC
//
//  Created by 银河 on 2017/11/10.
//  Copyright © 2017年 银河. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#if __has_include(<MBProgressHUD/MBProgressHUD.h>)
    #import <MBProgressHUD/MBProgressHUD.h>
#elif __has_include("MBProgressHUD.h")
    #import "MBProgressHUD.h"
#endif

NS_ASSUME_NONNULL_BEGIN


#if __has_include(<MBProgressHUD/MBProgressHUD.h>) || __has_include("MBProgressHUD.h")
    #define YH_MB_HUD_Tip(__tip__)          [YHMBHud hudOnlyMessage:__tip__ inView:nil dismissBlock:nil]; // 黑
    #define YH_MB_White_HUD_Tip(__tip__)    [YHMBHud hudOnlyMessage:__tip__ hudColor:[UIColor whiteColor] messageColor:[UIColor grayColor] inView:nil dismissBlock:nil];
#endif

/**
 此类是对MBProgressHUD的封装，要使用此类，请选择按照方法1或者方法2的方式引入
 
 1、需要自行去从GitHub上下载MBProgressHUD，将"MBProgressHUD.h"和"MBProgressHUD.m"文件拖入工程中
 2、pod 'MBProgressHUD'
 
 */
@interface YHMBHud : NSObject

#if __has_include(<MBProgressHUD/MBProgressHUD.h>) || __has_include("MBProgressHUD.h")

/**
 * 菊花旋转，提示信息可为空，view可为空
 * 请确保在主线程调用
 */
+ (MBProgressHUD *)hudWithMessage:(NSString * _Nullable)message inView:(UIView * _Nullable)view;
+ (MBProgressHUD *)hudWithMessage:(NSString * _Nullable)message hudColor:(UIColor *)hudColor messageColor:(UIColor *)messageColor inView:(UIView * _Nullable)view;




/**
 * 仅仅只有一段提示信息，一段时间后消失(默认1.5s消失)
 */
+ (void)hudOnlyMessage:(NSString *)message inView:(UIView * _Nullable)view dismissBlock:(void(^ _Nullable)(void))dismissBlock;
+ (void)hudOnlyMessage:(NSString *)message hudColor:(UIColor *)hudColor messageColor:(UIColor *)messageColor inView:(UIView * _Nullable)view dismissBlock:(void(^ _Nullable)(void))dismissBlock;

/**
 * 仅仅只有一段提示信息，一段时间后消失
 */
+ (void)hudOnlyMessage:(NSString *)message inView:(UIView * _Nullable)view dismissTime:(NSTimeInterval)dismissTime dismissBlock:(void(^ _Nullable)(void))dismissBlock;


/**
 * 在主线程隐藏hud
 */
+ (void)hideHud:(MBProgressHUD *)hud;

#endif
@end

NS_ASSUME_NONNULL_END
