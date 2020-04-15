//
//  YHMacro.h
//  chanDemo
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 银河. All rights reserved.
//

#ifndef YHMacro_h
#define YHMacro_h
#import <UIKit/UIKit.h>

#pragma mark - DEBUG
// __VA_ARGS__:可变参数的宏，宏前面加上##的作用在于，当可变参数的个数为0时，这里的##起到把前面多余的","去掉的作用,否则会编译出错.
// __FILE__:宏在预编译时会替换成当前的源文件名.
// __LINE__:宏在预编译时会替换成当前的行号.
// __FUNCTION__:宏在预编译时会替换成当前的函数名称
#ifdef DEBUG
    #define YHLog(format, ...)  printf("👉 [YHLog] [%s] [%d] %s\n" ,[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
#else
    #define YHLog(format, ...)
#endif


#pragma mark - APP
/** APP version */
#define YH__AppVersion             [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
/** APP build */
#define YH__AppBuild               [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
/** APP bundleID */
#define YH__AppBundleID            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
/** APP Name */
#define YH__AppName                [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]//CFBundleDisplayName
/** APP Default StatusBarStyle **/
#define YH__DefaultStatusBarStyle  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UIStatusBarStyle"] // NSString




#pragma mark - UIKit
#define YH__RandomColor            [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]
#define YH__RGB(R,G,B)             [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]
#define YH__RGBA(R,G,B,A)          [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define YH__HexColor(hex)          [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]






#pragma mark - Foundation
/** 弧度转角度 */
#define YH__RADIANS_TO_DEGREES(radians)              ((radians) * (180.0 / M_PI))
/** 角度转弧度 */
#define YH__DEGREES_TO_RADIANS(angle)                ((angle) / 180.0 * M_PI)

#define YH__WeakSelf(__weakName__)                   __weak typeof(self) __weakName__ = self
#define YH__Weak(__name__,__weakName__)              __weak typeof(__name__) __weakName__ = __name__


/*
 iPhone XR:           414 x 896             2x
 
 iPhone Xs Max:       414 x 896             3x
 iPhone X/Xs:         375 x 812             3x
 
 IPhone X:            375 x 812             3x
 
 IPhone 8:            375 x 667             2x
 iPhone 8 Plus:       414 x 736             3x
 
 IPhone 7:            375 x 667             2x
 IPhone 7 plus:       414 x 736             3x
 
 IPhone 6:            375 x 667             2x
 IPhone 6s:           375 x 667             2x  (UI设计图一般都是以6s为基准的，如果不是，那么锤他)
 iPhone 6 Plus:       414 x 736             3x
 IPhone 6s plus:      414 x 736             3x
 
 IPhone 5:            320 x 568             2x
 IPhone 5s:           320 x 568             2x
 */

#define YH__ScreenWidth          [UIScreen mainScreen].bounds.size.width
#define YH__ScreenHeight         [UIScreen mainScreen].bounds.size.height

// 当前屏幕的旋转方向，与状态栏是否隐藏无关
#define YH__DeviceOrientation    [UIApplication sharedApplication].statusBarOrientation


#define YH__IsPortrait \
({ \
BOOL isPortrait = NO; \
if (YH_DeviceOrientation == UIInterfaceOrientationPortrait || \
YH_DeviceOrientation == UIInterfaceOrientationPortraitUpsideDown) { \
isPortrait = YES; \
} \
(isPortrait); \
})

/**
 * 是否是iPhone X（iPhone X系列）
 * iPhone X/XS      :375 * 812 (Portrait)
 * iPhone XS Max    :414 * 896 (Portrait)
 * iPhone XR        :414 * 896 (Portrait)
 */
#define YH__IS_IPHONE_X \
({ \
BOOL isIphoneX = NO; \
if (YH__DeviceOrientation == UIInterfaceOrientationPortrait || \
    YH__DeviceOrientation == UIInterfaceOrientationPortraitUpsideDown) { \
    if ((YH__ScreenWidth == 375.f && YH__ScreenHeight == 812.f) || (YH__ScreenWidth == 414.f && YH__ScreenHeight == 896.f)) { \
        isIphoneX = YES; \
    } \
} else { \
    if ((YH__ScreenWidth == 812.f && YH__ScreenHeight == 375.f) || (YH__ScreenWidth == 896.f && YH__ScreenHeight == 414.f)) { \
        isIphoneX = YES; \
    } \
} \
(isIphoneX); \
})


/**
 * 底部高度，主要针对刘海屏幕
 * 在iPhone X以前的手机上，底部高度为0，iPhone X及以后的手机，底部高度要根据手机的旋转方向做判断
 * 在iPhone X系列手机上，竖屏情况下是34pt，横屏是21pt
 */
#define YH__Bottom_Height \
({ \
CGFloat bottomHeight = 0.0; \
if (YH__IS_IPHONE_X) { \
    if (YH__DeviceOrientation == UIDeviceOrientationPortrait || \
        YH__DeviceOrientation == UIDeviceOrientationPortraitUpsideDown || \
        YH__DeviceOrientation == UIDeviceOrientationFaceUp || \
        YH__DeviceOrientation == UIDeviceOrientationFaceDown) { \
        bottomHeight = 34.f; \
    } else { \
        bottomHeight = 21.f; \
    } \
} \
(bottomHeight); \
})

// 导航栏高度，不管在什么机型上，都是44pt
#define YH__NaviBar_Height       44.f

// 当开启个人热点时，状态栏高度是40(在刘海屏手机上，状态栏高度不会发生变化)
#define YH__PersonalHotspotStatusBarHeight        40.0


/** 状态栏Frame
 1、当状态栏是隐藏的时候，是CGRectZero，iPhone X系列状态栏永远不隐藏
 2、当状态栏不隐藏的时候。iPhone X：44pt    其他机型:20pt
 3、当开启个人热点时，状态栏高度变为40pt，页面会整体下移20pt。特别是TabBar，下移20pt之后，严重影响用户体验。当状态栏高度发生变化时，会走UIApplicationWillChangeStatusBarFrameNotification通知
 4、当设备是iPhone X系列时，开启个人热点和没有开启个人热点时一样的，状态栏尺寸不会发生变化
 */
#define YH__StatusBarFrame       [[UIApplication sharedApplication] statusBarFrame]


//只有当设备是5系列时，才对宽度做处理，其他情况用实际宽度    基于6s
//#define YH_Width(w) \
//({ \
//CGFloat width = w; \
//if (YH_ScreenWidth == 320.0) { \
//width = w/375.f*YH_ScreenWidth; \
//} \
//(width); \
//})



// 不同机型的适配(已6s为基准)
#define YH__Base_6S_AutoFit(__vale__) \
({ \
CGFloat tmp = __vale__; \
CGFloat min = MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height); \
tmp = min / 375.0 * __vale__; \
(tmp); \
})

#endif /* YHMacro_h */
