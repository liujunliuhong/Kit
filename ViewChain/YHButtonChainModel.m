//
//  YHButtonChainModel.m
//  chanDemo
//
//  Created by 银河 on 2018/11/9.
//  Copyright © 2018 银河. All rights reserved.
//

#import "YHButtonChainModel.h"

@implementation YHButtonChainModel
- (YHButtonChainModel * _Nonnull (^)(NSString * _Nonnull))title{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (NSString *title) {
        [((UIButton *)weakSelf.view) setTitle:title forState:UIControlStateNormal];
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(NSString * _Nonnull))titleHL{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (NSString *titleHL) {
        [((UIButton *)weakSelf.view) setTitle:titleHL forState:UIControlStateHighlighted];
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(UIColor * _Nonnull))titleColor{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (UIColor *titleColor) {
        [((UIButton *)weakSelf.view) setTitleColor:titleColor forState:UIControlStateNormal];
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(UIColor * _Nonnull))titleColorHL{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (UIColor *titleColorHL) {
        [((UIButton *)weakSelf.view) setTitleColor:titleColorHL forState:UIControlStateHighlighted];
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(UIImage * _Nonnull))image{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (UIImage *image) {
        [((UIButton *)weakSelf.view) setImage:image forState:UIControlStateNormal];
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(UIImage * _Nonnull))imageHL{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (UIImage *imageHL) {
        [((UIButton *)weakSelf.view) setImage:imageHL forState:UIControlStateHighlighted];
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(UIImage * _Nonnull))imageSelected{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (UIImage *imageSelected) {
        [((UIButton *)weakSelf.view) setImage:imageSelected forState:UIControlStateSelected];
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(UIImage * _Nonnull))backgroundImage{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (UIImage *backgroundImage) {
        [((UIButton *)weakSelf.view) setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(UIImage * _Nonnull))backgroundImageHL{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (UIImage *backgroundImageHL) {
        [((UIButton *)weakSelf.view) setBackgroundImage:backgroundImageHL forState:UIControlStateHighlighted];
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(UIColor * _Nonnull))backgroundImageColor{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (UIColor *backgroundImageColor) {
        [((UIButton *)weakSelf.view) setBackgroundImage:[weakSelf imageWithColor:backgroundImageColor] forState:UIControlStateNormal];
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(UIColor * _Nonnull))backgroundImageColorHL{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (UIColor *backgroundImageColorHL) {
        [((UIButton *)weakSelf.view) setBackgroundImage:[weakSelf imageWithColor:backgroundImageColorHL] forState:UIControlStateHighlighted];
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(NSAttributedString * _Nonnull))attributedTitle{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (NSAttributedString *attributedTitle) {
        [((UIButton *)weakSelf.view) setAttributedTitle:attributedTitle forState:UIControlStateNormal];
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(UIFont * _Nonnull))titleFont{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (UIFont *titleFont) {
        ((UIButton *)weakSelf.view).titleLabel.font = titleFont;
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(UIControlContentVerticalAlignment))contentVAlign{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (UIControlContentVerticalAlignment contentVAlign) {
        [((UIButton *)weakSelf.view) setContentVerticalAlignment:contentVAlign];
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(UIControlContentHorizontalAlignment))contentHAlign{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (UIControlContentHorizontalAlignment contentHAlign) {
        [((UIButton *)weakSelf.view) setContentHorizontalAlignment:contentHAlign];
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(UIEdgeInsets))contentEdgeInsets{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (UIEdgeInsets contentEdgeInsets) {
        [((UIButton *)weakSelf.view) setContentEdgeInsets:contentEdgeInsets];
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(UIEdgeInsets))titleEdgeInsets{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (UIEdgeInsets titleEdgeInsets) {
        [((UIButton *)weakSelf.view) setTitleEdgeInsets:titleEdgeInsets];
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(UIEdgeInsets))imageEdgeInsets{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (UIEdgeInsets imageEdgeInsets) {
        [((UIButton *)weakSelf.view) setImageEdgeInsets:imageEdgeInsets];
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(BOOL))selected{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (BOOL selected) {
        ((UIButton *)weakSelf.view).selected = selected;
        return weakSelf;
    };
}
- (YHButtonChainModel * _Nonnull (^)(BOOL))highlighted{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (BOOL highlighted) {
        ((UIButton *)weakSelf.view).highlighted = highlighted;
        return weakSelf;
    };
}

- (YHButtonChainModel * _Nonnull (^)(BOOL))adjustsFontSizeToFitWidth{
    __weak typeof(self) weakSelf = self;
    return ^YHButtonChainModel * (BOOL adjustsFontSizeToFitWidth) {
        ((UIButton *)weakSelf.view).titleLabel.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
        return weakSelf;
    };
}



- (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end




@implementation UIButton (YH_Chain)
- (YHButtonChainModel *)yh_buttonChain{
    return [[YHButtonChainModel alloc] initWithView:self];
}
+ (YHButtonChainModel *)yh_system_creat{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    return [[YHButtonChainModel alloc] initWithView:button];
}
+ (YHButtonChainModel *)yh_custom_creat{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    return [[YHButtonChainModel alloc] initWithView:button];
}
@end
