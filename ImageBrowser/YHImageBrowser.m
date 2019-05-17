//
//  YHImageBrowser.m
//  HiFanSmooth
//
//  Created by apple on 2019/5/16.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHImageBrowser.h"
#import "YHMacro.h"

#import "YHImageBrowserView.h"
#import "YHImageBrowserLayoutDirectionManager.h"

@interface YHImageBrowser() <YHImageBrowserViewDataSource, YHImageBrowserViewDelegate>
@property (nonatomic, strong) YHImageBrowserView *browserView;

@property (nonatomic, strong) YHImageBrowserLayoutDirectionManager *layoutDirectionManager;
@end

@implementation YHImageBrowser

- (void)dealloc
{
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        
        [self addGesture];
        
        [self.layoutDirectionManager startObserve];
        
        __weak typeof(self) weakSelf = self;
        self.layoutDirectionManager.layoutDirectionChangedBlock = ^(YHImageBrowserLayoutDirection direction) {
            [weakSelf updateLayoutOfSubViewsWithLayoutDirection:direction];
        };
    }
    return self;
}


- (void)updateLayoutOfSubViewsWithLayoutDirection:(YHImageBrowserLayoutDirection)direction{
    CGSize containerSize = CGSizeMake(YH_ScreenWidth, YH_ScreenHeight);
    self.frame = CGRectMake(0, 0, containerSize.width, containerSize.height);
    [self.browserView updateLayoutWithDirection:direction containerSize:containerSize];
}

- (void)addGesture {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLongPress:)];
    [self addGestureRecognizer:longPress];
}

#pragma mark ------------------ Public Methods ------------------
- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.window.windowLevel = UIWindowLevelAlert; // 隐藏状态栏(不用关心当前状态栏样式)
    [self addSubview:self.browserView];
    
    [self updateLayoutOfSubViewsWithLayoutDirection:[YHImageBrowserLayoutDirectionManager getCurrntLayoutDirection]];
    
    //[self.browserView scrollToPageIndex:1];
}

#pragma mark ------------------ Gesture Action ------------------
- (void)respondsToLongPress:(UILongPressGestureRecognizer *)longPressGesture{
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageBrowser:imageData:longGesture:)]) {
            [self.delegate imageBrowser:self imageData:self.browserView.currentData longGesture:longPressGesture];
            return;
        }
        
        
        
        
    }
}

#pragma mark ------------------ YHImageBrowserViewDataSource ------------------
- (NSUInteger)yh_numberOfCellForImageBrowserView:(YHImageBrowserView *)imageBrowserView{
    return self.dataSourceArray.count;
}

- (id<YHImageBrowserCellDataProtocol>)yh_imageBrowserView:(YHImageBrowserView *)imageBrowserView dataForCellAtIndex:(NSUInteger)index{
    return self.dataSourceArray[index];
}

#pragma mark ------------------ YHImageBrowserViewDelegate ------------------
- (void)yh_imageBrowserView:(YHImageBrowserView *)browserView pageIndexChanged:(NSUInteger)index{
    NSLog(@"当前索引:%d", (int)index);
}

#pragma mark ------------------ Getter ------------------
- (YHImageBrowserLayoutDirectionManager *)layoutDirectionManager{
    if (!_layoutDirectionManager) {
        _layoutDirectionManager = [[YHImageBrowserLayoutDirectionManager alloc] init];
    }
    return _layoutDirectionManager;
}


- (YHImageBrowserView *)browserView{
    if (!_browserView) {
        _browserView = [[YHImageBrowserView alloc] initWithFrame:CGRectZero];
        _browserView.yh_dataSource = self;
        _browserView.yh_delegate = self;
    }
    return _browserView;
}

@end
