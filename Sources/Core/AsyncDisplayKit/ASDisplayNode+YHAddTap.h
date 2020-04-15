//
//  ASDisplayNode+YHAddTap.h
//  QAQSmooth
//
//  Created by apple on 2019/3/12.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASDisplayNode (YHAddTap)

// ASDisplayNode触摸事件
- (void)yh_addTapWithActionBlock:(void(^_Nullable)(void))actionBlock;

@end

NS_ASSUME_NONNULL_END
