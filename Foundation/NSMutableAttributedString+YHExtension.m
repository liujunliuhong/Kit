//
//  NSMutableAttributedString+YHExtension.m
//  QAQSmooth
//
//  Created by apple on 2019/3/12.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "NSMutableAttributedString+YHExtension.h"


@implementation NSMutableAttributedString (YHExtension)

+ (NSMutableAttributedString *)yh_attributedStringWithText:(NSString *)text color:(UIColor *)color font:(UIFont *)font kern:(CGFloat)kern lineSpacing:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment{
    if (!text) {
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.alignment = alignment;
    
    [attr addAttributes:@{NSForegroundColorAttributeName : color,
                          NSFontAttributeName : font,
                          NSKernAttributeName : @(kern),
                          NSParagraphStyleAttributeName : paragraphStyle
                          } range:NSMakeRange(0, text.length)];
    return attr;
}

@end
