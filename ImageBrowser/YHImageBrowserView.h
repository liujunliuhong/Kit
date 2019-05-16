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


@property (nonatomic, weak) id<YHImageBrowserViewDataSource> yh_dataSource;


// 当前索引
@property (nonatomic, assign, readonly) NSUInteger currentIndex;

- (void)updateLayoutWithDirection:(YHImageBrowserLayoutDirection)direction containerSize:(CGSize)containerSize;

@end

NS_ASSUME_NONNULL_END
