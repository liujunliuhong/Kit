//
//  YHImageBrowser.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/16.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHImageBrowserCellDataProtocol.h"
#import "YHImageBrowserCellData.h"
#import "YHImageBrowserDelegate.h"
#import "YHImageBrowserDataSource.h"
#import "YHImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHImageBrowser : UIView

/**
 * 数据源设置方式1
 */
@property (nonatomic, strong) NSArray<id<YHImageBrowserCellDataProtocol>> *dataSourceArray;

/**
 * 数据源设置方式2
 */
@property (nonatomic, weak) id<YHImageBrowserDataSource> dataSource;

/**
 * 代理
 */
@property (nonatomic, weak) id<YHImageBrowserDelegate> delegate;


/**
 * 当前索引所对应的data
 */
@property (nonatomic, strong, readonly) id<YHImageBrowserCellDataProtocol> currentData;

/**
 * 当前索引
 * setter、getter
 */
@property (nonatomic, assign) int currentIndex;


- (instancetype)init;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 * show
 */
- (void)show;

/**
 * dismiss
 */
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
