//
//  YYLabel+YHBugFix.m
//  QAQSmooth
//
//  Created by apple on 2019/3/15.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YYLabel+YHBugFix.h"
#import <objc/message.h>
#import "NSString+YHExtension.h"

@implementation YYLabel (YHBugFix)

+ (void)load{
    Method originMethod = class_getInstanceMethod(self, NSSelectorFromString(@"setAttributedText:"));
    Method myMethod = class_getInstanceMethod(self, NSSelectorFromString(@"_yh_setAttributedText:"));
    method_exchangeImplementations(originMethod, myMethod);
}

- (void)_yh_setAttributedText:(NSAttributedString *)attributedText{
    if (attributedText.string.yh_isContainChinese) {
        NSMutableAttributedString *atr = (NSMutableAttributedString *)attributedText;
        if (atr.yy_underlineStyle == NSUnderlineStyleNone) {
            if (@available(iOS 11.0, *)) {
                [atr addAttribute:NSBaselineOffsetAttributeName value:@(-1) range:NSMakeRange(0, atr.length)];
            } else {
                [atr addAttribute:NSBaselineOffsetAttributeName value:@(-0.4) range:NSMakeRange(0, atr.length)];
            }
        }
    }
    [self _yh_setAttributedText:attributedText];
}
@end
