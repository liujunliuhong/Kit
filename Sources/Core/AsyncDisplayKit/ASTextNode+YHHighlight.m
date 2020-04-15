//
//  ASTextNode+YHHighlight.m
//  QAQSmooth
//
//  Created by apple on 2019/3/14.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "ASTextNode+YHHighlight.h"
#import <objc/message.h>

const char _highlight_properties_key;

@implementation ASTextNode (YHHighlight)
+ (void)load{
    Method originMethod = class_getInstanceMethod(self, NSSelectorFromString(@"_setHighlightRange:forAttributeName:value:animated:"));
    
    Method myMethod = class_getInstanceMethod(self, NSSelectorFromString(@"_yh_setHighlightRange:forAttributeName:value:animated:"));
    method_exchangeImplementations(originMethod, myMethod);
}
- (void)yh_as_setHighlightColor:(UIColor *)highlightColor range:(NSRange)range attributeName:(nonnull NSString *)attributeName{

    NSMutableDictionary *properties = objc_getAssociatedObject(self, &_highlight_properties_key);
    if (!properties) {
        properties = [NSMutableDictionary dictionary];
    }
    [properties setObject:@[[NSValue valueWithRange:range], highlightColor] forKey:attributeName];
    objc_setAssociatedObject(self, &_highlight_properties_key, properties, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)_yh_setHighlightRange:(NSRange)highlightRange forAttributeName:(NSString *)highlightedAttributeName value:(id)highlightedAttributeValue animated:(BOOL)animated{
    [self _yh_setHighlightRange:highlightRange forAttributeName:highlightedAttributeName value:highlightedAttributeValue animated:animated];
    
    NSMutableDictionary *properties = objc_getAssociatedObject(self, &_highlight_properties_key);
    if (properties) {
        if ([properties.allKeys containsObject:highlightedAttributeName]) {
            NSArray *values = properties[highlightedAttributeName];
            NSRange range = [values[0] rangeValue];
            UIColor *color = values[1];
            if (NSEqualRanges(range, highlightRange)) {
                ASHighlightOverlayLayer *highlightOverlayLayer = [self valueForKeyPath:@"_activeHighlightLayer"];
                if (highlightOverlayLayer) {
                    highlightOverlayLayer.highlightColor = color.CGColor;
                    highlightOverlayLayer.opacity = 1;
                }
            }
        }
    }
}


@end
