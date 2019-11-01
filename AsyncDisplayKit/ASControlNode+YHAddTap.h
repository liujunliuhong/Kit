//
//  ASControlNode+YHAddTap.h
//  QAQSmooth
//
//  Created by apple on 2019/3/12.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASControlNode (YHAddTap)

// ASControlNode点击事件封装
- (void)yh_addControllActionWithBlock:(void(^_Nullable)( __kindof ASControlNode * sender))actionBlock;

@end

NS_ASSUME_NONNULL_END
