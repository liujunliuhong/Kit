//
//  YHTextView.m
//  HiFanSmooth
//
//  Created by apple on 2019/7/19.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHTextView.h"

@implementation YHTextView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)textDidChange:(NSNotification *)note{
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect{
    if (self.text.length > 0) {
        return;
    }
    
    CGRect rt = CGRectMake(self.contentInset.left + 5, self.contentInset.top + 8, self.frame.size.width - self.contentInset.left - self.contentInset.right - 5 - 5, self.frame.size.height - self.contentInset.top - self.contentInset.bottom - 8 - 8);
    
    if (self.attributePlaceholder) {
        [self.attributePlaceholder drawWithRect:rt options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    } else if (self.placeholder) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:self.placeholder];
        if (self.placeholderFont) {
            [attr addAttribute:NSFontAttributeName value:self.placeholderFont range:NSMakeRange(0, self.placeholder.length)];
        }
        if (self.placeholderColor) {
            [attr addAttribute:NSForegroundColorAttributeName value:self.placeholderColor range:NSMakeRange(0, self.placeholder.length)];
        }
        [attr drawWithRect:rt options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    [self setNeedsDisplay];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont{
    _placeholderFont = placeholderFont;
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)setAttributePlaceholder:(NSMutableAttributedString *)attributePlaceholder{
    _attributePlaceholder = attributePlaceholder;
    [self setNeedsDisplay];
}

@end
