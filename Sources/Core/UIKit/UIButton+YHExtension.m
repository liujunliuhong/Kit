//
//  UIButton+YHExtension.m
//  HiFanSmooth
//
//  Created by apple on 2019/5/15.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "UIButton+YHExtension.h"
#import <objc/message.h>

static char yh_button_action_key;

@implementation UIButton (YHExtension)

- (void)yh_addTapActionBlock:(void (^)(void))tapActionBlock{
    if (tapActionBlock) {
        objc_setAssociatedObject(self, &yh_button_action_key, tapActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    [self addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tapAction{
    void(^block)(void) =  objc_getAssociatedObject(self, &yh_button_action_key);
    if (block) {
        block();
    }
}
@end
