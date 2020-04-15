//
//  YHImageBrowserLayoutDirectionManager.m
//  HiFanSmooth
//
//  Created by apple on 2019/5/16.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHImageBrowserLayoutDirectionManager.h"

@implementation YHImageBrowserLayoutDirectionManager

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)startObserve{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

+ (YHImageBrowserLayoutDirection)getCurrntLayoutDirection{
    UIInterfaceOrientation obr = [UIApplication sharedApplication].statusBarOrientation;
    if ((obr == UIInterfaceOrientationPortrait) || (obr == UIInterfaceOrientationPortraitUpsideDown)) {
        return YHImageBrowserLayoutDirection_Vertical;
    } else if ((obr == UIInterfaceOrientationLandscapeLeft) || (obr == UIInterfaceOrientationLandscapeRight)) {
        return YHImageBrowserLayoutDirection_Horizontal;
    } else {
        return YHImageBrowserLayoutDirection_Vertical;
    }
}


- (void)applicationDidChangeStatusBarOrientationNotification:(NSNotification *)note {
    if (self.layoutDirectionChangedBlock) {
        self.layoutDirectionChangedBlock([self.class getCurrntLayoutDirection]);
    }
}
@end
