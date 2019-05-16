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

@end

NS_ASSUME_NONNULL_END
