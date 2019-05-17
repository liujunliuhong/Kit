//
//  YHImageBrowserSheetView.m
//  HiFanSmooth
//
//  Created by 银河 on 2019/5/17.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHImageBrowserSheetView.h"
#import "YHImageBrowserDefine.h"

#define kDividHeight        7.0
#define kRowHeight          50.0
#define kLineHeight         0.35
#define kColor(_ratio_)     [[UIColor blackColor] colorWithAlphaComponent:_ratio_]
#define kBaseTag            23412

#define kButtonEndColor     [[UIColor whiteColor] colorWithAlphaComponent:0.8]
#define kButtonStartColor   [[UIColor whiteColor] colorWithAlphaComponent:0.4]

@interface YHImageBrowserSheetView ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@end


@implementation YHImageBrowserSheetView

- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundView = [[UIView alloc] init];
        self.maskView = [[UIView alloc] init];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    }
    return self;
}

#pragma mark ------------------ Public ------------------
- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundView.frame = window.bounds;
    [window addSubview:self.backgroundView];
    
    self.maskView.backgroundColor = kColor(0.0);
    self.maskView.frame = window.bounds;
    [self.backgroundView addSubview:self.maskView];
    
    [window addSubview:self];
    
    [self addSubview:self.effectView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.backgroundView addGestureRecognizer:tap];
    
    
    BOOL shouldHideCancel = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldHideCancelForSheetView:)]) {
        shouldHideCancel = [self.delegate shouldHideCancelForSheetView:self];
    }
    
    NSArray<NSString *> *titles = [self.dataSource titlesForSheetView:self];
    
    __block CGFloat h = 0.0;
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, h, window.bounds.size.width, kRowHeight);
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        button.tag = kBaseTag + idx;
        button.backgroundColor = kButtonEndColor;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(buttonTouchDownAction:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(buttonDragEnterAction:) forControlEvents:UIControlEventTouchDragEnter];
        [button addTarget:self action:@selector(buttonDragExitAction:) forControlEvents:UIControlEventTouchDragExit];
        [button addTarget:self action:@selector(buttonTouchCancelAction:) forControlEvents:UIControlEventTouchCancel];
        [self.effectView.contentView addSubview:button];
        h += kRowHeight;
        
        if (titles.count > 1) {
            if (idx != titles.count - 1) {   
                UIView *line = [[UIView alloc] init];
                line.backgroundColor = [UIColor colorWithRed:175 / 255.0 green:175 / 255.0 blue:175 / 255.0 alpha:1];;
                line.frame = CGRectMake(0, button.frame.origin.y + button.frame.size.height, window.bounds.size.width, kLineHeight);
                [self.effectView.contentView addSubview:line];
                h += kLineHeight;
            }
        }
    }];
    
    if (!shouldHideCancel) {
        h += kDividHeight;
        
        NSString *cancelTitle = @"取消";
        if (self.delegate && [self.delegate respondsToSelector:@selector(titleForCancelWithSheetView:)]) {
            cancelTitle = [self.delegate titleForCancelWithSheetView:self];
        }
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, h, window.bounds.size.width, kRowHeight);
        [cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        cancelButton.backgroundColor = kButtonEndColor;
        [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [cancelButton addTarget:self action:@selector(buttonTouchDownAction:) forControlEvents:UIControlEventTouchDown];
        [cancelButton addTarget:self action:@selector(buttonDragEnterAction:) forControlEvents:UIControlEventTouchDragEnter];
        [cancelButton addTarget:self action:@selector(buttonDragExitAction:) forControlEvents:UIControlEventTouchDragExit];
        [cancelButton addTarget:self action:@selector(buttonTouchCancelAction:) forControlEvents:UIControlEventTouchCancel];
        [self.effectView.contentView addSubview:cancelButton];
        
        h += kRowHeight;
    }
    
    if (YHImageBrowser_IS_IPHONE_X) {
        h += YHImageBrowser__Bottom_Height;
    }
    
    
    CGRect frame = self.effectView.frame;
    frame.origin.x = 0.0;
    frame.size.width = window.bounds.size.width;
    frame.size.height = h;
    frame.origin.y = window.bounds.size.height;
    self.frame = frame;
    
    self.effectView.frame = self.bounds;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame1 = self.frame;
        frame1.origin.y = window.bounds.size.height - frame1.size.height;
        self.frame = frame1;
        
        self.maskView.backgroundColor = kColor(0.4);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.frame;
        frame.origin.y += frame.size.height;
        self.frame = frame;
        
        self.maskView.backgroundColor = kColor(0.0);
        
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sheetViewDidHide:)]) {
            [self.delegate sheetViewDidHide:self];
        }
        [self.effectView removeFromSuperview];
        [self removeFromSuperview];
        [self.maskView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
    }];
}

#pragma mark ------------------ Button Action ------------------
- (void)buttonAction:(UIButton *)sender{
    int index = (int)(sender.tag - kBaseTag);
    if (self.delegate && [self.delegate respondsToSelector:@selector(sheetView:didClickIndex:)]) {
        [self.delegate sheetView:self didClickIndex:index];
    }
    [self hide];
}

- (void)buttonTouchDownAction:(UIButton *)sender{
    sender.backgroundColor = kButtonStartColor;
}

- (void)buttonDragEnterAction:(UIButton *)sender{
    sender.backgroundColor = kButtonStartColor;
}

- (void)buttonDragExitAction:(UIButton *)sender{
    sender.backgroundColor = kButtonEndColor;
}

- (void)buttonTouchCancelAction:(UIButton *)sender{
    sender.backgroundColor = kButtonEndColor;
}

- (void)cancelAction:(UIButton *)sender{
    [self hide];
}

#pragma mark ------------------ Gesture Action ------------------
- (void)tapAction:(UITapGestureRecognizer *)gesture{
    [self hide];
}


@end

