//
//  NSMutableAttributedString+YHExtension.h
//  QAQSmooth
//
//  Created by apple on 2019/3/12.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (YHExtension)


/**
 快速设置一个属性字符串

 @param text 文本
 @param color 文本颜色
 @param font 字体
 @param kern 文字间距(0代表默认间距)
 @param lineSpacing 行间距(0代表默认间距)
 @param alignment 文本对其方式
 @return 属性字符串
 */
+ (NSMutableAttributedString *)yh_attributedStringWithText:(NSString *)text
                                                     color:(UIColor *)color
                                                      font:(UIFont *)font
                                                      kern:(CGFloat)kern
                                               lineSpacing:(CGFloat)lineSpacing
                                                 alignment:(NSTextAlignment)alignment;

@end

NS_ASSUME_NONNULL_END
