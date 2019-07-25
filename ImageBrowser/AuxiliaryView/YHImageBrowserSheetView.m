//
//  YHImageBrowserSheetView.m
//  HiFanSmooth
//
//  Created by 银河 on 2019/5/17.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHImageBrowserSheetView.h"
#import "YHMacro.h"

#if __has_include(<Masonry/Masonry.h>)
    #import <Masonry/Masonry.h>
#elif __has_include("Masonry.h")
    #import "Masonry.h"
#endif

#define kDividHeight        7.0
#define kRowHeight          50.0
#define kLineHeight         0.35
#define kColor(_ratio_)     [[UIColor blackColor] colorWithAlphaComponent:_ratio_]
#define kBaseTag            23412

#define kButtonEndColor     [[UIColor whiteColor] colorWithAlphaComponent:0.8]
#define kButtonStartColor   [[UIColor whiteColor] colorWithAlphaComponent:0.4]

@interface YHImageBrowserSheetView () {
    CGFloat _containerHeight;
}
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) UIWindow *window;
@end


@implementation YHImageBrowserSheetView

- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.window = [UIApplication sharedApplication].keyWindow;
        
        self.backgroundView = [[UIView alloc] init];
        self.maskView = [[UIView alloc] init];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientation:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

- (void)didChangeStatusBarOrientation:(NSNotification *)noti{
    [self updateFrame];
}

- (void)updateFrame{
    self.backgroundView.frame = CGRectMake(0, 0, YH_ScreenWidth, YH_ScreenHeight);
    self.maskView.frame = CGRectMake(0, 0, YH_ScreenWidth, YH_ScreenHeight);
    
    CGRect frame = self.effectView.frame;
    frame.origin.x = 0.0;
    frame.size.width = self.window.bounds.size.width;
    frame.size.height = _containerHeight;
    frame.origin.y = self.window.bounds.size.height - _containerHeight;
    self.frame = frame;
    self.effectView.frame = self.bounds;
}

#pragma mark ------------------ Public ------------------
- (void)show{
    self.backgroundView.backgroundColor = [UIColor clearColor];
    [self.window addSubview:self.backgroundView];
    
    self.maskView.backgroundColor = kColor(0.0);
    [self.backgroundView addSubview:self.maskView];
    
    [self.window addSubview:self];
    
    [self addSubview:self.effectView];
    
    self.backgroundView.frame = CGRectMake(0, 0, YH_ScreenWidth, YH_ScreenHeight);
    self.maskView.frame = CGRectMake(0, 0, YH_ScreenWidth, YH_ScreenHeight);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.backgroundView addGestureRecognizer:tap];
    
    
    
    BOOL shouldHideCancel = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldHideCancelForSheetView:)]) {
        shouldHideCancel = [self.delegate shouldHideCancelForSheetView:self];
    }
    
    [self.effectView.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    NSArray<NSString *> *titles = [self.dataSource titlesForSheetView:self];
    
    __block CGFloat h = 0.0;
    __block UIView *topView = nil;
    if (titles && titles.count > 0) {
        [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
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
            // Masonry布局，方便控制内部元素的约束
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.effectView.contentView.mas_left);
                make.right.equalTo(self.effectView.contentView.mas_right);
                make.height.mas_equalTo(kRowHeight);
                if (topView) {
                    make.top.equalTo(topView.mas_bottom);
                } else {
                    make.top.equalTo(self.effectView.contentView);
                }
            }];
            
            h += kRowHeight;
            topView = button;
            
            if (titles.count > 1) { // 大于1才添加line
                if (idx != titles.count - 1) { // 最后一个没有line
                    UIView *line = [[UIView alloc] init];
                    line.backgroundColor = [UIColor colorWithRed:175 / 255.0 green:175 / 255.0 blue:175 / 255.0 alpha:1];;
                    [self.effectView.contentView addSubview:line];
                    // Masonry布局，方便控制内部元素的约束
                    [line mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.effectView.contentView.mas_left);
                        make.right.equalTo(self.effectView.contentView.mas_right);
                        make.height.mas_equalTo(kLineHeight);
                        if (topView) {
                            make.top.equalTo(topView.mas_bottom);
                        } else {
                            make.top.equalTo(self.effectView.contentView);
                        }
                    }];
                    h += kLineHeight;
                    topView = line;
                }
            }
        }];
    }
    
    
    if (!shouldHideCancel) {
        NSString *cancelTitle = @"取消";
        if (self.delegate && [self.delegate respondsToSelector:@selector(titleForCancelWithSheetView:)]) {
            cancelTitle = [self.delegate titleForCancelWithSheetView:self];
        }
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, h, self.window.bounds.size.width, kRowHeight);
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
        // Masonry布局，方便控制内部元素的约束
        if (titles && titles.count > 0) {
            h += kDividHeight;
            [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.effectView.contentView.mas_left);
                make.right.equalTo(self.effectView.contentView.mas_right);
                make.height.mas_equalTo(kRowHeight);
                if (topView) {
                    make.top.equalTo(topView.mas_bottom).mas_offset(kDividHeight);
                } else {
                    make.top.equalTo(self.effectView.contentView).mas_offset(kDividHeight);
                }
            }];
            h += kRowHeight;
        } else {
            [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.effectView.contentView.mas_left);
                make.right.equalTo(self.effectView.contentView.mas_right);
                make.height.mas_equalTo(kRowHeight);
                if (topView) {
                    make.top.equalTo(topView.mas_bottom);
                } else {
                    make.top.equalTo(self.effectView.contentView);
                }
            }];
            h += kRowHeight;
        }
    }
    
    h += YH_Bottom_Height;
    
    
    _containerHeight = h;
    
    
    
    CGRect frame = self.effectView.frame;
    frame.origin.x = 0.0;
    frame.size.width = self.window.bounds.size.width;
    frame.size.height = _containerHeight;
    frame.origin.y = self.window.bounds.size.height;
    self.frame = frame;
    
    self.effectView.frame = self.bounds;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame1 = self.frame;
        frame1.origin.y = self.window.bounds.size.height - frame1.size.height;
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
    if (_delegate && [_delegate respondsToSelector:@selector(sheetViewDicClickCancel:)]) {
        [_delegate sheetViewDicClickCancel:self];
    } else {
        [self hide];
    }
}

#pragma mark ------------------ Gesture Action ------------------
- (void)tapAction:(UITapGestureRecognizer *)gesture{
    [self hide];
}


@end

