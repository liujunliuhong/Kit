//
//  YHTextFieldChainModel.h
//  chanDemo
//
//  Created by apple on 2018/11/13.
//  Copyright © 2018 银河. All rights reserved.
//

#import "YHBaseViewChainModel.h"

NS_ASSUME_NONNULL_BEGIN
@class YHTextFieldChainModel;
@interface YHTextFieldChainModel : YHBaseViewChainModel <YHTextFieldChainModel *>

@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^text)(NSString *text);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^font)(UIFont *font);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^textColor)(UIColor *textColor);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^textAlignment)(NSTextAlignment textAlignment);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^borderStyle)(UITextBorderStyle borderStyle);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^placeholder)(NSString *placeholder);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^attributedPlaceholder)(NSAttributedString *attributedPlaceholder);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^keyboardType)(UIKeyboardType keyboardType);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^clearsOnBeginEditing)(BOOL clearsOnBeginEditing);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^adjustsFontSizeToFitWidth)(BOOL adjustsFontSizeToFitWidth);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^minimumFontSize)(CGFloat minimumFontSize);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^delegate)(id<UITextFieldDelegate> delegate);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^clearButtonMode)(UITextFieldViewMode clearButtonMode);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^secureTextEntry)(BOOL secureTextEntry);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^returnKeyType)(UIReturnKeyType returnKeyType);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^enablesReturnKeyAutomatically)(BOOL enablesReturnKeyAutomatically);

@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^leftView)(UIView *leftView);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^rightView)(UIView *rightView);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^leftViewMode)(UITextFieldViewMode leftViewMode);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^rightViewMode)(UITextFieldViewMode rightViewMode);

@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^inputView)(UIView *inputView);
@property (nonatomic, copy, readonly) YHTextFieldChainModel *(^inputAccessoryView)(UIView *inputAccessoryView);


@end


@interface UITextField (YH_Chain)
@property (nonatomic, copy, readonly) YHTextFieldChainModel *yh_textFieldChain;
+ (YHTextFieldChainModel *)yh_creat;

/**
 * A proprietary method written for UITextField's attributed Placeholder.
 */
+ (NSAttributedString *)yh_attributedPlaceholderWithString:(NSString *)string color:(UIColor *)color font:(UIFont *)font;

@end
NS_ASSUME_NONNULL_END
