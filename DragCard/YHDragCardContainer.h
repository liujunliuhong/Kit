//
//  YHDragCardContainer.h
//  FrameDating
//
//  Created by apple on 2019/5/22.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHDragCardConfig.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YHDragCardDirection) {
    YHDragCardDirection_Left,
    YHDragCardDirection_Right,
    YHDragCardDirection_Default,
};

@class YHDragCardContainer;
@protocol YHDragCardContainerDataSource <NSObject>
@required;
- (NSInteger)numberOfCardWithCardContainer:(YHDragCardContainer *)cardContainer;
@end



/**
 * 仿探探卡牌滑动
 * 时隔2年多，再一次封装，想想当初作为小白，看到github上的卡牌滑动源码，........
 */
@interface YHDragCardContainer : UIView

@property (nonatomic, weak) id<YHDragCardContainerDataSource> dataSource;

- (instancetype)initWithFrame:(CGRect)frame config:(YHDragCardConfig *)config;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
