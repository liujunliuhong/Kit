//
//  YHLabelChainModel.m
//  chanDemo
//
//  Created by apple on 2018/11/8.
//  Copyright © 2018 银河. All rights reserved.
//

#import "YHLabelChainModel.h"

@implementation YHLabelChainModel

- (YHLabelChainModel * _Nonnull (^)(NSString * _Nonnull))text{
    __weak typeof(self) weakSelf = self;
    return ^YHLabelChainModel * (NSString *text) {
        ((UILabel *)weakSelf.view).text = text;
        return weakSelf;
    };
}
- (YHLabelChainModel * _Nonnull (^)(NSTextAlignment))textAlignment{
    __weak typeof(self) weakSelf = self;
    return ^YHLabelChainModel * (NSTextAlignment textAlignment) {
        ((UILabel *)weakSelf.view).textAlignment = textAlignment;
        return weakSelf;
    };
}
- (YHLabelChainModel * _Nonnull (^)(UIColor * _Nonnull))textColor{
    __weak typeof(self) weakSelf = self;
    return ^YHLabelChainModel * (UIColor *textColor) {
        ((UILabel *)weakSelf.view).textColor = textColor;
        return weakSelf;
    };
}
- (YHLabelChainModel * _Nonnull (^)(UIFont * _Nonnull))font{
    __weak typeof(self) weakSelf = self;
    return ^YHLabelChainModel * (UIFont *font) {
        ((UILabel *)weakSelf.view).font = font;
        return weakSelf;
    };
}
- (YHLabelChainModel * _Nonnull (^)(NSInteger))numberOfLines{
    __weak typeof(self) weakSelf = self;
    return ^YHLabelChainModel * (NSInteger numberOfLines) {
        ((UILabel *)weakSelf.view).numberOfLines = numberOfLines;
        return weakSelf;
    };
}
- (YHLabelChainModel * _Nonnull (^)(NSLineBreakMode))lineBreakMode{
    __weak typeof(self) weakSelf = self;
    return ^YHLabelChainModel * (NSLineBreakMode lineBreakMode) {
        ((UILabel *)weakSelf.view).lineBreakMode = lineBreakMode;
        return weakSelf;
    };
}
- (YHLabelChainModel * _Nonnull (^)(BOOL))adjustsFontSizeToFitWidth{
    __weak typeof(self) weakSelf = self;
    return ^YHLabelChainModel * (BOOL adjustsFontSizeToFitWidth) {
        ((UILabel *)weakSelf.view).adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
        return weakSelf;
    };
}
- (YHLabelChainModel * _Nonnull (^)(NSAttributedString * _Nonnull))attributedText{
    __weak typeof(self) weakSelf = self;
    return ^YHLabelChainModel * (NSAttributedString *attributedText) {
        ((UILabel *)weakSelf.view).attributedText = attributedText;
        return weakSelf;
    };
}
@end





@implementation UILabel (YH_Chain)
- (YHLabelChainModel *)yh_labelChain{
    return [[YHLabelChainModel alloc] initWithView:self];
}
+ (YHLabelChainModel *)yh_creat{
    UILabel *label = [[UILabel alloc] init];
    return [[YHLabelChainModel alloc] initWithView:label];
}
@end
