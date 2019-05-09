//
//  YHDatePickerView.m
//  FrameDating
//
//  Created by apple on 2019/5/9.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHDatePickerView.h"
#import "YHMacro.h"


#define kToolBarHeight                    49.0
#define kBackgroundColor(__ratio__)       [[UIColor blackColor] colorWithAlphaComponent:__ratio__]

@interface YHDatePickerView()
@property (nonatomic, strong) YHPickerToolBar *toolBar;
@property (nonatomic, strong) UIDatePicker *pickerView;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, copy) void(^clickDoneCompletionBlock)(NSDate *date);
@end

@implementation YHDatePickerView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
        
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        
        self.maskView = [[UIView alloc] init];
        self.maskView.backgroundColor = kBackgroundColor(0.0);
        
        self.toolBar = [[YHPickerToolBar alloc] init];
        self.toolBar.title = title;
        
        self.pickerView = [[UIDatePicker alloc] init];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.maskView addGestureRecognizer:tap];
        
        
        __weak typeof(self) weakSelf = self;
        self.toolBar.cancelBlock = ^{
            [weakSelf dismiss];
        };
        self.toolBar.doneBlock = ^{
            if (weakSelf.clickDoneCompletionBlock) {
                weakSelf.clickDoneCompletionBlock(weakSelf.pickerView.date);
            }
            [weakSelf dismiss];
        };
        
        
    }
    return self;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    // 设置分割线颜色
    for (UIView *subView1 in self.pickerView.subviews) {
        if ([subView1 isKindOfClass:[UIPickerView class]]) { //取出UIPickerView(这儿不是UIDatePicker)
            for (UIView *subView2 in subView1.subviews) {
                if (subView2.frame.size.height < 1) {  //取出分割线view
                    subView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
                }
            }
        }
    }
}

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti{
    CGFloat contentHeight = [self getContentHeight];
    
    self.backgroundView.frame = [UIScreen mainScreen].bounds;
    self.maskView.frame = [UIScreen mainScreen].bounds;
    self.frame = CGRectMake(0, CGRectGetHeight(self.maskView.frame) - contentHeight, CGRectGetWidth(self.maskView.frame), contentHeight);
    self.toolBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), kToolBarHeight);
    self.pickerView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBar.frame), CGRectGetWidth(self.maskView.frame), self.pickerView.frame.size.height);
}

- (void)setDate:(NSDate *)date animated:(BOOL)animated{
    [self.pickerView setDate:date animated:animated];
}


- (void)showWithClickDoneCompletionBlock:(void (^)(NSDate * _Nonnull))clickDoneCompletionBlock{
    
    self.clickDoneCompletionBlock = clickDoneCompletionBlock;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.maskView];
    [self.maskView addSubview:self];
    [self addSubview:self.toolBar];
    [self addSubview:self.pickerView];
    
    
    CGFloat contentHeight = [self getContentHeight];
    
    self.backgroundView.frame = [UIScreen mainScreen].bounds;
    self.maskView.frame = [UIScreen mainScreen].bounds;
    self.frame = CGRectMake(0, CGRectGetMaxY(self.maskView.frame), CGRectGetWidth(self.maskView.frame), contentHeight);
    self.toolBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), kToolBarHeight);
    self.pickerView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBar.frame), CGRectGetWidth(self.maskView.frame), self.pickerView.frame.size.height);
    
    self.maskView.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, CGRectGetHeight(self.maskView.frame) - contentHeight, CGRectGetWidth(self.maskView.frame), contentHeight);
        self.maskView.backgroundColor = kBackgroundColor(0.4);
    } completion:^(BOOL finished) {
        self.maskView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
    }];
}

- (CGFloat)getContentHeight{
    CGFloat contentHeight = 0.0;
    if (YH_DeviceOrientation == UIInterfaceOrientationPortrait || YH_DeviceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        // 倒立翻转就不考虑了，还没有见到过这样的a应用
        contentHeight += YH_Bottom_Height;
    }
    [self.pickerView sizeToFit];
    contentHeight += self.pickerView.frame.size.height;
    contentHeight += kToolBarHeight;
    return contentHeight;
}

- (void)dismiss{
    CGFloat contentHeight = [self getContentHeight];
    self.maskView.userInteractionEnabled = NO;
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = CGRectMake(0, CGRectGetMaxY(self.maskView.frame), CGRectGetWidth(self.maskView.frame), contentHeight);
        self.maskView.backgroundColor = kBackgroundColor(0.0);
    } completion:^(BOOL finished) {
        self.maskView.userInteractionEnabled = YES;
        self.userInteractionEnabled = YES;
        [self removeFromSuperview];
        [self.maskView removeFromSuperview];
        [self.backgroundView removeFromSuperview];
    }];
}

#pragma mark ------------------ Tap Action ------------------
- (void)tapAction:(UITapGestureRecognizer *)gesture{
    [self dismiss];
}

#pragma mark ------------------ Setter ------------------
- (void)setPickerStyle:(YHDatePickerStyle)pickerStyle{
    _pickerStyle = pickerStyle;
    switch (_pickerStyle) {
        case YHDatePickerStyle_Date:
        {
            self.pickerView.datePickerMode = UIDatePickerModeDate;
        }
            break;
        case YHDatePickerStyle_DateTime:
        {
            self.pickerView.datePickerMode = UIDatePickerModeDateAndTime;
        }
            break;
        case YHDatePickerStyle_Time:
        {
            self.pickerView.datePickerMode = UIDatePickerModeTime;
        }
            break;
        default:
            break;
    }
}

- (void)setMinimumDate:(NSDate *)minimumDate{
    _minimumDate = minimumDate;
    self.minimumDate = _minimumDate;
}

- (void)setMaximumDate:(NSDate *)maximumDate{
    _maximumDate = maximumDate;
    self.maximumDate = _maximumDate;
}

- (void)setCurrentDate:(NSDate *)currentDate{
    _currentDate = currentDate;
    self.pickerView.date = _currentDate;
}


@end
