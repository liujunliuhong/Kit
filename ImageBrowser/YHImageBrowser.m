//
//  YHImageBrowser.m
//  HiFanSmooth
//
//  Created by apple on 2019/5/16.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHImageBrowser.h"
#import "YHMacro.h"
#import "YHImageBrowserDefine.h"
#import "YHImageBrowserCellData+Private.h"
#import "YHImageBrowserView.h"
#import "YHImageBrowserLayoutDirectionManager.h"
#import "YHImageBrowserSheetView.h"
#import "YHImageBrowserToolBar.h"

@interface YHImageBrowser()
<YHImageBrowserViewDataSource,
YHImageBrowserViewDelegate,
YHImageBrowserSheetViewDataSource,
YHImageBrowserSheetViewDelegate> {
    NSArray<NSString *> *_sheetDatasource;
}
@property (nonatomic, strong) YHImageBrowserView *browserView;
@property (nonatomic, strong) YHImageBrowserSheetView *defaultSheetView;
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) YHImageBrowserLayoutDirectionManager *layoutDirectionManager;
@end

@implementation YHImageBrowser

- (void)dealloc
{
    self.window.windowLevel = UIWindowLevelNormal;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        if (@available(iOS 11.0, *)) {
            self.browserView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        // 初始化数据
        _sheetDatasource = @[@"保存"];
        _currentIndex = 0;
        
        // 添加长按手势
        [self addGesture];
        
        // 监听屏幕旋转
        [self.layoutDirectionManager startObserve];
        
        // 屏幕旋转回调
        __weak typeof(self) weakSelf = self;
        self.layoutDirectionManager.layoutDirectionChangedBlock = ^(YHImageBrowserLayoutDirection direction) {
            [weakSelf updateLayoutOfSubViewsWithLayoutDirection:direction];
        };
    }
    return self;
}


/**
 * 根据屏幕旋转方向，更新约束
 */
- (void)updateLayoutOfSubViewsWithLayoutDirection:(YHImageBrowserLayoutDirection)direction{
    CGSize containerSize = CGSizeMake(YH_ScreenWidth, YH_ScreenHeight);
    self.frame = CGRectMake(0, 0, containerSize.width, containerSize.height);
    [self.browserView updateLayoutWithDirection:direction containerFrame:self.frame];
    
    //
    CGFloat toolHeight = 50.0;
    if (direction == YHImageBrowserLayoutDirection_Vertical) {
        if (YH_IS_IPHONE_X) {
            toolHeight = 44.0 + 50.0;
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(heightForToolBarWithImageBrowser:)]) {
        toolHeight = [self.delegate heightForToolBarWithImageBrowser:self];
    }
    self.toolBar.frame = CGRectMake(0, 0, self.frame.size.width, toolHeight);
    
    //
    if (self.bottomView) {
        CGFloat bottomViewHeight = 0.0;
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageBrowser:heightForBottomView:)]) {
            bottomViewHeight = [self.delegate heightForToolBarWithImageBrowser:self];
        }
        self.toolBar.frame = CGRectMake(0, self.frame.size.height - bottomViewHeight, self.frame.size.width, bottomViewHeight);
    }
}

/**
 * 添加手势
 */
- (void)addGesture {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLongPress:)];
    [self addGestureRecognizer:longPress];
}

/**
 * dismiss
 */
- (void)dismissWithInterval:(NSTimeInterval)interval{
    self.window.windowLevel = UIWindowLevelNormal;
    [UIView animateWithDuration:interval animations:^{
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.2];
    } completion:^(BOOL finished) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageBrowserDidDismiss:)]) {
            [self.delegate imageBrowserDidDismiss:self];
        }
        [self removeFromSuperview];
    }];
}

#pragma mark ------------------ Public Methods ------------------
- (void)show{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    self.window.windowLevel = UIWindowLevelAlert; // 隐藏状态栏(不用关心当前状态栏样式)
    
    [self addSubview:self.browserView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewForToolBarWithImageBrowser:)]) {
        self.toolBar = [self.delegate viewForToolBarWithImageBrowser:self];
    } else {
        self.toolBar = [[YHImageBrowserToolBar alloc] init];
    }
    [self addSubview:self.toolBar];
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomViewForImageBrowser:)]) {
        self.bottomView = [self.delegate bottomViewForImageBrowser:self];
    }
    
    
    [self updateLayoutOfSubViewsWithLayoutDirection:[YHImageBrowserLayoutDirectionManager getCurrntLayoutDirection]];
    
    
    
    [self.browserView scrollToPageIndex:self.currentIndex];
}

- (void)dismiss{
    [self dismissWithInterval:0.1];
}

#pragma mark ------------------ Gesture Action ------------------
- (void)respondsToLongPress:(UILongPressGestureRecognizer *)longPressGesture{
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageBrowser:longGesture:)]) {
            [self.delegate imageBrowser:self longGesture:longPressGesture];
            return;
        }
        if ([self.currentData isKindOfClass:[YHImageBrowserCellData class]]) {
            YHImageBrowserCellData *imageCellData = (YHImageBrowserCellData *)self.currentData;
            // 如果正在loading，return
            if (imageCellData.isLoading) {
                return;
            }
            YHImageBrowserSheetView *sheetView = [[YHImageBrowserSheetView alloc] init];
            sheetView.delegate = self;
            sheetView.dataSource = self;
            [sheetView show];
            self.defaultSheetView = sheetView;
        }
    }
}

#pragma mark ------------------ YHImageBrowserViewDataSource ------------------
- (NSUInteger)yh_numberOfCellForImageBrowserView:(YHImageBrowserView *)imageBrowserView{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfCellForImageBrowser:)]) {
        return [self.dataSource numberOfCellForImageBrowser:self];
    } else {
        return self.dataSourceArray.count;
    }
}

- (id<YHImageBrowserCellDataProtocol>)yh_imageBrowserView:(YHImageBrowserView *)imageBrowserView dataForCellAtIndex:(NSUInteger)index{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(imageBrowser:dataForCellAtIndex:)]) {
        return [self.dataSource imageBrowser:self dataForCellAtIndex:index];
    } else {
        return self.dataSourceArray[index];
    }
}

#pragma mark ------------------ YHImageBrowserViewDelegate ------------------
- (void)yh_imageBrowserView:(YHImageBrowserView *)browserView pageIndexChanged:(NSUInteger)index{
    //NSLog(@"当前索引:%d", (int)index);
    _currentIndex = (int)index;
    
    if ([self.toolBar isKindOfClass:[YHImageBrowserToolBar class]]) {
        YHImageBrowserToolBar *toolBar = (YHImageBrowserToolBar *)self.toolBar;
        int sumCount = 0;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfCellForImageBrowser:)]) {
            sumCount = (int)[self.dataSource numberOfCellForImageBrowser:self];
        } else {
            sumCount = (int)self.dataSourceArray.count;
        }
        toolBar.indexLabel.text = [NSString stringWithFormat:@"%d/%d", (int)(index + 1), sumCount];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(imageBrowser:pageIndexChanged:)]) {
        [self.delegate imageBrowser:self pageIndexChanged:index];
    }
}

- (void)yh_willStartPanDownWithImageBrowserView:(YHImageBrowserView *)browserView{
    self.window.windowLevel = UIWindowLevelNormal;
    self.toolBar.hidden = YES;
    if (self.defaultSheetView) {
        [self.defaultSheetView hide];
    }
}


- (void)yh_imageBrowserView:(YHImageBrowserView *)browserView didChangeAlpha:(CGFloat)alpha{
    self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:alpha];
}

- (void)yh_imageBrowserView:(YHImageBrowserView *)browserView resetWithInterval:(NSTimeInterval)interval{
    self.toolBar.hidden = NO;
    self.window.windowLevel = UIWindowLevelAlert;
    [UIView animateWithDuration:interval animations:^{
        self.backgroundColor = [self.backgroundColor colorWithAlphaComponent:1];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)yh_imageBrowserView:(YHImageBrowserView *)browserView dismissWithInterval:(NSTimeInterval)interval{
    [self dismissWithInterval:interval];
}

#pragma mark ------------------ YHImageBrowserSheetViewDataSource ------------------
- (NSArray<NSString *> *)titlesForSheetView:(YHImageBrowserSheetView *)sheetView{
    return _sheetDatasource;
}

#pragma mark ------------------ YHImageBrowserSheetViewDelegate ------------------
- (BOOL)shouldHideCancelForSheetView:(YHImageBrowserSheetView *)sheetView{
    return NO;
}

- (NSString *)titleForCancelWithSheetView:(YHImageBrowserSheetView *)sheetView{
    return @"取消";
}

- (void)sheetView:(YHImageBrowserSheetView *)sheetView didClickIndex:(int)clickIndex{
    if (clickIndex == 0) {
        // 保存照片或者GIF  视频暂时不支持保存
        if ([self.currentData isKindOfClass:[YHImageBrowserCellData class]]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(imageBrowserSaveAction:)]) {
                [self.delegate imageBrowserSaveAction:self];
            } else {
                YHImageBrowserCellData *data = (YHImageBrowserCellData *)self.currentData;
                if (data && [data respondsToSelector:@selector(yh_saveToPhotoAlblum:)]) {
                    [data yh_saveToPhotoAlblum:self.saveAlbumName];
                }
            }
        } else {
            // 如果要对视频操作，在此处完成......
        }
    }
}

- (void)sheetViewDicClickCancel:(YHImageBrowserSheetView *)sheetView{
    //
}

- (void)sheetViewDidHide:(YHImageBrowserSheetView *)sheetView{
    //
    self.defaultSheetView = nil;
}

#pragma mark ------------------ Setter ------------------
- (void)setCurrentIndex:(int)currentIndex{
    int count = (int)[self.browserView.yh_dataSource yh_numberOfCellForImageBrowserView:self.browserView];
    if (currentIndex <= 0) {
        currentIndex = 0;
    } else if (currentIndex >= count) {
        currentIndex = count - 1;
    }
    _currentIndex = currentIndex;
    if (self.browserView.superview) {
        [self.browserView scrollToPageIndex:_currentIndex];
    }
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


- (id<YHImageBrowserCellDataProtocol>)currentData{
    return self.browserView.currentData;
}

@end
