//
//  YHTextFieldChainModel.m
//  chanDemo
//
//  Created by apple on 2018/11/13.
//  Copyright © 2018 银河. All rights reserved.
//

#import "YHTextFieldChainModel.h"

#define YH_TEXTFIELD   ((UITextField *)weakSelf.view)

@implementation YHTextFieldChainModel

- (YHTextFieldChainModel * _Nonnull (^)(NSString * _Nonnull))text{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (NSString *text) {
        YH_TEXTFIELD.text = text;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(UIFont * _Nonnull))font{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (UIFont *font) {
        YH_TEXTFIELD.font = font;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(UIColor * _Nonnull))textColor{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (UIColor *textColor) {
        YH_TEXTFIELD.textColor = textColor;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(NSTextAlignment))textAlignment{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (NSTextAlignment textAlignment) {
        YH_TEXTFIELD.textAlignment = textAlignment;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(UITextBorderStyle))borderStyle{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (UITextBorderStyle borderStyle) {
        YH_TEXTFIELD.borderStyle = borderStyle;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(NSString * _Nonnull))placeholder{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (NSString *placeholder) {
        YH_TEXTFIELD.placeholder = placeholder;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(NSAttributedString * _Nonnull))attributedPlaceholder{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (NSAttributedString *attributedPlaceholder) {
        YH_TEXTFIELD.attributedPlaceholder = attributedPlaceholder;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(UIKeyboardType))keyboardType{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (UIKeyboardType keyboardType) {
        YH_TEXTFIELD.keyboardType = keyboardType;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(BOOL))clearsOnBeginEditing{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (BOOL clearsOnBeginEditing) {
        YH_TEXTFIELD.clearsOnBeginEditing = clearsOnBeginEditing;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(BOOL))adjustsFontSizeToFitWidth{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (BOOL adjustsFontSizeToFitWidth) {
        YH_TEXTFIELD.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(CGFloat))minimumFontSize{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (CGFloat minimumFontSize) {
        YH_TEXTFIELD.minimumFontSize = minimumFontSize;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(id<UITextFieldDelegate> _Nonnull))delegate{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (id<UITextFieldDelegate> delegate) {
        YH_TEXTFIELD.delegate = delegate;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(UITextFieldViewMode))clearButtonMode{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (UITextFieldViewMode clearButtonMode) {
        YH_TEXTFIELD.clearButtonMode = clearButtonMode;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(BOOL))secureTextEntry{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (BOOL secureTextEntry) {
        YH_TEXTFIELD.secureTextEntry = secureTextEntry;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(UIReturnKeyType))returnKeyType{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (UIReturnKeyType returnKeyType) {
        YH_TEXTFIELD.returnKeyType = returnKeyType;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(BOOL))enablesReturnKeyAutomatically{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (BOOL enablesReturnKeyAutomatically) {
        YH_TEXTFIELD.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(UIView * _Nonnull))leftView{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (UIView *leftView) {
        YH_TEXTFIELD.leftView = leftView;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(UIView * _Nonnull))rightView{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (UIView *rightView) {
        YH_TEXTFIELD.rightView = rightView;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(UITextFieldViewMode))leftViewMode{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (UITextFieldViewMode leftViewMode) {
        YH_TEXTFIELD.leftViewMode = leftViewMode;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(UITextFieldViewMode))rightViewMode{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (UITextFieldViewMode rightViewMode) {
        YH_TEXTFIELD.leftViewMode = rightViewMode;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(UIView * _Nonnull))inputView{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (UIView *inputView) {
        YH_TEXTFIELD.inputView = inputView;
        return weakSelf;
    };
}
- (YHTextFieldChainModel * _Nonnull (^)(UIView * _Nonnull))inputAccessoryView{
    __weak typeof(self) weakSelf = self;
    return ^YHTextFieldChainModel * (UIView *inputAccessoryView) {
        YH_TEXTFIELD.inputAccessoryView = inputAccessoryView;
        return weakSelf;
    };
}
@end





@implementation UITextField (YH_Chain)
- (YHTextFieldChainModel *)yh_textFieldChain{
    return [[YHTextFieldChainModel alloc] initWithView:self];
}
+ (YHTextFieldChainModel *)yh_creat{
    UITextField *textField = [[UITextField alloc] init];
    return [[YHTextFieldChainModel alloc] initWithView:textField];
}
+ (NSAttributedString *)yh_attributedPlaceholderWithString:(NSString *)string color:(UIColor *)color font:(UIFont *)font{
    NSAttributedString *atr = [[NSAttributedString alloc] initWithString:string attributes:@{
                                                                                             NSForegroundColorAttributeName:color,
                                                                                             NSFontAttributeName:font
                                                                                             }];
    return atr;
}
@end
