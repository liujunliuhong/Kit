//
//  YHDragCardContainer.m
//  FrameDating
//
//  Created by apple on 2019/5/22.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHDragCardContainer.h"
#import <objc/message.h>

#import "YHMacro.h"
#import "UIView+YHFrame.h"

static char pan_gesture;

static const CGFloat kBoundaryRatio   = 0.8f;
static const CGFloat kSecondCardScale = 0.95f;
static const CGFloat kTherdCardScale  = 0.9f;

static const CGFloat kCardEdage        = 25.0f;
static const CGFloat kContainerEdage   = 0.0;
static const CGFloat kNavigationHeight = 64.0f;

static const CGFloat kVisibleCount     = 4;


static const CGFloat kMinScale         = 0.9;

@interface YHDragCardContainer() {
    CGFloat _adjoinScale;                                                          // 相邻两个card之间的scale差值
    NSMutableArray<NSValue *> *_transforms;
    NSMutableArray<NSValue *> *_frames;
}

@property (nonatomic, assign) CGRect initialFirstCardFrame;                        // 初始化时，顶部第一个卡片的位置
@property (nonatomic, assign) CGRect initialLastCardFrame;                         // 初始化时，底部最后一个卡片的位置
@property (nonatomic, assign) CGPoint initialFirstCardCenter;                      // 初始化时，顶部第一个卡片的中心位置
@property (nonatomic, assign) CGAffineTransform initialLastCardTransform;          // 初始化时，底部最后一个卡片的transform
@property (nonatomic, assign) int loadedIndex;                                     // 当前已经加载了几个卡片
@property (nonatomic, assign) BOOL isMoving;                                       // 是否正在手势拖动中
@property (nonatomic, strong) NSMutableArray<UIView *> *currentCards;              // 当前可见的卡片数量

@property (nonatomic, strong) YHDragCardConfig *config;                            // 配置

@end

@implementation YHDragCardContainer

- (instancetype)initWithFrame:(CGRect)frame config:(YHDragCardConfig *)config
{
    self = [super initWithFrame:frame];
    if (self) {
        self.config = config;
        
        self.backgroundColor = [UIColor orangeColor];
        
        self.initialFirstCardFrame = CGRectZero;
        self.initialLastCardFrame = CGRectZero;
        self.initialFirstCardCenter = CGPointZero;
        self.initialLastCardTransform = CGAffineTransformIdentity;
        self.loadedIndex = 0;
        self.isMoving = NO;
        self.currentCards = [NSMutableArray array];
    }
    return self;
}


- (void)reloadData{
    [self installInitialCards];
    
    [self originalLayout];
    
    _adjoinScale = (1.0 - kMinScale) / (self.currentCards.count - 1);
}

- (void)installInitialCards{
    NSInteger count = [self.dataSource numberOfCardWithCardContainer:self];
    
    NSInteger visibleCount = count <= self.config.visibleCount ? count : self.config.visibleCount;
    
    if (self.loadedIndex >= count) {
        return;
    }
    
    for (int i = 0; i < visibleCount; i ++) {
        UIView *cardView = [[UIView alloc] init];
        cardView.backgroundColor = YH_RandomColor;
        cardView.frame = [self defaultCardViewFrame];
        [self addSubview:cardView];
        [self sendSubviewToBack:cardView];
        [self.currentCards addObject:cardView];
        if (i == 0) {
            self.initialFirstCardFrame = cardView.frame;
            self.initialFirstCardCenter = cardView.center;
        }
        self.loadedIndex ++;
        
        [self addPanGestureForCarView:cardView];
    }
}


- (void)installNext{
    if (self.isMoving) {
        return;
    }
    self.isMoving = YES;
    
    NSInteger count = [self.dataSource numberOfCardWithCardContainer:self];
    if (self.loadedIndex >= count) {
        return;
    }
    
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = YH_RandomColor;
    cardView.layer.anchorPoint = CGPointMake(0.5, 1);
    cardView.frame = self.initialLastCardFrame;
    //cardView.transform = self.initialLastCardTransform;
    
    [self addSubview:cardView];
    [self sendSubviewToBack:cardView];
    
    [self.currentCards addObject:cardView];
    
    self.loadedIndex ++;
    
    [self addPanGestureForCarView:cardView];
    
    _transforms = [NSMutableArray array];
    _frames = [NSMutableArray array];
    [self.currentCards enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGAffineTransform transform = obj.transform;
        NSValue *value = [NSValue value:&transform withObjCType:@encode(CGAffineTransform)];
        [_transforms addObject:value];
        [_frames addObject:[NSValue valueWithCGPoint:obj.frame.origin]];
    }];
}




- (void)addPanGestureForCarView:(UIView *)cardView{
    UIPanGestureRecognizer *pan = objc_getAssociatedObject(cardView, &cardView);
    if (!pan || ![pan isKindOfClass:[UIPanGestureRecognizer class]]) {
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [cardView addGestureRecognizer:pan];
        objc_setAssociatedObject(cardView, &cardView, pan, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}



- (void)removePanGestureForCardView:(UIView *)cardView{
    UIPanGestureRecognizer *pan = objc_getAssociatedObject(cardView, &cardView);
    if (pan && [pan isKindOfClass:[UIPanGestureRecognizer class]]) {
        [cardView removeGestureRecognizer:pan];
        objc_setAssociatedObject(cardView, &cardView, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}


- (CGRect)defaultCardViewFrame{
    CGFloat s_width  = CGRectGetWidth(self.frame);
    CGFloat s_height = CGRectGetHeight(self.frame);
    CGFloat c_height = s_height - kContainerEdage * 2 - kCardEdage * 2;
    return CGRectMake(kContainerEdage,
                      kContainerEdage,
                      s_width  - kContainerEdage * 2,
                      c_height);
}


- (void)panGestureAction:(UIPanGestureRecognizer *)gesture{
    CGPoint point = [gesture translationInView:self];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        UIView *cardView = gesture.view;
        CGPoint movedPoint = CGPointMake(gesture.view.center.x + point.x, gesture.view.center.y + point.y);
        cardView.center = movedPoint;
        cardView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, (gesture.view.center.x - self.initialFirstCardCenter.x) / self.initialFirstCardCenter.x * (M_PI_4 / 12));
        [gesture setTranslation:CGPointZero inView:self];
        
        
        CGFloat widthRatio = 0.0;
        if (self.initialFirstCardCenter.x >= 0.01) {
            widthRatio = (gesture.view.center.x - self.initialFirstCardCenter.x) / self.initialFirstCardCenter.x;
        }
        
        widthRatio = widthRatio <= 0 ? 0.0 : widthRatio;
        
        CGFloat heightRatio = 0.0;
        if (self.initialFirstCardCenter.y <= 0.01) {
            heightRatio = (gesture.view.center.y - self.initialFirstCardCenter.y) / self.initialFirstCardCenter.y;
        }
        
        // 添加下一个Card
        [self installNext];
        
        // 改变所有Card的位置
        [self panForChangeVisableCardsWithRatio:widthRatio];
        
        
        if (widthRatio > 0.0) {
            // 右滑
        } else if (widthRatio < 0.0) {
            // 左滑
        } else {
            // 默认
        }
        
        if (heightRatio > 0.0) {
            // 上滑
        } else if (widthRatio < 0.0) {
            // 下滑
        } else {
            // 默认
        }
        
        //
        
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed) {
        CGFloat widthRatio = (gesture.view.center.x - self.initialFirstCardCenter.x) / self.initialFirstCardCenter.x;
        CGFloat moveWidth  = (gesture.view.center.x  - self.initialFirstCardCenter.x);
        CGFloat moveHeight = ABS(gesture.view.center.y - self.initialFirstCardCenter.y);
        
        moveHeight = moveHeight <= 0.01 ? 0.0 : moveHeight;
        
        CGFloat scale = moveWidth / moveHeight;
        
        BOOL isDisappear = widthRatio >= kBoundaryRatio;
        
        if (isDisappear) {
            // 消失
            [self panForRemoveCurrentCardView:gesture.view withScale:scale withDirection:0];
        } else {
            // 复原
            [self panForResetVisableCards];
        }
    }
}

- (void)panForChangeVisableCardsWithRatio:(CGFloat)ratio{
    if (ratio >= 1) {
        ratio = 1;
    }
//    CGFloat scale = fabs(ratio) >= kBoundaryRatio ? kBoundaryRatio : fabs(ratio);
//    CGFloat sPoor = _adjoinScale; // 相邻两个CardScale差值
//
//    CGFloat tPoor = sPoor / (kBoundaryRatio / scale); // transform x值
//    CGFloat yPoor = kCardEdage / (kBoundaryRatio / scale); // frame y差值
    
    
    CGFloat offset = (self.yh_height - self.initialFirstCardFrame.size.height) / (self.currentCards.count-1);
    
    
    NSLog(@"%f", ratio);
    
    for (int i = 1; i < self.currentCards.count - 1; i++) {
        UIView *cardView = [self.currentCards objectAtIndex:i];
        
        CGAffineTransform tmpTransform;
        CGAffineTransform tmpTransform1;
        [_transforms[i] getValue:&tmpTransform];
        [_transforms[i+1] getValue:&tmpTransform1];
        
        
        
        CGPoint point = [_frames[i] CGPointValue];
        CGPoint point1 = [_frames[i+1] CGPointValue];
        
//        NSLog(@"%f       %f",tmpTransform.a, (tmpTransform1.a - tmpTransform.a));
        
//        CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, tmpTransform.a + (tmpTransform1.a - tmpTransform.a) * ratio, tmpTransform.d + (tmpTransform1.d - tmpTransform.d) * ratio);
//        CGAffineTransform translate = CGAffineTransformTranslate(scale, 0, tmpTransform.ty + (tmpTransform1.ty - tmpTransform.ty) * ratio);
//        cardView.transform = translate;
//
        
        
        cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, tmpTransform.a + (tmpTransform.a - tmpTransform1.a) * ratio, tmpTransform.d + (tmpTransform.d - tmpTransform1.d) * ratio);
        
        CGRect ff = cardView.frame;
        ff.origin.y = point.y + (point.y - point1.y) * ratio;
        cardView.frame = ff;
    }
}

- (void)panForRemoveCurrentCardView:(UIView *)cardView withScale:(CGFloat)scale withDirection:(YHDragCardDirection)direction{
    NSInteger flag = direction == YHDragCardDirection_Left ? -1 : 2;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        cardView.center = CGPointMake(YH_ScreenWidth * flag, YH_ScreenWidth * flag / scale + self.initialFirstCardCenter.y);
    } completion:^(BOOL finished) {
        self.isMoving = NO;
        [self.currentCards removeObject:cardView];
        [cardView removeFromSuperview];
        [self originalLayout];
    }];
    
}

- (void)panForResetVisableCards{
    UIView *lastView = self.currentCards.lastObject;
    [lastView removeFromSuperview];
    [self.currentCards removeLastObject];
    self.loadedIndex --;
    self.isMoving = NO;
    [self originalLayout];
}





- (void)originalLayout{
    if (self.currentCards.count == 1) {
        return;
    }
    
    CGFloat offset = (self.yh_height - self.initialFirstCardFrame.size.height) / (self.currentCards.count - 1);
    
    CGFloat ss = (1 - kMinScale) / (self.currentCards.count - 1);
    
    for (int i = 0; i < self.currentCards.count; i++) {
        
        UIView *cardView = [self.currentCards objectAtIndex:i];
        cardView.layer.anchorPoint = CGPointMake(0.5, 1);
        cardView.transform = CGAffineTransformIdentity;
        CGRect frame = self.initialFirstCardFrame;
        
        frame.origin.y += offset * i;
        
        cardView.frame = frame;
        
        cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1 - ss * i, 1 - ss * i);
        
        if (i == self.currentCards.count - 1) {
            self.initialLastCardTransform = cardView.transform;
            self.initialLastCardFrame = cardView.frame;
        }
    }
}


@end
