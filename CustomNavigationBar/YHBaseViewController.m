//
//  YHBaseViewController.m
//  Kit
//
//  Created by apple on 2019/1/24.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHBaseViewController.h"
#import <Masonry/Masonry.h>
#import <objc/message.h>
#import "YHMacro.h"

@interface YHBaseViewController ()

@property (nonatomic, strong) YHCustomNavigationBar *yh_navigationBar;

@property (nonatomic, strong) UIButton *yh_naviDefaultBackButton;

@property (nonatomic, strong) UILabel *yh_naviDefaultTitleLabel;

@property (nonatomic, strong) UIView *yh_naviBottomView;

@property (nonatomic, strong) UIView *yh_safeAreaView;

@property (nonatomic, assign) BOOL yh_isHideNavigationBar;
@property (nonatomic, assign) BOOL yh_isHideBar;

@property (nonatomic, assign) BOOL isAnimationWhenUpdateNavigationBar;

@property (nonatomic, assign) BOOL updateFlagWhenPop;

@end

@implementation YHBaseViewController
- (void)dealloc{
    // Remove observe.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.clipsToBounds = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    if (@available(iOS 11.0, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [UITableView appearance].estimatedRowHeight = 0;
    [UITableView appearance].estimatedSectionHeaderHeight = 0;
    [UITableView appearance].estimatedSectionFooterHeight = 0;
    
    self.updateFlagWhenPop = NO;
    self.isAnimationWhenUpdateNavigationBar = NO;
    
    [self.view addSubview:self.yh_navigationBar];
    [self.view addSubview:self.yh_safeAreaView];
    [self.view bringSubviewToFront:self.yh_navigationBar];
    
    [self setInitialNavigationBarConstraint];
    
    self.yh_navigationBar.titleView = self.yh_naviDefaultTitleLabel;
    self.yh_navigationBar.leftViews = @[self.yh_naviDefaultBackButton];
    self.yh_isSafeAreaViewForceScreenEdge = NO;
    self.yh_safeAreaViewInsets = UIEdgeInsetsZero;
    
    // 添加状态栏frame变化和方向变化的通知    注：屏幕旋转的时候，这两个通知都会收到回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarFrameNotification:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    self.yh_isHideStatusBar = NO;
    self.yh_statusBarAnimation = UIStatusBarAnimationFade;
    if ([YH_DefaultStatusBarStyle isEqualToString:@"UIStatusBarStyleLightContent"]) {
        self.yh_statusBarStyle = UIStatusBarStyleLightContent;
    } else {
        self.yh_statusBarStyle = UIStatusBarStyleDefault;
    }
    
    self.yh_shouldAutorotate = NO; // 默认不旋转
    //self.yh_supportedInterfaceOrientations = UIInterfaceOrientationMaskAll;
    self.yh_supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait; // 默认只支持竖屏        如果屏幕需要旋转，请在TARGETS -> General -> Deployment Info -> Device Orientation 修改屏幕支持方向的集合
    self.yh_preferredInterfaceOrientationForPresentation = UIInterfaceOrientationPortrait; // 默认初始进入为竖屏
    self.yh_isForceHideStatusBarWhenIphoneX = NO; // 默认在iPhone X系列手机上不隐藏状态栏
    
    
    [self yh_updateNavigationBarConstraintWithAnimation:NO];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.updateFlagWhenPop) {
        // 返回上个界面时，重置导航栏约束
        [self yh_updateNavigationBarConstraintWithAnimation:NO];
        // 返回上个界面时，让VC的旋转方向为初始值
        [self yh_setDeviceOrientation:self.yh_preferredInterfaceOrientationForPresentation];
        self.updateFlagWhenPop = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.updateFlagWhenPop = YES;
}

- (BOOL)prefersStatusBarHidden{
    // iPhone X系列手机对状态栏做特殊处理
    if (YH_IS_IPHONE_X) {
        return self.yh_isForceHideStatusBarWhenIphoneX;
    }
    return self.yh_isHideStatusBar;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return self.yh_statusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return self.yh_statusBarAnimation;
}

- (BOOL)shouldAutorotate{
    return self.yh_shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.yh_supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return self.yh_preferredInterfaceOrientationForPresentation;
}

#pragma mark - Notification

- (void)didChangeStatusBarFrameNotification:(NSNotification *)noti{
    YHDebugLog(@"%@",NSStringFromSelector(_cmd));
    self.isAnimationWhenUpdateNavigationBar = NO;
    [self updateNavigationBarConstraint];
}

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti{
    YHDebugLog(@"%@",NSStringFromSelector(_cmd));
    self.isAnimationWhenUpdateNavigationBar = NO;
    [self updateNavigationBarConstraint];
}

#pragma mark - Methods
// 设置导航栏初始状态下的约束
- (void)setInitialNavigationBarConstraint{
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (statusBarOrientation == UIInterfaceOrientationPortrait || statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown || statusBarOrientation == UIInterfaceOrientationUnknown) {
        self.yh_navigationBar.leftHorizontalEdgeInset = 0.0;
        self.yh_navigationBar.rightHorizontalEdgeInset = 0.0;
    } else {
        self.yh_navigationBar.leftHorizontalEdgeInset = YH_IS_IPHONE_X ? 34.0 : 0.0;
        self.yh_navigationBar.rightHorizontalEdgeInset = YH_IS_IPHONE_X ? 34.0 : 0.0;
    }
    
    CGFloat naviBottomViewHeight = self.yh_naviBottomView ? self.yh_naviBottomView.frame.size.height : 0.0;
    
    CGFloat naviHeight = [UIApplication sharedApplication].statusBarFrame.size.height == YH_PersonalHotspotStatusBarHeight ? [YHCustomNavigationBar barHeight] + 20.0 + naviBottomViewHeight :  [UIApplication sharedApplication].statusBarFrame.size.height + [YHCustomNavigationBar barHeight] + naviBottomViewHeight;
    
    __weak typeof(self) weakSelf = self;
    
    [self.yh_navigationBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        if (weakSelf.yh_isHideNavigationBar) {
            make.top.equalTo(weakSelf.view).mas_offset(-naviHeight);
        } else {
            make.top.equalTo(weakSelf.view);
        }
        make.height.mas_equalTo(naviHeight);
    }];
}

// 安全区域View的约束
- (void)updateSafeAreaViewConstraint{
    if (self.yh_isSafeAreaViewForceScreenEdge) {
        [self.yh_safeAreaView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).mas_offset(self.yh_safeAreaViewInsets.left);
            make.right.equalTo(self.view).mas_offset(self.yh_safeAreaViewInsets.right);
            make.bottom.equalTo(self.view).mas_offset(self.yh_safeAreaViewInsets.bottom);
            make.top.equalTo(self.yh_navigationBar.mas_bottom).mas_offset(self.yh_safeAreaViewInsets.top);
        }];
    } else {
        if (@available(iOS 11.0, *)) {
            [self.yh_safeAreaView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft).mas_offset(self.yh_safeAreaViewInsets.left);
                make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight).mas_offset(self.yh_safeAreaViewInsets.right);
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(self.yh_safeAreaViewInsets.bottom);
                make.top.equalTo(self.yh_navigationBar.mas_bottom).mas_offset(self.yh_safeAreaViewInsets.top);
            }];
        } else {
            [self.yh_safeAreaView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view).mas_offset(self.yh_safeAreaViewInsets.left);
                make.right.equalTo(self.view).mas_offset(self.yh_safeAreaViewInsets.right);
                make.bottom.equalTo(self.view).mas_offset(self.yh_safeAreaViewInsets.bottom);
                make.top.equalTo(self.yh_navigationBar.mas_bottom).mas_offset(self.yh_safeAreaViewInsets.top);
            }];
        }
    }
}

// 更新导航栏的约束
- (void)updateNavigationBarConstraint{
    __weak typeof(self) weakSelf = self;
    
    // 测试发现，A页面Push或者Present到B页面之后，如果B页面在竖屏的情况下隐藏状态栏，然后再横屏，然后再竖屏，最后返回到A页面，发现A页面获取到的状态栏高度为0，但是状态栏却显示出来了，导致导航栏高度不正确，因此加了个属性updateFlagWhenPop，初始为NO，在viewWillAppear里面做判断，当为YES的时候，更新导航栏.
    dispatch_block_t naviFrameBlock = ^(void){
        
        CGFloat naviHeight = [UIApplication sharedApplication].statusBarFrame.size.height == YH_PersonalHotspotStatusBarHeight ? [YHCustomNavigationBar barHeight] + 20.0 + weakSelf.yh_navigationBar.currentBottomViewHeight :  [UIApplication sharedApplication].statusBarFrame.size.height + [YHCustomNavigationBar barHeight] + weakSelf.yh_navigationBar.currentBottomViewHeight;
        
        if (self.yh_isHideBar) {
            naviHeight = naviHeight - [YHCustomNavigationBar barHeight];
        }
        
        [weakSelf.yh_navigationBar mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view);
            make.right.equalTo(weakSelf.view);
            if (weakSelf.yh_isHideNavigationBar) {
                make.top.equalTo(weakSelf.view).mas_offset(-naviHeight);
            } else {
                make.top.equalTo(weakSelf.view);
            }
            make.height.mas_equalTo(naviHeight);
        }];
    };
    // 延迟0.05秒更新导航栏约束
    // 特别要注意这儿延迟了0.05秒，所以yh_navigationBar的属性currentBottomViewHeight就显得至关重要
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.isAnimationWhenUpdateNavigationBar) {
            
            weakSelf.yh_navigationBar.barContentView.hidden = weakSelf.yh_navigationBar.barContentView.hidden;
            
            // 当当前不需要要隐藏Bar，但是当前Bar是隐藏的，则把hidden属性置为NO
            if (!weakSelf.yh_isHideBar && weakSelf.yh_navigationBar.barContentView.hidden) {
                weakSelf.yh_navigationBar.barContentView.hidden = NO;
            }
            // 当当前不需要要隐藏导航栏，但是当前导航栏是隐藏的，则把hidden属性置为NO
            if (!weakSelf.yh_isHideNavigationBar && weakSelf.yh_navigationBar.hidden) {
                weakSelf.yh_navigationBar.hidden = NO;
            }
            
            [UIView animateWithDuration:0.2 animations:^{
                
                if (weakSelf.yh_isHideBar) {
                    weakSelf.yh_navigationBar.barContentView.alpha = 0;
                } else {
                    weakSelf.yh_navigationBar.barContentView.alpha = 1;
                }
                if (weakSelf.yh_isHideNavigationBar) {
                    weakSelf.yh_navigationBar.alpha = 0;
                } else {
                    weakSelf.yh_navigationBar.alpha = 1;
                }
                
                naviFrameBlock();
                [weakSelf.yh_navigationBar updateSubViewsConstraint];
                
            } completion:^(BOOL finished) {
                
                if (weakSelf.yh_isHideBar) {
                    weakSelf.yh_navigationBar.barContentView.hidden = YES;
                    weakSelf.yh_navigationBar.barContentView.alpha = 0;
                } else {
                    weakSelf.yh_navigationBar.barContentView.hidden = NO;
                    weakSelf.yh_navigationBar.barContentView.alpha = 1;
                }
                if (weakSelf.yh_isHideNavigationBar) {
                    weakSelf.yh_navigationBar.hidden = YES;
                    weakSelf.yh_navigationBar.alpha = 0;
                } else {
                    weakSelf.yh_navigationBar.hidden = NO;
                    weakSelf.yh_navigationBar.alpha = 1;
                }
                
                // 动画完成之后，如果yh_naviBottomView存在，则移除
                // 千万不要设置yh_naviBottomView为nil，否则会发生死循环，因为setter方法
                if (!self.yh_naviBottomView) {
                    [self.yh_navigationBar.bottomView removeFromSuperview];
                }
            }];
            
        } else {
            
            naviFrameBlock();
            [self.yh_navigationBar updateSubViewsConstraint];
            
            if (weakSelf.yh_isHideBar) {
                weakSelf.yh_navigationBar.barContentView.hidden = YES;
                weakSelf.yh_navigationBar.barContentView.alpha = 0;
            } else {
                weakSelf.yh_navigationBar.barContentView.alpha = 1;
                weakSelf.yh_navigationBar.barContentView.hidden = NO;
            }
            if (weakSelf.yh_isHideNavigationBar) {
                weakSelf.yh_navigationBar.hidden = YES;
                weakSelf.yh_navigationBar.alpha = 0;
            } else {
                weakSelf.yh_navigationBar.hidden = NO;
                weakSelf.yh_navigationBar.alpha = 1;
            }
            
            // 如果yh_naviBottomView存在，则移除
            // 千万不要设置yh_naviBottomView为nil，否则会发生死循环，因为setter方法
            if (!self.yh_naviBottomView) {
                [self.yh_navigationBar.bottomView removeFromSuperview];
            }
        }
    });
}

// 隐藏与显示整个导航栏
- (void)yh_setNavigationBarHidden:(BOOL)isHidden{
    self.yh_isHideNavigationBar = isHidden;
}

// 显示与隐藏导航栏的bar
- (void)yh_setBarHidden:(BOOL)isHidden{
    self.yh_isHideBar = isHidden;
}

// 更新导航栏约束
// isAnimation:是否需要动画
- (void)yh_updateNavigationBarConstraintWithAnimation:(BOOL)isAnimation{
    self.isAnimationWhenUpdateNavigationBar = isAnimation;
    [self updateNavigationBarConstraint];
}

// 导航栏默认返回按钮的点击事件
- (void)yh_naviDefaultBackButtonClickAction{
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count > 1 && self.navigationController.viewControllers.lastObject == self) {//有导航栏，且导航栏的viewControllers的个数大于1,且viewControllers的最后一个元素是该VC
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            if (self.navigationController.presentingViewController) {//导航栏包裹一个VC，且导航栏是present出来的
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }
    } else {
        if (self.presentingViewController) {//无导航栏，且该VC是present出来的
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

// 设置屏幕旋转方向
- (void)yh_setDeviceOrientation:(UIInterfaceOrientation)orientation{
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
    NSNumber *value = [NSNumber numberWithInt:orientation];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void)yh_setNaviBottomView:(UIView *)bottomView{
    self.yh_naviBottomView = bottomView;
    self.yh_navigationBar.bottomView = bottomView;
}

- (NSBundle *)naviBundle {
    NSBundle *bundle = [NSBundle bundleForClass:[YHBaseViewController class]];
    NSURL *url = [bundle URLForResource:@"YHCustomNavigationBar" withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:url];
    return bundle;
}

- (UIImage *)bundleImageWithName:(NSString *)name{
    NSBundle *imageBundle = [self naviBundle];
    name = [name stringByAppendingString:@"@2x"];
    NSString *imagePath = [imageBundle pathForResource:name ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    if (!image) {
        // 兼容业务方自己设置图片的方式
        name = [name stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
        image = [UIImage imageNamed:name];
    }
    return image;
}

#pragma mark - Setter

- (void)setYh_isHideDefaultBackButton:(BOOL)yh_isHideDefaultBackButton{
    _yh_isHideDefaultBackButton = yh_isHideDefaultBackButton;
    
    if (_yh_isHideDefaultBackButton) {
        self.yh_navigationBar.leftViews = @[];
    } else {
        self.yh_navigationBar.leftViews = @[self.yh_naviDefaultBackButton];
    }
    [self.yh_navigationBar updateSubViewsConstraint];
}


- (void)setYh_isHideNaviLine:(BOOL)yh_isHideNaviLine{
    _yh_isHideNaviLine = yh_isHideNaviLine;
    self.yh_navigationBar.line.hidden = _yh_isHideNaviLine;
}

- (void)setYh_isSafeAreaViewForceScreenEdge:(BOOL)yh_isSafeAreaViewForceScreenEdge{
    _yh_isSafeAreaViewForceScreenEdge = yh_isSafeAreaViewForceScreenEdge;
    [self updateSafeAreaViewConstraint];
}

- (void)setYh_safeAreaViewInsets:(UIEdgeInsets)yh_safeAreaViewInsets{
    _yh_safeAreaViewInsets = yh_safeAreaViewInsets;
    [self updateSafeAreaViewConstraint];
}

- (void)setYh_isHideStatusBar:(BOOL)yh_isHideStatusBar{
    _yh_isHideStatusBar = yh_isHideStatusBar;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setYh_isForceHideStatusBarWhenIphoneX:(BOOL)yh_isForceHideStatusBarWhenIphoneX{
    _yh_isForceHideStatusBarWhenIphoneX = yh_isForceHideStatusBarWhenIphoneX;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setYh_statusBarAnimation:(UIStatusBarAnimation)yh_statusBarAnimation{
    _yh_statusBarAnimation = yh_statusBarAnimation;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setYh_statusBarStyle:(UIStatusBarStyle)yh_statusBarStyle{
    _yh_statusBarStyle = yh_statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setYh_shouldAutorotate:(BOOL)yh_shouldAutorotate{
    _yh_shouldAutorotate = yh_shouldAutorotate;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setYh_supportedInterfaceOrientations:(UIInterfaceOrientationMask)yh_supportedInterfaceOrientations{
    _yh_supportedInterfaceOrientations = yh_supportedInterfaceOrientations;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setYh_preferredInterfaceOrientationForPresentation:(UIInterfaceOrientation)yh_preferredInterfaceOrientationForPresentation{
    _yh_preferredInterfaceOrientationForPresentation = yh_preferredInterfaceOrientationForPresentation;
    [self setNeedsStatusBarAppearanceUpdate];
}


#pragma mark - Getter
- (YHCustomNavigationBar *)yh_navigationBar{
    if (!_yh_navigationBar) {
        _yh_navigationBar = [[YHCustomNavigationBar alloc] init];
    }
    return _yh_navigationBar;
}
- (UIButton *)yh_naviDefaultBackButton{
    if (!_yh_naviDefaultBackButton) {
        _yh_naviDefaultBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_yh_naviDefaultBackButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _yh_naviDefaultBackButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_yh_naviDefaultBackButton addTarget:self action:@selector(yh_naviDefaultBackButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
        [_yh_naviDefaultBackButton setImage:[self bundleImageWithName:@"yh_navi_back"] forState:UIControlStateNormal];
    }
    return _yh_naviDefaultBackButton;
}

- (UILabel *)yh_naviDefaultTitleLabel{
    if (!_yh_naviDefaultTitleLabel) {
        _yh_naviDefaultTitleLabel = [[UILabel alloc] init];
        _yh_naviDefaultTitleLabel.textAlignment = NSTextAlignmentCenter;
        _yh_naviDefaultTitleLabel.font = [UIFont boldSystemFontOfSize:17];
        _yh_naviDefaultTitleLabel.textColor = [UIColor blackColor];
        _yh_naviDefaultTitleLabel.numberOfLines = 1;
        _yh_naviDefaultTitleLabel.adjustsFontSizeToFitWidth = NO;
    }
    return _yh_naviDefaultTitleLabel;
}

- (UIView *)yh_safeAreaView{
    if (!_yh_safeAreaView) {
        _yh_safeAreaView = [[UIView alloc] init];
    }
    return _yh_safeAreaView;
}
@end
