//
//  UIView+YHImageBrowserProgressView.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/17.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YHImageBrowserProgressView)
/**
 * 显示进度
 */
- (void)yh_showProgressViewWithValue:(CGFloat)value;
/**
 * 显示菊花旋转
 */
- (void)yh_showLoading;
/**
 * 隐藏
 */
- (void)yh_hideProgressView;
@end

NS_ASSUME_NONNULL_END
