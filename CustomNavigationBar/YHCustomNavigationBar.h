//
//  YHCustomNavigationBar.h
//  Kit
//
//  Created by apple on 2019/1/24.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

NS_CLASS_AVAILABLE_IOS(8_0) @interface YHCustomNavigationBar : UIView

// 导航栏左边的偏移量
// 默认0.0
@property (nonatomic, assign) CGFloat leftHorizontalEdgeInset;

// 导航栏左边的偏移量
// 默认0.0
@property (nonatomic, assign) CGFloat rightHorizontalEdgeInset;

// 导航栏的leftViews集合
// 对于其中的每个元素，都可以自行设置其宽度，如果没有设置，那么宽度默认为itemBaseWidth
@property (nonatomic, strong, nullable) NSArray<UIView *> *leftViews;

// 导航栏的rightViews集合
// 对于其中的每个元素，都可以自行设置其宽度，如果没有设置，那么宽度默认为itemBaseWidth
// 特别注意，该集合中，第一个元素将在最右边
@property (nonatomic, strong, nullable) NSArray<UIView *> *rightViews;

@property (nonatomic, strong, readonly) UIView *barContentView;

// 导航栏底部的View，可参考斗鱼首页的导航栏样式以及今日头条首页的导航栏样式
// 必须设置高度
@property (nonatomic, strong, nullable) UIView *bottomView;

// 当前导航栏底部View的高度
@property (nonatomic, assign, readonly) CGFloat currentBottomViewHeight;

// 导航栏的titleView
// titleView的宽度会根据leftViews和leftViews做适配
@property (nonatomic, strong) UIView *titleView;

// 导航栏的底部线条
// backgroundColor                    : [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1]
@property (nonatomic, strong, readonly) UIView *line;

+ (CGFloat)itemBaseWidth;
+ (CGFloat)barHeight;

// 更新导航栏的subViews
//- (void)updateNavigationBar;

- (void)updateSubViewsConstraint;

@end

NS_ASSUME_NONNULL_END
