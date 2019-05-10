//
//  YHCommonPickerView.m
//  FrameDating
//
//  Created by apple on 2019/5/10.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHCommonPickerView.h"
#import "YHMacro.h"


#define kToolBarHeight                    49.0
#define kPickerHeight                     220.0
#define kBackgroundColor(__ratio__)       [[UIColor blackColor] colorWithAlphaComponent:__ratio__]

@interface YHCommonPickerView() <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) YHPickerToolBar *toolBar;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, copy) void(^clickDoneCompletionBlock)(NSArray<NSNumber *> *selectedIndexes);
@end



@implementation YHCommonPickerView
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
        
        self.pickerView = [[UIPickerView alloc] init];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        self.pickerView.showsSelectionIndicator = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.maskView addGestureRecognizer:tap];
        
        
        __weak typeof(self) weakSelf = self;
        self.toolBar.cancelBlock = ^{
            [weakSelf dismiss];
        };
        self.toolBar.doneBlock = ^{
            if (weakSelf.clickDoneCompletionBlock) {
                NSMutableArray<NSNumber*> *selectedIndexes = [[NSMutableArray alloc] init];
                for (NSInteger component = 0; component < weakSelf.pickerView.numberOfComponents; component++) {
                    NSInteger row = [weakSelf.pickerView selectedRowInComponent:component];
                    [selectedIndexes addObject:@(row)];
                }
                weakSelf.clickDoneCompletionBlock(selectedIndexes);
            }
            [weakSelf dismiss];
        };
        
        self.separatorLineColor = [UIColor groupTableViewBackgroundColor];
        self.isHideSeparatorLine = NO;
        self.titleFontForComponents = [UIFont boldSystemFontOfSize:20];
        self.titleColorForComponents = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for(UIView *speartorView in self.pickerView.subviews){
        if (speartorView.frame.size.height < 1) { //取出分割线view
            speartorView.backgroundColor = self.separatorLineColor;
            speartorView.hidden = self.isHideSeparatorLine;
        }
    }
}

#pragma mark ------------------ Private Methods ------------------

- (void)didChangeStatusBarOrientationNotification:(NSNotification *)noti{
    CGFloat contentHeight = [self getContentHeight];
    
    self.backgroundView.frame = [UIScreen mainScreen].bounds;
    self.maskView.frame = [UIScreen mainScreen].bounds;
    self.frame = CGRectMake(0, CGRectGetHeight(self.backgroundView.frame) - contentHeight, CGRectGetWidth(self.backgroundView.frame), contentHeight);
    self.toolBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), kToolBarHeight);
    self.pickerView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBar.frame), CGRectGetWidth(self.maskView.frame), kPickerHeight);
}



- (CGFloat)getContentHeight{
    CGFloat contentHeight = 0.0;
    if (YH_DeviceOrientation == UIInterfaceOrientationPortrait || YH_DeviceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        // 倒立翻转就不考虑了，还没有见到过这样的应用
        contentHeight += YH_Bottom_Height;
    }
    contentHeight += kPickerHeight;
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

#pragma mark ------------------ Public Methods ------------------
- (void)setSelectedIndexes:(NSArray<NSNumber *> *)selectedIndexes animated:(BOOL)animated{
    NSUInteger totalComponent = MIN(MIN(selectedIndexes.count, self.pickerView.numberOfComponents), self.titlesForComponents.count);
    for (NSInteger component = 0; component < totalComponent; component++) {
        NSArray *items = self.titlesForComponents[component];
        NSUInteger selectIndex = [selectedIndexes[component] unsignedIntegerValue];
        if (selectIndex < items.count) {
            [self.pickerView selectRow:selectIndex inComponent:component animated:animated];
        }
    }
}

- (void)reloadComponent:(NSInteger)component{
    [self.pickerView reloadComponent:component];
}

- (void)reloadAllComponents{
    [self.pickerView reloadAllComponents];
}

- (void)showWithClickDoneCompletionBlock:(void (^)(NSArray<NSNumber *> * _Nonnull))clickDoneCompletionBlock{
    [self reloadAllComponents];
    
    self.clickDoneCompletionBlock = clickDoneCompletionBlock;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.maskView];
    [self.backgroundView addSubview:self];
    [self addSubview:self.toolBar];
    [self addSubview:self.pickerView];
    
    CGFloat contentHeight = [self getContentHeight];
    
    
    self.backgroundView.frame = [UIScreen mainScreen].bounds;
    self.maskView.frame = [UIScreen mainScreen].bounds;
    self.frame = CGRectMake(0, CGRectGetMaxY(self.backgroundView.frame), CGRectGetWidth(self.backgroundView.frame), contentHeight);
    self.toolBar.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), kToolBarHeight);
    self.pickerView.frame = CGRectMake(0, CGRectGetMaxY(self.toolBar.frame), CGRectGetWidth(self.maskView.frame), kPickerHeight);
    
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

#pragma mark ------------------ Tap Action ------------------
- (void)tapAction:(UITapGestureRecognizer *)gesture{
    [self dismiss];
}

#pragma mark ------------------ UIPickerViewDataSource ------------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.titlesForComponents.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [self.titlesForComponents[component] count];
}

#pragma mark ------------------ UIPickerViewDelegate ------------------
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *labelText = [[UILabel alloc] init];
    labelText.textColor = self.titleColorForComponents;
    labelText.font = self.titleFontForComponents;
    labelText.text = self.titlesForComponents[component][row];
    labelText.textAlignment = NSTextAlignmentCenter;
    labelText.adjustsFontSizeToFitWidth = YES;
    return labelText;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

#pragma mark ------------------ Setter ------------------
- (void)setSeparatorLineColor:(UIColor *)separatorLineColor{
    _separatorLineColor = separatorLineColor;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setIsHideSeparatorLine:(BOOL)isHideSeparatorLine{
    _isHideSeparatorLine = isHideSeparatorLine;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
