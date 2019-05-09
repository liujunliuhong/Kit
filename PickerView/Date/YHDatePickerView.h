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


@interface YHDatePickerView : UIView

- (instancetype)initWithTitle:(NSString *)title;

@property (nonatomic, strong, readonly) YHPickerToolBar *toolBar;
@property (nonatomic, assign) YHDatePickerStyle pickerStyle;
@property (nonatomic, strong) NSDate *minimumDate;
@property (nonatomic, strong) NSDate *maximumDate;
@property (nonatomic, strong) NSDate *currentDate;


- (void)setDate:(NSDate *)date animated:(BOOL)animated;


- (void)showWithClickDoneCompletionBlock:(void(^)(NSDate *date))clickDoneCompletionBlock;

@end

NS_ASSUME_NONNULL_END
