//
//  YHViewChainModel.m
//  chanDemo
//
//  Created by 银河 on 2018/11/7.
//  Copyright © 2018 银河. All rights reserved.
//

#import "YHViewChainModel.h"

@implementation YHViewChainModel


@end

@implementation UIView (YH_Chain)
- (YHViewChainModel *)yh_viewChain {
    return [[YHViewChainModel alloc] initWithView:self];
}
+ (YHViewChainModel *)yh_creat{
    UIView *view = [[UIView alloc] init];
    return [[YHViewChainModel alloc] initWithView:view];
}
@end


