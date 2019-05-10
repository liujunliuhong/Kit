//
//  YHBaseViewController.h
//  Kit
//
//  Created by apple on 2019/1/24.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHCustomNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN
/**********************************************************************************************************************************************************************
 *
 *
 * 注意：在使用该类前，请把TARGETS中的屏幕旋转方向的选项建议最好全部勾选，然后通过代码来控制每个VC的旋转。如果你只勾选了竖屏，一旦你的APP里面有个别横屏的页面，则返回的时候，会崩溃。除非你的APP只支持竖屏。
 *
 *
***********************************************************************************************************************************************************************/
NS_CLASS_AVAILABLE_IOS(8_0) @interface YHBaseViewController : UIViewController

#pragma mark - +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// 自定义的导航栏
// backgroundColor            : [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1]
@property (nonatomic, strong, readonly) YHCustomNavigationBar *yh_navigationBar;

// 导航栏默认的返回按钮
// 该按钮没有对图片和文字同时存在的场景做适配，如果需要文字和图片同时存在，请自行处理，用self.yh_navigationBar.leftViews = @[xxx];
// font                       : [UIFont systemFontOfSize:15]
// titleColor                 : [UIColor blackColor]
@property (nonatomic, strong, readonly) UIButton *yh_naviDefaultBackButton;


// 导航栏默认的titleView
// 如果需要自定义titleView，请使用self.yh_navigationBar.titleView = xxx;
// textAlignment              : NSTextAlignmentCenter
// font                       : [UIFont boldSystemFontOfSize:17]
// textColor                  : [UIColor blackColor]
// numberOfLines              : 1
// adjustsFontSizeToFitWidth  : NO
@property (nonatomic, strong, readonly) UILabel *yh_naviDefaultTitleLabel;

#pragma mark - +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// 导航栏底部的View
@property (nonatomic, strong, readonly, nullable) UIView *yh_naviBottomView;

// 是否隐藏导航栏(readonly)
// Default is YES（默认为YES的原因是：如果为NO，那么push下一个界面时，如果下个界面隐藏导航栏，导航栏会有个闪动的效果）
@property (nonatomic, assign, readonly) BOOL yh_isHideNavigationBar;

// 是否隐藏导航栏的bar(readonly)
// Default is NO
@property (nonatomic, assign, readonly) BOOL yh_isHideBar;

// 安全区域View
@property (nonatomic, strong, readonly) UIView *yh_safeAreaView;

// 是否隐藏导航栏默认的返回按钮
// Default is NO(无动画)
@property (nonatomic, assign) BOOL yh_isHideDefaultBackButton;

// 是否隐藏导航栏底部的线条
// Default is NO(无动画)
@property (nonatomic, assign) BOOL yh_isHideNaviLine;

// 安全区域View是否强制与屏幕边缘对齐
// Default is NO.
@property (nonatomic, assign) BOOL yh_isSafeAreaViewForceScreenEdge;

// 安全区域View的偏移量
// Default is UIEdgeInsetsZero.
// 当yh_isSafeAreaViewForceScreenEdge设置为YES时，从边缘开始
// 当yh_isSafeAreaViewForceScreenEdge设置为NO时，在iOS 11以下，从屏幕边缘开始，在iOS 11之上，从VC的安全区域开始
@property (nonatomic, assign) UIEdgeInsets yh_safeAreaViewInsets;

#pragma mark - +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// 是否隐藏状态栏
// Default is NO.
// 需要调用:yh_reloadStatusBarStyle.
@property (nonatomic, assign) BOOL yh_isHideStatusBar;

// 在iPhone X系列手机上，是否强制隐藏状态栏，由于iPhone X在横屏的时候，默认就隐藏了状态栏，因此此属性只在竖屏情况下有效
// 当设置为YES时，只有在yh_isHideStatusBar为YES的情况下，且在iPhone X系列手机m，且是竖屏的情况下才会生效
// Default is NO.
// 需要调用:yh_reloadStatusBarStyle.
@property (nonatomic, assign) BOOL yh_isForceHideStatusBarWhenIphoneX;

// 状态栏颜色
// 默认是info.plist里面的配置.
// 需要调用:yh_reloadStatusBarStyle.
@property (nonatomic, assign) UIStatusBarStyle yh_statusBarStyle;

// 状态栏动画样式
// Default is UIStatusBarAnimationFade.
// 需要调用:yh_reloadStatusBarStyle.
@property (nonatomic, assign) UIStatusBarAnimation yh_statusBarAnimation;

// 当前控制器是否支持旋转
// 为了适配横屏返回上个界面仍然是竖屏，因此这儿默认设置为YES。导致界面可以旋转，若想禁止旋转，请设置self.yh_supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
// Default is YES.
// 需要调用:yh_reloadStatusBarStyle.
@property (nonatomic, assign) BOOL yh_shouldAutorotate;

// 当前控制器支持的旋转方向
// Default is UIInterfaceOrientationMaskAll.
// 需要调用:yh_reloadStatusBarStyle.
@property (nonatomic, assign) UIInterfaceOrientationMask yh_supportedInterfaceOrientations;

// 当前控制器初始的旋转方向
// Default is UIInterfaceOrientationPortrait.
// 需要调用:yh_reloadStatusBarStyle.
@property (nonatomic, assign) UIInterfaceOrientation yh_preferredInterfaceOrientationForPresentation;

#pragma mark - +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// 隐藏与显示整个导航栏
// 之后还需要调用: - (void)yh_updateNavigationBarConstraintWithAnimation:(BOOL)isAnimation;
// 😄
- (void)yh_setNavigationBarHidden:(BOOL)isHidden;

// 显示与隐藏导航栏的Bar
// 之后还需要调用: - (void)yh_updateNavigationBarConstraintWithAnimation:(BOOL)isAnimation;
// 😄
- (void)yh_setBarHidden:(BOOL)isHidden;

// 显示与隐藏BottomView
// bottomView为nil，代表隐藏BottomView
// 之后还需要调用: - (void)yh_updateNavigationBarConstraintWithAnimation:(BOOL)isAnimation;
// 😄
- (void)yh_setNaviBottomView:(nullable UIView *)bottomView;

// 设置屏幕旋转方向
// 需要和yh_supportedInterfaceOrientations一起使用
- (void)yh_setDeviceOrientation:(UIInterfaceOrientation)orientation;


// 导航栏默认返回按钮的点击事件
// 如果是push，则返回上个界面
// 如果是present，则dismiss
// 如果想拦截点击事件，则重写此方法。慎用[super yh_naviDefaultBackButtonClickAction]
- (void)yh_naviDefaultBackButtonClickAction;



#pragma mark - +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// 显示或者隐藏状态栏之后，系统并不会发送UIApplicationDidChangeStatusBarFrameNotification或者UIApplicationDidChangeStatusBarOrientationNotification通知，因此需要手动调用此方法来更新导航栏的约束
// 显示或者隐藏bar；显示或者隐藏导航栏等属性需要配合此方法一起使用，具体请看注释
// isAnimation:是否需要动画
// 有"😄"这个表情的，代表都需要调用此方法
// 可以把带有多个"😄"表情的方法结合起来一起调用，最后再调用此方法
- (void)yh_updateNavigationBarConstraintWithAnimation:(BOOL)isAnimation;

#pragma mark ------------------------------------
// 刷新状态栏样式.
- (void)yh_reloadStatusBarStyle;


@end

NS_ASSUME_NONNULL_END



/*
 一些测试结果:(View controller-based status bar appearance设置为YES的情况下)
 1、在iPhone X系列手机上，开启个人热点不会导致状态栏高度作出任何变化
 2、横屏的时候，在iPhone X系列手机上，状态栏不会显示，在iPhone X以前的手机上，状态栏会显示
 3、横屏的时候，且在iPhone X系列手机上，状态栏永远都是隐藏的，代码设置为显示也不会生效
 4、self.edgesForExtendedLayout = UIRectEdgeNone 和 self.edgesForExtendedLayout = UIRectEdgeAll 这两种情况下的安全区域的偏移量self.view.safeAreaInsets是有区别的
 5、View controller-based status bar appearance设置为YES，这样就可以任意控制单个页面状态栏的显示与隐藏了，但是需要配合 setNeedsStatusBarAppearanceUpdate 和 - (BOOL)prefersStatusBarHidden{} 这两个方法来使用
 6、[UITabBar appearance].translucent设置为NO，这样pop的时候，tabbar的图标就不会跳动了
 */





