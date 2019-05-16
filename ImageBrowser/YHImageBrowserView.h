//
//  YHImageBrowserView.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/16.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHImageBrowserLayoutDirectionManager.h"
#import "YHImageBrowserViewDataSource.h"
#import "YHImageBrowserViewDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHImageBrowserView : UICollectionView

/**
 * 数据源
 */
@property (nonatomic, weak) id<YHImageBrowserViewDataSource> yh_dataSource;

/**
 * 代理
 */
@property (nonatomic, weak) id<YHImageBrowserViewDelegate> yh_delegate;

/**
 * 当前currentIndex所对应的data（只读）
 */
@property (nonatomic, strong, readonly) id<YHImageBrowserCellDataProtocol> currentData;

/**
 * 当前索引（只读）
 */
@property (nonatomic, assign, readonly) NSUInteger currentIndex;

/**
 * 根据屏幕旋转方向更新布局
 */
- (void)updateLayoutWithDirection:(YHImageBrowserLayoutDirection)direction containerSize:(CGSize)containerSize;

/**
 * 滑动到指定索引
 */
- (void)scrollToPageIndex:(NSInteger)index;


@end

NS_ASSUME_NONNULL_END
