//
//  YHImageBrowserViewDataSource.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/16.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHImageBrowserCellDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@class YHImageBrowserView;
/**
 * YHImageBrowserView数据源
 */
@protocol YHImageBrowserViewDataSource <NSObject>

@required;

// item个数
- (NSUInteger)yh_numberOfCellForImageBrowserView:(YHImageBrowserView *)imageBrowserView;

// item所属data赋值
- (id<YHImageBrowserCellDataProtocol>)yh_imageBrowserView:(YHImageBrowserView *)imageBrowserView dataForCellAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
