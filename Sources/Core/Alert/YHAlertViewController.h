//
//  YHAlertViewController.h
//  FrameDating
//
//  Created by 银河 on 2019/6/2.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YHAlertViewController;
typedef void (^YHAlertActionBlock)(int buttonIndex, UIAlertAction *action, YHAlertViewController *alertController);
NS_CLASS_AVAILABLE_IOS(8_0) @interface YHAlertViewController : UIAlertController
@property (nonatomic, copy, nullable) void(^didShowBlock)(void);
@property (nonatomic, copy, nullable) void(^didDismissBlock)(void);
@property (nonatomic, copy, readonly) YHAlertViewController *(^addDefaultActionTitle)(NSString *title);
@property (nonatomic, copy, readonly) YHAlertViewController *(^addCancelActionTitle)(NSString *title);
@property (nonatomic, copy, readonly) YHAlertViewController *(^addDestructiveActionTitle)(NSString *title);
@end



/**
 * 系统UIAlertController的简单封装，参考了JXTAlertController，相比JXTAlertController，去掉了很多个人觉得没有用的东西。
 */
@interface UIViewController (YHAlertViewController)


/**
 弹出alert的方法
 当style为UIAlertControllerStyleActionSheet时，控制台会显示约束错误信息，即使用原生方法写，也是这样，暂时不知道什么原因

 @param title title
 @param message message
 @param style style
 @param actionProcessBlock 事件加工链
 @param didShowBlock 显示回调
 @param didDismissBlock 消失回调
 @param actionBlock 事件回调
 */
- (void)yh_showAlertWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
                        style:(UIAlertControllerStyle)style
           actionProcessBlock:(void(^_Nullable)(YHAlertViewController *alertController))actionProcessBlock
                 didShowBlock:(void(^_Nullable)(void))didShowBlock
              didDismissBlock:(void(^_Nullable)(void))didDismissBlock
                  actionBlock:(nullable YHAlertActionBlock)actionBlock NS_AVAILABLE_IOS(8_0);

@end

NS_ASSUME_NONNULL_END
