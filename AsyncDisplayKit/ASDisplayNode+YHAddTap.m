//
//  ASDisplayNode+YHAddTap.m
//  QAQSmooth
//
//  Created by apple on 2019/3/12.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "ASDisplayNode+YHAddTap.h"
#import <objc/message.h>

static char actionKey;
typedef void(^__actionBlock)(void);

@implementation ASDisplayNode (YHAddTap)

- (void)yh_addTapWithActionBlock:(void (^)(void))actionBlock{
    objc_setAssociatedObject(self, &actionKey, actionBlock, OBJC_ASSOCIATION_COPY);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action)];
    [self.view addGestureRecognizer:tap];
}

- (void)action{
    __actionBlock block = objc_getAssociatedObject(self, &actionKey);
    if (block) {
        block();
    }
    objc_setAssociatedObject(self, &actionKey, nil, OBJC_ASSOCIATION_COPY);
}

@end
