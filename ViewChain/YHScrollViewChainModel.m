//
//  YHScrollViewChainModel.m
//  chanDemo
//
//  Created by apple on 2018/11/13.
//  Copyright © 2018 银河. All rights reserved.
//

#import "YHScrollViewChainModel.h"

#define YH_SCROLLVIEW  ((UIScrollView *)weakSelf.view)

@implementation YHScrollViewChainModel

- (YHScrollViewChainModel * _Nonnull (^)(id<UIScrollViewDelegate> _Nonnull))delegate{
    __weak typeof(self) weakSelf = self;
    return ^YHScrollViewChainModel * (id<UIScrollViewDelegate> delegate) {
        YH_SCROLLVIEW.delegate = delegate;
        return weakSelf;
    };
}
- (YHScrollViewChainModel * _Nonnull (^)(CGSize))contentSize{
    __weak typeof(self) weakSelf = self;
    return ^YHScrollViewChainModel * (CGSize contentSize) {
        YH_SCROLLVIEW.contentSize = contentSize;
        return weakSelf;
    };
}
- (YHScrollViewChainModel * _Nonnull (^)(CGPoint))contentOffset{
    __weak typeof(self) weakSelf = self;
    return ^YHScrollViewChainModel * (CGPoint contentOffset) {
        YH_SCROLLVIEW.contentOffset = contentOffset;
        return weakSelf;
    };
}
- (YHScrollViewChainModel * _Nonnull (^)(UIEdgeInsets))contentInset{
    __weak typeof(self) weakSelf = self;
    return ^YHScrollViewChainModel * (UIEdgeInsets contentInset) {
        YH_SCROLLVIEW.contentInset = contentInset;
        return weakSelf;
    };
}
- (YHScrollViewChainModel * _Nonnull (^)(BOOL))bounces{
    __weak typeof(self) weakSelf = self;
    return ^YHScrollViewChainModel * (BOOL bounces) {
        YH_SCROLLVIEW.bounces = bounces;
        return weakSelf;
    };
}
- (YHScrollViewChainModel * _Nonnull (^)(BOOL))alwaysBounceVertical{
    __weak typeof(self) weakSelf = self;
    return ^YHScrollViewChainModel * (BOOL alwaysBounceVertical) {
        YH_SCROLLVIEW.alwaysBounceVertical = alwaysBounceVertical;
        return weakSelf;
    };
}
- (YHScrollViewChainModel * _Nonnull (^)(BOOL))alwaysBounceHorizontal{
    __weak typeof(self) weakSelf = self;
    return ^YHScrollViewChainModel * (BOOL alwaysBounceHorizontal) {
        YH_SCROLLVIEW.alwaysBounceHorizontal = alwaysBounceHorizontal;
        return weakSelf;
    };
}
- (YHScrollViewChainModel * _Nonnull (^)(BOOL))pagingEnabled{
    __weak typeof(self) weakSelf = self;
    return ^YHScrollViewChainModel * (BOOL pagingEnabled) {
        YH_SCROLLVIEW.pagingEnabled = pagingEnabled;
        return weakSelf;
    };
}
- (YHScrollViewChainModel * _Nonnull (^)(BOOL))scrollEnabled{
    __weak typeof(self) weakSelf = self;
    return ^YHScrollViewChainModel * (BOOL scrollEnabled) {
        YH_SCROLLVIEW.scrollEnabled = scrollEnabled;
        return weakSelf;
    };
}
- (YHScrollViewChainModel * _Nonnull (^)(BOOL))showsHorizontalScrollIndicator{
    __weak typeof(self) weakSelf = self;
    return ^YHScrollViewChainModel * (BOOL showsHorizontalScrollIndicator) {
        YH_SCROLLVIEW.showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
        return weakSelf;
    };
}
- (YHScrollViewChainModel * _Nonnull (^)(BOOL))showsVerticalScrollIndicator{
    __weak typeof(self) weakSelf = self;
    return ^YHScrollViewChainModel * (BOOL showsVerticalScrollIndicator) {
        YH_SCROLLVIEW.showsVerticalScrollIndicator = showsVerticalScrollIndicator;
        return weakSelf;
    };
}





@end




@implementation UIScrollView (YH_Chain)
- (YHScrollViewChainModel *)yh_scrollChain{
    return [[YHScrollViewChainModel alloc] initWithView:self];
}
+ (YHScrollViewChainModel *)yh_creat{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    return [[YHScrollViewChainModel alloc] initWithView:scrollView];
}
@end
