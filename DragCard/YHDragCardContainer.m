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


static const CGFloat kBoundaryRatio   = 0.8f;

static const CGFloat kCardEdage        = 25.0f;


static const CGFloat kMinScale         = 0.9;

@interface YHDragCardContainer()

@property (nonatomic, assign) CGRect initialFirstCardFrame;                        // 初始化时，顶部第一个卡片的位置
@property (nonatomic, assign) CGRect initialLastCardFrame;                         // 初始化时，底部最后一个卡片的位置
@property (nonatomic, assign) CGPoint initialFirstCardCenter;                      // 初始化时，顶部第一个卡片的中心位置
@property (nonatomic, assign) CGAffineTransform initialLastCardTransform;          // 初始化时，底部最后一个卡片的transform
@property (nonatomic, assign) int loadedIndex;                                     // 当前已经加载了几个卡片
@property (nonatomic, assign) BOOL isMoving;                                       // 是否正在手势拖动中
@property (nonatomic, strong) NSMutableArray<UIView *> *currentCards;              // 当前可见的卡片数量

@property (nonatomic, strong) NSMutableArray<UIView *> *activeCards;

@property (nonatomic, strong) NSMutableArray<NSArray<NSValue *> *> *values;

@property (nonatomic, strong) YHDragCardConfig *config;                            // 配置

@property (nonatomic, assign) YHDragCardDirection direction;

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
        self.activeCards = [NSMutableArray array];
        self.values = [NSMutableArray array];
    }
    return self;
}


- (void)reloadData{
    [self installInitialCards];
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
        cardView.layer.anchorPoint = CGPointMake(0.5, 1);
        cardView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - (self.config.visibleCount-1) * kCardEdage);
        [self addSubview:cardView];
        [self sendSubviewToBack:cardView];
        [self.currentCards addObject:cardView];
        [self.activeCards addObject:cardView];
        self.loadedIndex ++;
        [self addPanGestureForCarView:cardView];
    }
    
    
    if (self.currentCards.count == 1) {
        return;
    }
    
    
    CGFloat unitScale = (1.0 - kMinScale) / (self.currentCards.count - 1);
    
    for (int i = 0; i < self.currentCards.count; i++) {
        UIView *cardView = [self.currentCards objectAtIndex:i];
        cardView.transform = CGAffineTransformIdentity;
        CGRect frame = cardView.frame;
        frame.origin.y += kCardEdage * i;
        cardView.frame = frame;
        cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1 - (unitScale * i), (1 - unitScale * i));
        if (i == 0) {
            self.initialFirstCardFrame = cardView.frame;
            self.initialFirstCardCenter = cardView.center;
        } else if (i == self.currentCards.count - 1) {
            self.initialLastCardTransform = cardView.transform;
            self.initialLastCardFrame = cardView.frame;
        }
        CGAffineTransform tmpTransform = cardView.transform;
        NSValue *value1 = [NSValue value:&tmpTransform withObjCType:@encode(CGAffineTransform)];
        NSValue *value2 = [NSValue valueWithCGRect:cardView.frame];
        [self.values addObject:@[value1, value2]]; // 数组最后一个在界面的最下面
    }
}


- (void)installNext{
    NSInteger count = [self.dataSource numberOfCardWithCardContainer:self];
    if (self.loadedIndex >= count) {
        return;
    }
    
    UIView *cardView = [[UIView alloc] init];
    cardView.backgroundColor = YH_RandomColor;
    cardView.layer.anchorPoint = CGPointMake(0.5, 1);
    cardView.frame = self.initialLastCardFrame;
    //cardView.transform = self.initialLastCardTransform; // 不需要再设置transform了，因为新添加的元素不需要做缩放
    [self addSubview:cardView];
    [self sendSubviewToBack:cardView];
    
    [self.currentCards addObject:cardView];
    [self.activeCards addObject:cardView];
    
    self.loadedIndex ++;
    
    [self addPanGestureForCarView:cardView];
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

- (void)panGestureAction:(UIPanGestureRecognizer *)gesture{
    CGPoint point = [gesture translationInView:self];
    UIView *cardView = gesture.view;
    // x轴位移比例
    CGFloat widthRatio = 0.0;
    if (self.initialFirstCardCenter.x > 0.001) {
        widthRatio = (gesture.view.center.x - self.initialFirstCardCenter.x) / (self.initialFirstCardCenter.x / 2.0);
    }
    // y轴位移比例
    CGFloat heightRatio = 0.0;
    if (self.initialFirstCardCenter.y > 0.001) {
        heightRatio = (gesture.view.center.y - self.initialFirstCardCenter.y) / (self.initialFirstCardCenter.y / 2.0);
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        // 添加下一个Card
        [self installNext];
        self.direction = YHDragCardDirection_Default;
        
        // 每次在滑动开始的时候，重置
        //[self resetCardsLayout];
        
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        if ([self.activeCards containsObject:cardView]) {
            [self.activeCards removeObject:cardView];
        }
        
        CGPoint movedPoint = CGPointMake(gesture.view.center.x + point.x, gesture.view.center.y + point.y);
        cardView.center = movedPoint;
        cardView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, (gesture.view.center.x - self.initialFirstCardCenter.x) / self.initialFirstCardCenter.x * (M_PI_4 / 12));
        [gesture setTranslation:CGPointZero inView:self];
        
        if (widthRatio >= 0.001) {
            // 右滑
            self.direction = YHDragCardDirection_Right;
        } else if (widthRatio <= -0.001) {
            // 左滑
            self.direction = YHDragCardDirection_Left;
        } else {
            // 默认
            self.direction = YHDragCardDirection_Default;
        }
        
        if (heightRatio > 0.001) {
            // 下滑
        } else if (widthRatio < -0.001) {
            // 上滑
        } else {
            // 默认
        }
        CGFloat tmpHeightRatio = ABS(heightRatio);
        CGFloat tmpWidthRatio = ABS(widthRatio);
        
        // 改变所有Card的位置
        [self panForChangeVisableCardsWithRatio:sqrt(pow(tmpWidthRatio, 2) + pow(tmpHeightRatio, 2))];
        
        
    } else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled || gesture.state == UIGestureRecognizerStateFailed) {
        CGFloat moveWidth  = (gesture.view.center.x  - self.initialFirstCardCenter.x);
        CGFloat moveHeight = (gesture.view.center.y - self.initialFirstCardCenter.y);
        
        moveHeight = moveHeight <= 0.01 ? 0.0 : moveHeight;
        
        CGFloat scale = moveWidth / moveHeight;
        
        BOOL isDisappear = ABS(widthRatio) >= kBoundaryRatio;
        
        if (isDisappear) {
            // 消失
            NSLog(@"111");
            [self panForRemoveCurrentCardView:gesture.view withScale:scale withDirection:self.direction];
        } else {
            // 复原
            NSLog(@"222");
            [self panForResetVisableCards];
        }
    }
}

- (void)panForChangeVisableCardsWithRatio:(CGFloat)ratio{
    if (ratio >= 1) {
        ratio = 1;
    }
    
    NSArray<UIView *> *activeCards = [NSArray arrayWithArray:self.activeCards];
    if (self.activeCards.count > self.config.visibleCount) {
        activeCards = [self.activeCards subarrayWithRange:NSMakeRange(0, self.config.visibleCount)];
    }
    
    if (activeCards.count == self.config.visibleCount) {
        for (int i = 1; i < activeCards.count; i++) {
            UIView *cardView = [activeCards objectAtIndex:i];
            CGAffineTransform tmpTransform;
            CGAffineTransform tmpTransform1;
            [self.values[i][0] getValue:&tmpTransform];
            [self.values[i-1][0] getValue:&tmpTransform1];
            
            CGRect rect = [self.values[i][1] CGRectValue];
            CGRect rect1 = [self.values[i-1][1] CGRectValue];
            
            cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, tmpTransform.a + (tmpTransform1.a - tmpTransform.a) * ratio, tmpTransform.d + (tmpTransform1.d - tmpTransform.d) * ratio);
            
            CGRect frame = cardView.frame;
            frame.origin.y = rect.origin.y + (rect1.origin.y - rect.origin.y) * ratio;
            cardView.frame = frame;
        }
    } else {
        for (int i = 1; i < activeCards.count; i++) {
            UIView *cardView = [activeCards objectAtIndex:i];
            CGAffineTransform tmpTransform;
            CGAffineTransform tmpTransform1;
            [self.values[i+(self.config.visibleCount-activeCards.count)][0] getValue:&tmpTransform];
            [self.values[i+(self.config.visibleCount-activeCards.count)-1][0] getValue:&tmpTransform1];
            
            CGRect rect = [self.values[i+(self.config.visibleCount-activeCards.count)][1] CGRectValue];
            CGRect rect1 = [self.values[i+(self.config.visibleCount-activeCards.count)-1][1] CGRectValue];
            
            cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, tmpTransform.a + (tmpTransform1.a - tmpTransform.a) * ratio, tmpTransform.d + (tmpTransform1.d - tmpTransform.d) * ratio);
            
            CGRect frame = cardView.frame;
            frame.origin.y = rect.origin.y + (rect1.origin.y - rect.origin.y) * ratio;
            cardView.frame = frame;
        }
    }
//    for (int i = 1; i < self.config.visibleCount; i++) {
//        UIView *cardView = [self.currentCards objectAtIndex:i >= self.currentCards.count ? self.currentCards.count - 1 : i];
//        NSLog(@"😄%d", i);
//        CGAffineTransform tmpTransform;
//        CGAffineTransform tmpTransform1;
//        [self.values[i][0] getValue:&tmpTransform];
//        [self.values[i-1][0] getValue:&tmpTransform1];
//
//        CGRect rect = [self.values[i][1] CGRectValue];
//        CGRect rect1 = [self.values[i-1][1] CGRectValue];
//
//        cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, tmpTransform.a + (tmpTransform1.a - tmpTransform.a) * ratio, tmpTransform.d + (tmpTransform1.d - tmpTransform.d) * ratio);
//
//        CGRect frame = cardView.frame;
//        frame.origin.y = rect.origin.y + (rect1.origin.y - rect.origin.y) * ratio;
//        cardView.frame = frame;
//    }
}

- (void)panForRemoveCurrentCardView:(UIView *)cardView withScale:(CGFloat)scale withDirection:(YHDragCardDirection)direction{
    NSInteger flag = direction == YHDragCardDirection_Left ? -1 : 2;
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        cardView.center = CGPointMake(YH_ScreenWidth * flag, YH_ScreenWidth * flag / scale + self.initialFirstCardCenter.y);
    } completion:^(BOOL finished) {
        [cardView removeFromSuperview];
    }];
    [self.currentCards removeObject:cardView];
    [self resetCardsLayout];
    
}

- (void)panForResetVisableCards{
    UIView *lastView = self.currentCards.lastObject;
    [lastView removeFromSuperview];
    [self.currentCards removeLastObject];
    self.loadedIndex --;
    [self resetCardsLayout];
}





- (void)resetCardsLayout{
    NSArray<UIView *> *activeCards = [NSArray arrayWithArray:self.activeCards];
    if (self.activeCards.count >= self.config.visibleCount+1) {
        activeCards = [self.activeCards subarrayWithRange:NSMakeRange(0, self.config.visibleCount+1)];
    }
    
    if (activeCards.count == self.config.visibleCount + 1) {
        for (int i = 1; i < activeCards.count; i++) {
            CGAffineTransform tmpTransform;
            [self.values[i-1][0] getValue:&tmpTransform];
            CGRect rect = [self.values[i-1][1] CGRectValue];
            
            UIView *cardView = [activeCards objectAtIndex:i];
            cardView.transform = tmpTransform;
            cardView.frame = rect;
        }
    } else {
        for (int i = 0; i < activeCards.count; i++) {
            
            CGAffineTransform tmpTransform;
            [self.values[i+(self.config.visibleCount-activeCards.count)][0] getValue:&tmpTransform];
            CGRect rect = [self.values[i+(self.config.visibleCount-activeCards.count)][1] CGRectValue];
            
            UIView *cardView = [activeCards objectAtIndex:i];
            cardView.transform = tmpTransform;
            cardView.frame = rect;
        }
    }
    
    
    
//    // 在非常快速滑动的情况下，当前的currentCards的数量可能会比visibleCount多很多个，因此要做个判断
//    for (int i = 0; i < self.currentCards.count; i++) {
//        if (i < self.config.visibleCount) {
//            CGAffineTransform tmpTransform;
//            [self.values[i][0] getValue:&tmpTransform];
//            CGRect rect = [self.values[i][1] CGRectValue];
//
//            UIView *cardView = [self.currentCards objectAtIndex:i];
//            cardView.transform = tmpTransform;
//            cardView.frame = rect;
//        }
//    }
}


@end
