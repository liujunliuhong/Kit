//
//  ASControlNode+YHAddTap.m
//  QAQSmooth
//
//  Created by apple on 2019/3/12.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "ASControlNode+YHAddTap.h"
#import <objc/message.h>

static char actionKey;
typedef void(^__actionBlock)(__kindof ASControlNode *sender);

@implementation ASControlNode (YHAddTap)
- (void)yh_addControllActionWithBlock:(void (^)(__kindof ASControlNode * _Nonnull))actionBlock{
    objc_setAssociatedObject(self, &actionKey, actionBlock, OBJC_ASSOCIATION_COPY);
    [self addTarget:self action:@selector(action) forControlEvents:ASControlNodeEventTouchUpInside];
}

- (void)action{
    __actionBlock block = objc_getAssociatedObject(self, &actionKey);
    if (block) {
        block(self);
    }
}

@end
