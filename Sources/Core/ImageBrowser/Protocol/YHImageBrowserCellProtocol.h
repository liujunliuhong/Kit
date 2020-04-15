//
//  YHImageBrowserCellProtocol.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/14.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHImageBrowserCellDataProtocol.h"
#import "YHImageBrowserLayoutDirectionManager.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * cell协议
 */
@protocol YHImageBrowserCellProtocol <NSObject>
@required;

// 设置cell初始data
- (void)yh_browserSetInitialCellData:(id<YHImageBrowserCellDataProtocol>)data layoutDirection:(YHImageBrowserLayoutDirection)layoutDirection containerFrame:(CGRect)containerFrame;

// 屏幕旋转
- (void)yh_browserLayoutDirectionChanged:(YHImageBrowserLayoutDirection)layoutDirection containerFrmae:(CGRect)containerFrame;


@optional;
@property (nonatomic, copy) void(^yh_browserStartPanDownBlock)(void);
@property (nonatomic, copy) void(^yh_browserEndPanDownBlock)(void);
@property (nonatomic, copy) void(^yh_browserChangePanDownBlock)(CGFloat alpha);
@property (nonatomic, copy) void(^yh_browserResetPanDownBlock)(NSTimeInterval interval);
@property (nonatomic, copy) void(^yh_browserDismissPanDownBlock)(NSTimeInterval interval);
@end

NS_ASSUME_NONNULL_END
