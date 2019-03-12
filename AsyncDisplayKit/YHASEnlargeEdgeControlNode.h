//
//  YHASEnlargeEdgeControlNode.h
//  QAQSmooth
//
//  Created by apple on 2019/3/12.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Texture/AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHASEnlargeEdgeControlNode : ASButtonNode

// 扩大点击区域
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end

NS_ASSUME_NONNULL_END
