//
//  YHImageBrowserDelegate.h
//  HiFanSmooth
//
//  Created by 银河 on 2019/5/18.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class YHImageBrowser;
@protocol YHImageBrowserDelegate <NSObject>
@optional;

/**
 * 索引发生变化的代理.
 */
- (void)imageBrowser:(YHImageBrowser *)imageBrowser pageIndexChanged:(NSUInteger)index;

/**
 * YHImageBrowser长按.
 * 如果不实现该协议，长按时，框架内部使用默认的sheetView.
 */
- (void)imageBrowser:(YHImageBrowser *)imageBrowser longGesture:(UILongPressGestureRecognizer *)longGesture;

/**
 * toolBar.
 * 如果不实现该协议，框架内部使用默认的toolBar.
 */
- (UIView *)viewForToolBarWithImageBrowser:(YHImageBrowser *)imageBrowser;

/**
 * toolBar的高度.
 * 如果不实现该协议，框架内部将根据屏幕旋转方向选择合适的高度.
 */
- (CGFloat)heightForToolBarWithImageBrowser:(YHImageBrowser *)imageBrowser;

/**
 * imageBrowser dismiss.
 */
- (void)imageBrowserDidDismiss:(YHImageBrowser *)imageBrowser;

/**
 * imageBrowser的BottomView（与toolBar对应，在屏幕底部）.
 */
- (UIView *)bottomViewForImageBrowser:(YHImageBrowser *)imageBrowser;

/**
 * BottomView的高度.
 */
- (CGFloat)imageBrowser:(YHImageBrowser *)imageBrowser heightForBottomView:(CGFloat)heightForBottomView;

@end

NS_ASSUME_NONNULL_END
