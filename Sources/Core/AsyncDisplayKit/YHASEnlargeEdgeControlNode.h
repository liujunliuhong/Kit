//
//  YHASEnlargeEdgeControlNode.h
//  QAQSmooth
//
//  Created by apple on 2019/3/12.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHASEnlargeEdgeControlNode : ASButtonNode


/**
 扩大点击区域(注意：实在父Node的基础上的，如果父node比较小，比如和YHASEnlargeEdgeControlNode相等，那么设置这个是没有效果的)

 @param top 向上的偏移量
 @param right 向右的偏移量
 @param bottom 向下的偏移量
 @param left 向左的偏移量
 */
- (void)yh_setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end

NS_ASSUME_NONNULL_END
