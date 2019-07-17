//
//  YHImageBrowserCell.m
//  HiFanSmooth
//
//  Created by apple on 2019/5/14.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHImageBrowserCell.h"

#if __has_include(<FLAnimatedImage/FLAnimatedImage.h>)
    #import <FLAnimatedImage/FLAnimatedImage.h>
#elif __has_include("FLAnimatedImage.h")
    #import "FLAnimatedImage.h"
#endif

#import "YHImageBrowserCellProtocol.h"
#import "YHImageBrowserCellData.h"
#import "YHImageBrowserCellData+Private.h"
#import "UIView+YHImageBrowserProgressView.h"

@interface YHImageBrowserCell() <YHImageBrowserCellProtocol, UIScrollViewDelegate, UIGestureRecognizerDelegate> {
    YHImageBrowserLayoutDirection _layoutDirection;
    CGRect _containerFrame;
    CGPoint _gestureInteractionStartPoint;
    
    BOOL _allowPanDown;
}

@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) FLAnimatedImageView *mainImageView;

@property (nonatomic, strong) YHImageBrowserCellData *cellData;

@end


@implementation YHImageBrowserCell

@synthesize yh_browserStartPanDownBlock = _yh_browserStartPanDownBlock;
@synthesize yh_browserEndPanDownBlock = _yh_browserEndPanDownBlock;
@synthesize yh_browserChangePanDownBlock = _yh_browserChangePanDownBlock;
@synthesize yh_browserResetPanDownBlock = _yh_browserResetPanDownBlock;
@synthesize yh_browserDismissPanDownBlock = _yh_browserDismissPanDownBlock;

- (void)dealloc
{
    [self removeObserverForDataState];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _allowPanDown = NO;
        
        [self.contentView addSubview:self.mainScrollView];
        [self.mainScrollView addSubview:self.mainImageView];
        
        [self addGesture];
    }
    return self;
}

/**
 * 重写系统的prepareForReuse方法
 */
- (void)prepareForReuse{
    // 复原
    self.mainScrollView.zoomScale = 1;
    self.mainImageView.animatedImage = nil;
    self.mainImageView.image = nil;
    //
    _allowPanDown = NO;
    // 移除观察者
    [self removeObserverForDataState];
    //
    [self yh_hideProgressView];
    
    [super prepareForReuse];
}

/**
 * 为cell添加手势
 */
- (void)addGesture {
    UITapGestureRecognizer *tapSingle = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapSingle:)];
    tapSingle.numberOfTapsRequired = 1;
    UITapGestureRecognizer *tapDouble = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapDouble:)];
    tapDouble.numberOfTapsRequired = 2;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToPan:)];
    pan.maximumNumberOfTouches = 1;
    pan.delegate = self;
    
    [tapSingle requireGestureRecognizerToFail:tapDouble];
    [tapSingle requireGestureRecognizerToFail:pan];
    [tapDouble requireGestureRecognizerToFail:pan];
    
    [self.mainScrollView addGestureRecognizer:tapSingle];
    [self.mainScrollView addGestureRecognizer:tapDouble];
    [self.mainScrollView addGestureRecognizer:pan];
}



/**
 * 更新scrolView约束
 */
- (void)updateContentScrollViewLayout{
    self.mainScrollView.frame = _containerFrame;
}


/**
 * 更新mainImageView的约束
 */
- (void)updateContentViewLayout{
    self.mainScrollView.zoomScale = 1;
    self.mainScrollView.minimumZoomScale = 1;
    self.mainScrollView.maximumZoomScale = 1;
    
    CGSize imageSize;
    if (self.cellData.image) {
        if (!self.cellData.image.image && !self.cellData.image.animatedImage) {
            //return;
            CGFloat h = MIN(_containerFrame.size.width, _containerFrame.size.height);
            imageSize = CGSizeMake(h, h);
        }
        if (self.cellData.image.image) {
            imageSize = self.cellData.image.image.size;
        }
    } else if (self.cellData.thumbImage) {
        imageSize = self.cellData.thumbImage.size;
    } else {
        return;
    }
    
    CGFloat width = 0;     // mainImageView的宽
    CGFloat height = 0;    // mainImageView的高
    CGFloat x = _containerFrame.origin.x;         // mainImageView的origin.x
    CGFloat y = _containerFrame.origin.y;         // mainImageView的origin.y
    CGPoint offset = CGPointZero; // scrollView偏移量
    
    if (_layoutDirection == YHImageBrowserLayoutDirection_Vertical) {
        width = _containerFrame.size.width; // 宽度抵满屏幕
        height = width * (imageSize.height / imageSize.width); // 得到高度
        if ((imageSize.width / imageSize.height) / (_containerFrame.size.width / _containerFrame.size.height) >= 4.0) {
            // 图片宽的不像话了
            height = _containerFrame.size.width;
            width = height * (imageSize.width / imageSize.height);
        }
        
        y = (_containerFrame.size.height - height) / 2.0 >= 0 ? (_containerFrame.size.height - height) / 2.0 : 0.0;
        offset = CGPointMake((width - _containerFrame.size.width) / 2.0 >= 0 ? (width - _containerFrame.size.width) / 2.0 : 0.0, (height - _containerFrame.size.height) / 2.0 >= 0 ? (height - _containerFrame.size.height) / 2.0 : 0.0);
    } else {
        height = _containerFrame.size.height; // 高度抵满屏幕
        width = height * (imageSize.width / imageSize.height); // 得到宽度
        if ((imageSize.height / imageSize.width) / (_containerFrame.size.height / _containerFrame.size.width) >= 4.0) {
            // 图片高的不像话了
            width = _containerFrame.size.height;
            height = width * (imageSize.height / imageSize.width);
        }
        x = (_containerFrame.size.width - width) / 2.0 >= 0 ? (_containerFrame.size.width - width) / 2.0 : 0.0;
        offset = CGPointMake((width - _containerFrame.size.width) / 2.0 >= 0 ? (width - _containerFrame.size.width) / 2.0 : 0.0, (height - _containerFrame.size.height) / 2.0 >= 0 ? (height - _containerFrame.size.height) / 2.0 : 0.0);
    }
    
    
    self.mainImageView.frame = CGRectMake(x, y, width, height);
    [self.mainScrollView setContentOffset:offset animated:NO];
    
    self.mainScrollView.zoomScale = 1;
    self.mainScrollView.contentSize = CGSizeMake(width, height);
    self.mainScrollView.minimumZoomScale = 1;
    self.mainScrollView.maximumZoomScale = 2.5;
}

- (void)resetGestureInteractionWithDuration:(NSTimeInterval)duration{
    if (self.yh_browserResetPanDownBlock) {
        self.yh_browserResetPanDownBlock(duration);
    }
    void (^animations)(void) = ^{
        self.mainScrollView.center = CGPointMake(self->_containerFrame.size.width / 2, self->_containerFrame.size.height / 2);
        self.mainScrollView.transform = CGAffineTransformIdentity;
    };
    void (^completion)(BOOL finished) = ^(BOOL finished){
        self->_gestureInteractionStartPoint = CGPointZero;
        self->_allowPanDown = NO;
    };
    if (duration <= 0) {
        animations();
        completion(NO);
    } else {
        [UIView animateWithDuration:duration animations:animations completion:completion];
    }
}

- (void)dismissGestureInteractionWithDuration:(NSTimeInterval)duration{
    if (self.yh_browserDismissPanDownBlock) {
        self.yh_browserDismissPanDownBlock(duration);
    }
    void (^animations)(void) = ^{
        self.mainScrollView.center = CGPointMake(self->_containerFrame.size.width / 2, self->_containerFrame.size.height / 2);
        self.mainScrollView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.mainScrollView.alpha = 0.2;
    };
    void (^completion)(BOOL finished) = ^(BOOL finished){
        self->_gestureInteractionStartPoint = CGPointZero;
        self->_allowPanDown = NO;
    };
    if (duration <= 0) {
        animations();
        completion(NO);
    } else {
        [UIView animateWithDuration:duration animations:animations completion:completion];
    }
}

- (void)cellDataStateChanged{
    YHImageBrowserCellData *data = self.cellData;
    YHImageBrowserCellDataState dataState = data.dataState;
    
    switch (dataState) {
        case YHImageBrowserCellDataState_Invalid:
        {
            // 图片非法
        }
            break;
        case YHImageBrowserCellDataState_ImageReady:
        {
            // YHImage准备好    😆😆😆😆😆😆😆😆😆😆😆😆😆😆
            if (data.image.animatedImage) {
                self.mainImageView.image = data.image.image;
                self.mainImageView.animatedImage = data.image.animatedImage;
            } else if (data.image.image) {
                self.mainImageView.image = data.image.image;
            }
            [self updateContentViewLayout];
        }
            break;
        case YHImageBrowserCellDataState_ThumbImageReady:
        {
            // 本地缩略图准备好，此时可以显示缩略图    😆😆😆😆😆😆😆😆😆😆😆😆😆😆
            self.mainImageView.image = data.thumbImage;
            [self updateContentViewLayout];
        }
            break;
        case YHImageBrowserCellDataState_CompressImageReady:
        {
            // 压缩图片准备好了，此时可以显示压缩图  😆😆😆😆😆😆😆😆😆😆😆😆😆😆
            self.mainImageView.image = data.compressImage;
            [self updateContentViewLayout];
        }
            break;
        case YHImageBrowserCellDataState_IsCompressingImage:
        {
            // 正在压缩图片
            [self yh_showLoading];
        }
            break;
        case YHImageBrowserCellDataState_CompressImageComplete:
        {
            // 压缩图片完成
            [self yh_hideProgressView];
        }
            break;
        case YHImageBrowserCellDataState_IsDecoding:
        {
            // 正在Decode本地图片
            [self yh_showLoading];
        }
            break;
        case YHImageBrowserCellDataState_DecodeComplete:
        {
            // 本地图片Decod完成
            [self yh_hideProgressView];
        }
            break;
        case YHImageBrowserCellDataState_IsQueryingCache:
        {
            // 正在查询缓存图片
            [self yh_showLoading];
        }
            break;
        case YHImageBrowserCellDataState_QueryCacheComplete:
        {
            // 缓存图片查询完成
            [self yh_hideProgressView];
        }
            break;
        case YHImageBrowserCellDataState_DownloadReady:
        {
            // 准备下载图片
        }
            break;
        case YHImageBrowserCellDataState_IsDownloading:
        {
            // 图片下载中(此时有下载进度)
            //NSLog(@"😋:下载进度:%.2f", data.downloadProgress);
            CGFloat value = data.downloadProgress;
            if (value <= 0.0) {
                value = 0.0;
            } else if (value >= 1.0) {
                value = 1.0;
            }
            [self yh_showProgressViewWithValue:value];
        }
            break;
        case YHImageBrowserCellDataState_DownloadSuccess:
        {
            // 图片下载成功
            [self yh_hideProgressView];
        }
            break;
        case YHImageBrowserCellDataState_DownloadFailed:
        {
            // 图片下载失败
            [self yh_hideProgressView];
        }
            break;
        default:
            break;
    }
}

#pragma mark ------------------ Gesture ------------------
// 单击
- (void)respondsToTapSingle:(UITapGestureRecognizer *)tap{
    if (self.yh_browserStartPanDownBlock) {
        self.yh_browserStartPanDownBlock();
    }
    [self dismissGestureInteractionWithDuration:0.1];
}

// 双击
- (void)respondsToTapDouble:(UITapGestureRecognizer *)tap{
    UIScrollView *scrollView = self.mainScrollView;
    UIView *zoomView = [self viewForZoomingInScrollView:scrollView];
    CGPoint point = [tap locationInView:zoomView];
    if (!CGRectContainsPoint(zoomView.bounds, point)) return;
    if (scrollView.zoomScale == scrollView.maximumZoomScale) {
        [scrollView setZoomScale:1 animated:YES];
    } else {
        [scrollView zoomToRect:CGRectMake(point.x, point.y, 1, 1) animated:YES];
    }
}

// 拖动
- (void)respondsToPan:(UIPanGestureRecognizer *)pan{
    
    CGPoint point = [pan locationInView:self];
    CGPoint velocity = [pan velocityInView:self.mainScrollView];
    CGPoint translation = [pan translationInView:self.mainScrollView];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        //NSLog(@"  ");
        //NSLog(@"point%@", [NSValue valueWithCGPoint:point]);
        //NSLog(@"velocity:%@", [NSValue valueWithCGPoint:velocity]);
        //NSLog(@"  ");
        if (self.mainScrollView.contentSize.height <= _containerFrame.size.height || self.mainScrollView.contentOffset.y <= 0) {
            // 图片高度比containerFrame的高度小
            if (velocity.y > 0) {
                CGFloat ratio = ABS(velocity.x / velocity.y);
                //NSLog(@"😋%.2f", ratio);
                if (ratio <= 0.3) {
                    _allowPanDown = YES;
                }
            }
        }
        if (_allowPanDown) {
            if (self.yh_browserStartPanDownBlock) {
                self.yh_browserStartPanDownBlock();
            }
            self.mainScrollView.scrollEnabled = NO;
            _gestureInteractionStartPoint =  point;
        }
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        if (!_allowPanDown) {
            return;
        }
        
        self.mainScrollView.center = CGPointMake(self.mainScrollView.center.x + translation.x,self.mainScrollView.center.y + translation.y);
        [pan setTranslation:CGPointZero inView:self.mainScrollView];
        
        CGFloat scale = 1 - ABS(point.y - _gestureInteractionStartPoint.y) / (_containerFrame.size.height * 1.2);
        if (scale > 1) scale = 1;
        if (scale < 0.35) scale = 0.35;
        self.mainScrollView.transform = CGAffineTransformMakeScale(scale, scale);
        CGFloat alpha = 1 - ABS(point.y - _gestureInteractionStartPoint.y) / (_containerFrame.size.height * 1.1);
        if (alpha > 1) alpha = 1;
        if (alpha < 0) alpha = 0;
        if (self.yh_browserChangePanDownBlock) {
            self.yh_browserChangePanDownBlock(alpha);
        }
    } else if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateRecognized || pan.state == UIGestureRecognizerStateFailed) {
        
        if (!_allowPanDown) {
            return;
        }
        if (ABS(velocity.y) >= 500 || ABS(point.y - _gestureInteractionStartPoint.y) >= 50) {
            // dismiss
            [self dismissGestureInteractionWithDuration:0.2];
        } else {
            // reset
            [self resetGestureInteractionWithDuration:0.2];
            self.mainScrollView.scrollEnabled = YES;
            if (self.yh_browserEndPanDownBlock) {
                self.yh_browserEndPanDownBlock();
            }
        }
    }
}

#pragma mark ------------------ KVO ------------------
- (void)addObserverForDataState{
    [self.cellData addObserver:self forKeyPath:@"dataState" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverForDataState {
    [self.cellData removeObserver:self forKeyPath:@"dataState"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"dataState"]) {
        [self cellDataStateChanged];
    }
}

#pragma mark ------------------ YHImageBrowserCellProtocol ------------------
- (void)yh_browserSetInitialCellData:(id<YHImageBrowserCellDataProtocol>)data layoutDirection:(YHImageBrowserLayoutDirection)layoutDirection containerFrame:(CGRect)containerFrame{
    
    NSAssert([data isKindOfClass:[YHImageBrowserCellData class]], @"data必须是YHImageBrowserCellData类型");
    
    _containerFrame = containerFrame;
    _layoutDirection = layoutDirection;
    
    self.cellData = data;
    
    // 设置data的时候，添加观察者
    [self addObserverForDataState];
    
    // 获取数据
    [self.cellData loadData];
    
    // 更新scrolView约束
    [self updateContentScrollViewLayout];
}

- (void)yh_browserLayoutDirectionChanged:(YHImageBrowserLayoutDirection)layoutDirection containerFrmae:(CGRect)containerFrame{
    _containerFrame = containerFrame;
    _layoutDirection = layoutDirection;
    
    [self updateContentScrollViewLayout];
    [self updateContentViewLayout];
}



#pragma mark ------------------ UIScrollViewDelegate ------------------
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat zoomScale = scrollView.zoomScale;
    NSLog(@"😆:%.2f", zoomScale);
    
    CGRect imageViewFrame = self.mainImageView.frame;
    
    CGFloat width = imageViewFrame.size.width;
    CGFloat height = imageViewFrame.size.height;
    
    CGFloat sHeight = scrollView.bounds.size.height;
    CGFloat sWidth = scrollView.bounds.size.width;
    
    if (height > sHeight) {
        imageViewFrame.origin.y = 0;
    } else {
        imageViewFrame.origin.y = (sHeight - height) / 2.0;
    }
    if (width > sWidth) {
        imageViewFrame.origin.x = 0;
    } else {
        imageViewFrame.origin.x = (sWidth - width) / 2.0;
    }
    self.mainImageView.frame = imageViewFrame;
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.mainImageView;
}

#pragma mark ------------------ UIGestureRecognizerDelegate ------------------
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}




#pragma mark ------------------ Getter ------------------
- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.delegate = self;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.maximumZoomScale = 1;
        _mainScrollView.minimumZoomScale = 1;
        _mainScrollView.alwaysBounceVertical = NO;
        _mainScrollView.alwaysBounceHorizontal = NO;
        if (@available(iOS 11.0, *)) {
            _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mainScrollView;
}

- (FLAnimatedImageView *)mainImageView{
    if (!_mainImageView) {
        _mainImageView = [[FLAnimatedImageView alloc] init];
        _mainImageView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
    }
    return _mainImageView;
}

@end

