//
//  ASTextNode+YHHighlight.h
//  QAQSmooth
//
//  Created by apple on 2019/3/14.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASTextNode (YHHighlight)

- (void)yh_as_setHighlightColor:(UIColor *)highlightColor range:(NSRange)range attributeName:(NSString *)attributeName;

@end

NS_ASSUME_NONNULL_END
