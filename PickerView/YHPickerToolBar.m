//
//  YHPickerToolBar.m
//  FrameDating
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHPickerToolBar.h"
#import "YHMacro.h"


@interface YHPickerToolBar()
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UILabel *titleLabel;
@end


@implementation YHPickerToolBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = YH_RGB(215, 215, 217);
        
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cancelButton];
        
        self.doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.doneButton];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.cancelTitle = @"Cancel";
        self.cancelTitleFont = [UIFont boldSystemFontOfSize:17];
        self.cancelTitleColor = [UIColor blackColor];
        
        self.doneTitle = @"Sure";
        self.doneTitleFont = [UIFont boldSystemFontOfSize:17];
        self.doneTitleColor = [UIColor blackColor];
        
        self.titleFont = [UIFont systemFontOfSize:13];
        self.titleColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat actionWidth = 70.0;
    
    self.cancelButton.frame = CGRectMake(0, 0, actionWidth, CGRectGetHeight(self.frame));
    self.doneButton.frame = CGRectMake(CGRectGetWidth(self.frame) - actionWidth, 0, actionWidth, CGRectGetHeight(self.frame));
    
    self.titleLabel.center = CGPointMake(CGRectGetWidth(self.frame) / 2.0, CGRectGetHeight(self.frame) / 2.0);
    self.titleLabel.bounds = CGRectMake(0, 0, CGRectGetWidth(self.frame) - CGRectGetWidth(self.cancelButton.frame) - CGRectGetWidth(self.doneButton.frame), CGRectGetHeight(self.frame));
}

- (void)cancel{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)done{
    if (self.doneBlock) {
        self.doneBlock();
    }
}

#pragma mark ------------------ Setter ------------------
- (void)setCancelTitle:(NSString *)cancelTitle{
    _cancelTitle = cancelTitle;
    [self.cancelButton setTitle:_cancelTitle forState:UIControlStateNormal];
}

- (void)setCancelTitleColor:(UIColor *)cancelTitleColor{
    _cancelTitleColor = cancelTitleColor;
    [self.cancelButton setTitleColor:_cancelTitleColor forState:UIControlStateNormal];
}

- (void)setCancelTitleFont:(UIFont *)cancelTitleFont{
    _cancelTitleFont = cancelTitleFont;
    self.cancelButton.titleLabel.font = _cancelTitleFont;
}


- (void)setDoneTitle:(NSString *)doneTitle{
    _doneTitle = doneTitle;
    [self.doneButton setTitle:_doneTitle forState:UIControlStateNormal];
}

- (void)setDoneTitleFont:(UIFont *)doneTitleFont{
    _doneTitleFont = doneTitleFont;
    self.doneButton.titleLabel.font = _doneTitleFont;
}

- (void)setDoneTitleColor:(UIColor *)doneTitleColor{
    _doneTitleColor = doneTitleColor;
    [self.doneButton setTitleColor:_doneTitleColor forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setTitleFont:(UIFont *)titleFont{
    _titleFont = titleFont;
    self.titleLabel.font = _titleFont;
}

- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    self.titleLabel.textColor = _titleColor;
}

@end
