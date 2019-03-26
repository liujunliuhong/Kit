//
//  UINavigationController+YHRotationExtension.m
//  Kit
//
//  Created by 银河 on 2019/1/31.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "UINavigationController+YHRotationExtension.h"

@implementation UINavigationController (YHRotationExtension)

// 屏幕旋转以当前所在的navi或者VC为准
- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController*)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if (rootViewController.childViewControllers.count > 0) {
        return [self topViewControllerWithRootViewController:rootViewController.childViewControllers.lastObject];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        return ((UINavigationController *)rootViewController).viewControllers.lastObject;
    } else {
        return rootViewController;
    }
}

#pragma mark - StatusBar
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    UIViewController *vc = [self topViewControllerWithRootViewController:self];
    return vc.preferredStatusBarUpdateAnimation;
}
- (UIViewController *)childViewControllerForStatusBarStyle{
    UIViewController *vc = [self topViewControllerWithRootViewController:self];
    NSLog(@"%ld", vc.preferredStatusBarStyle);
    return vc;
}
- (UIViewController *)childViewControllerForStatusBarHidden{
    UIViewController *vc = [self topViewControllerWithRootViewController:self];
    return vc;
}
- (BOOL)shouldAutorotate{
    UIViewController *vc = [self topViewControllerWithRootViewController:self];
    return vc.shouldAutorotate;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    UIViewController *vc = [self topViewControllerWithRootViewController:self];
    return vc.supportedInterfaceOrientations;
}



//这个方法感觉没怎么调用。。。。em......
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    UIViewController *vc = [self topViewControllerWithRootViewController:self];
    return vc.preferredInterfaceOrientationForPresentation;
}


@end
