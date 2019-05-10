//
//  YHCommonPickerView.h
//  FrameDating
//
//  Created by apple on 2019/5/10.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHPickerToolBar.h"


NS_ASSUME_NONNULL_BEGIN
/**
 * Common Picker.
 * Text Picker.
 */
@interface YHCommonPickerView : UIView

- (instancetype)initWithTitle:(NSString *)title;

/**
 * 分割线颜色.
 */
@property (nonatomic, strong) UIColor *separatorLineColor;

/**
 * 是否隐藏分割线.
 */
@property (nonatomic, assign) BOOL isHideSeparatorLine;

/**
 * pickerView标题字体.
 */
@property (nonatomic, strong) UIFont *titleFontForComponents;

/**
 * pickerView标题颜色.
 */
@property (nonatomic, strong) UIColor *titleColorForComponents;

/**
 * toolBar.
 */
@property (nonatomic, strong, readonly) YHPickerToolBar *toolBar;

/**
 * 数据源.
 */
@property (nonatomic, strong) NSArray<NSArray <NSString *>*> *titlesForComponents;

/**
 * 设置选中的行.
 */
- (void)setSelectedIndexes:(NSArray<NSNumber*> *)selectedIndexes animated:(BOOL)animated;

/**
 * reload component.
 */
- (void)reloadComponent:(NSInteger)component;

/**
 * reload all components.
 */
- (void)reloadAllComponents;

/**
 * 显示pickerView.
 */
- (void)showWithClickDoneCompletionBlock:(void(^)(NSArray<NSNumber *> *selectedIndexes))clickDoneCompletionBlock;

@end

NS_ASSUME_NONNULL_END
