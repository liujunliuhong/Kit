//
//  YHTextView.h
//  HiFanSmooth
//
//  Created by apple on 2019/7/19.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHTextView : UITextView
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, strong) UIFont *placeholderFont;

@property (nonatomic, strong) NSMutableAttributedString *attributePlaceholder;

@end


NS_ASSUME_NONNULL_END
