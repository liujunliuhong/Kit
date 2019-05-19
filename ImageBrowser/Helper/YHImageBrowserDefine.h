//
//  YHImageBrowserDefine.h
//  HiFanSmooth
//
//  Created by 银河 on 2019/5/17.
//  Copyright © 2019 yinhe. All rights reserved.
//

#ifndef YHImageBrowserDefine_h
#define YHImageBrowserDefine_h

#define YHImageBrowser_ScreenWidth          [UIScreen mainScreen].bounds.size.width
#define YHImageBrowser_ScreenHeight         [UIScreen mainScreen].bounds.size.height

// 当前屏幕的旋转方向，与状态栏是否隐藏无关
#define YHImageBrowser_DeviceOrientation    [UIApplication sharedApplication].statusBarOrientation

/**
 * 是否是iPhone X（iPhone X系列）
 * iPhone X/XS      :375 * 812 (Portrait)
 * iPhone XS Max    :414 * 896 (Portrait)
 * iPhone XR        :414 * 896 (Portrait)
 */
#define YHImageBrowser_IS_IPHONE_X \
({ \
BOOL isIphoneX = NO; \
if (YHImageBrowser_DeviceOrientation == UIInterfaceOrientationPortrait || \
YHImageBrowser_DeviceOrientation == UIInterfaceOrientationPortraitUpsideDown || \
YHImageBrowser_DeviceOrientation ==  UIInterfaceOrientationUnknown) { \
if ((YHImageBrowser_ScreenWidth == 375.f && YHImageBrowser_ScreenHeight == 812.f) || (YHImageBrowser_ScreenWidth == 414.f && YHImageBrowser_ScreenHeight == 896.f)) { \
isIphoneX = YES; \
} \
} else { \
if ((YHImageBrowser_ScreenWidth == 812.f && YHImageBrowser_ScreenHeight == 375.f) || (YHImageBrowser_ScreenWidth == 896.f && YHImageBrowser_ScreenHeight == 414.f)) { \
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
#define YHImageBrowser__Bottom_Height \
({ \
CGFloat bottomHeight = 0.0; \
if (YHImageBrowser_IS_IPHONE_X) { \
if (YHImageBrowser_DeviceOrientation == UIDeviceOrientationPortrait || \
YHImageBrowser_DeviceOrientation == UIDeviceOrientationPortraitUpsideDown || \
YHImageBrowser_DeviceOrientation == UIDeviceOrientationFaceUp || \
YHImageBrowser_DeviceOrientation == UIDeviceOrientationFaceDown) { \
bottomHeight = 34.f; \
} else { \
bottomHeight = 21.f; \
} \
} \
(bottomHeight); \
})



static void YHImageBrowserAsync(dispatch_queue_t queue, dispatch_block_t block) {
    if (strcmp(dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL), dispatch_queue_get_label(queue)) == 0) {
        block();
    } else {
        dispatch_async(queue, block);
    }
}



#endif /* YHImageBrowserDefine_h */
