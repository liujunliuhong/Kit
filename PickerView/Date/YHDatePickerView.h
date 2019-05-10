//
//  YHDatePickerView.h
//  FrameDating
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHPickerToolBar.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, YHDatePickerStyle) {
    YHDatePickerStyle_Date,
    YHDatePickerStyle_DateTime,
    YHDatePickerStyle_Time,
};

/**
 * Date Picker.
 * 系统UIDatePicker封装.
 */
@interface YHDatePickerView : UIView

- (instancetype)initWithTitle:(NSString *)title;

/**
 * toolBar.
 */
@property (nonatomic, strong, readonly) YHPickerToolBar *toolBar;

/**
 * 样式.
 */
@property (nonatomic, assign) YHDatePickerStyle pickerStyle;

/**
 * 设置最小日期.
 */
@property (nonatomic, strong) NSDate *minimumDate;

/**
 * 设置最大日期.
 */
@property (nonatomic, strong) NSDate *maximumDate;

/**
 * 设置当前日期.
 */
@property (nonatomic, strong) NSDate *currentDate;

/**
 * 分割线颜色.
 */
@property (nonatomic, strong) UIColor *separatorLineColor;

/**
 * 是否隐藏分割线.
 */
@property (nonatomic, assign) BOOL isHideSeparatorLine;

/**
 * 手动设置日期.
 */
- (void)setDate:(NSDate *)date animated:(BOOL)animated;

/**
 * 显示pickerView.
 */
- (void)showWithClickDoneCompletionBlock:(void(^)(NSDate *date))clickDoneCompletionBlock;

@end

NS_ASSUME_NONNULL_END
