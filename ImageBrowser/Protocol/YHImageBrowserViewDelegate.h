//
//  YHImageBrowserViewDelegate.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/16.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * YHImageBrowserView代理
 */
@class YHImageBrowserView;
@protocol YHImageBrowserViewDelegate <NSObject>
/**
 * 索引发生变化的代理
 */
- (void)yh_imageBrowserView:(YHImageBrowserView *)browserView pageIndexChanged:(NSUInteger)index;

/**
 * 开始pan手势的代理
 */
- (void)yh_willStartPanDownWithImageBrowserView:(YHImageBrowserView *)browserView;

/**
 * pan手势导致alpha变化的代理
 */
- (void)yh_imageBrowserView:(YHImageBrowserView *)browserView didChangeAlpha:(CGFloat)alpha;

/**
 * 重置由于pan手势导致的变化
 */
- (void)yh_imageBrowserView:(YHImageBrowserView *)browserView resetWithInterval:(NSTimeInterval)interval;

/**
 * dismiss
 */
- (void)yh_imageBrowserView:(YHImageBrowserView *)browserView dismissWithInterval:(NSTimeInterval)interval;

@end

NS_ASSUME_NONNULL_END
