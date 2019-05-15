//
//  UIButton+YHExtension.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/15.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (YHExtension)

- (void)yh_addTapActionBlock:(void(^_Nullable)(void))tapActionBlock;

@end

NS_ASSUME_NONNULL_END
