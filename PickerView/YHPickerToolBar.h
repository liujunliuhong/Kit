//
//  YHPickerToolBar.h
//  FrameDating
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHPickerToolBar : UIView

@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, strong) UIColor *cancelTitleColor;
@property (nonatomic, strong) UIFont *cancelTitleFont;
@property (nonatomic, copy) void(^cancelBlock)(void);

@property (nonatomic, copy) NSString *doneTitle;
@property (nonatomic, strong) UIColor *doneTitleColor;
@property (nonatomic, strong) UIFont *doneTitleFont;
@property (nonatomic, copy) void(^doneBlock)(void);


@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont *titleFont;

@end

NS_ASSUME_NONNULL_END
