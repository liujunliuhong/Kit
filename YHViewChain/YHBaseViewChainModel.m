//
//  YHBaseViewChainModel.m
//  chanDemo
//
//  Created by 银河 on 2018/11/7.
//  Copyright © 2018 银河. All rights reserved.
//

#import "YHBaseViewChainModel.h"


@interface YHBaseViewChainModel()
@property (nonatomic, strong) __kindof UIView *view;
@end

@implementation YHBaseViewChainModel

- (instancetype)initWithView:(__kindof UIView *)view
{
    self = [super init];
    if (self) {
        self.view = view;
    }
    return self;
}
#pragma mark -
- (id)with{
    return self;
}

#pragma mark - 
- (id  _Nonnull (^)(CGRect))frame{
    __weak typeof(self) weakSelf = self;
    return ^id (CGRect frame) {
        weakSelf.view.frame = frame;
        return weakSelf;
    };
}

- (id  _Nonnull (^)(UIColor * _Nonnull))backgroundColor{
    __weak typeof(self) weakSelf = self;
    return ^id (UIColor *backgroundColor) {
        weakSelf.view.backgroundColor = backgroundColor;
        return weakSelf;
    };
}
- (id  _Nonnull (^)(CGFloat))alpha{
    __weak typeof(self) weakSelf = self;
    return ^id (CGFloat alpha) {
        weakSelf.view.alpha = alpha;
        return weakSelf;
    };
}
- (id  _Nonnull (^)(BOOL))hidden{
    __weak typeof(self) weakSelf = self;
    return ^id (BOOL hidden) {
        weakSelf.view.hidden = hidden;
        return weakSelf;
    };
}
- (id  _Nonnull (^)(BOOL))clipsToBounds{
    __weak typeof(self) weakSelf = self;
    return ^id (BOOL clipsToBounds) {
        weakSelf.view.clipsToBounds = clipsToBounds;
        return weakSelf;
    };
}
- (id  _Nonnull (^)(UIViewContentMode))contentMode{
    __weak typeof(self) weakSelf = self;
    return ^id (UIViewContentMode contentMode) {
        weakSelf.view.contentMode = contentMode;
        return weakSelf;
    };
}
- (id  _Nonnull (^)(UIColor *))tintColor{
    __weak typeof(self) weakSelf = self;
    return ^id (UIColor *tintColor) {
        weakSelf.view.tintColor = tintColor;
        return weakSelf;
    };
}
- (id  _Nonnull (^)(BOOL))userInteractionEnabled{
    __weak typeof(self) weakSelf = self;
    return ^id (BOOL userInteractionEnabled) {
        weakSelf.view.userInteractionEnabled = userInteractionEnabled;
        return weakSelf;
    };
}
#pragma mark - Layer
- (id  _Nonnull (^)(CGFloat))cornerRadius{
    __weak typeof(self) weakSelf = self;
    return ^id (CGFloat cornerRadius) {
        weakSelf.view.layer.cornerRadius = cornerRadius;
        return weakSelf;
    };
}
- (id  _Nonnull (^)(BOOL))maskToBounds{
    __weak typeof(self) weakSelf = self;
    return ^id (BOOL maskToBounds) {
        weakSelf.view.layer.masksToBounds = maskToBounds;
        return weakSelf;
    };
}

- (id  _Nonnull (^)(CGFloat))borderWidth{
    __weak typeof(self) weakSelf = self;
    return ^id (CGFloat borderWidth) {
        weakSelf.view.layer.borderWidth = borderWidth;
        return weakSelf;
    };
}
- (id  _Nonnull (^)(UIColor * _Nonnull))borderColor{
    __weak typeof(self) weakSelf = self;
    return ^id (UIColor *borderColor) {
        weakSelf.view.layer.borderColor = borderColor.CGColor;
        return weakSelf;
    };
}
- (id  _Nonnull (^)(CGSize))shadowOffset{
    __weak typeof(self) weakSelf = self;
    return ^id (CGSize shadowOffset) {
        weakSelf.view.layer.shadowOffset = shadowOffset;
        return weakSelf;
    };
}
- (id  _Nonnull (^)(CGFloat))shadowRadius{
    __weak typeof(self) weakSelf = self;
    return ^id (CGFloat shadowRadius) {
        weakSelf.view.layer.shadowRadius = shadowRadius;
        return weakSelf;
    };
}
- (id  _Nonnull (^)(UIColor * _Nonnull))shadowColor{
    __weak typeof(self) weakSelf = self;
    return ^id (UIColor * shadowColor) {
        weakSelf.view.layer.shadowColor = shadowColor.CGColor;
        return weakSelf;
    };
}
- (id  _Nonnull (^)(CGFloat))shadowOpacity{
    __weak typeof(self) weakSelf = self;
    return ^id (CGFloat shadowOpacity) {
        weakSelf.view.layer.shadowOpacity = shadowOpacity;
        return weakSelf;
    };
}
@end
