//
//  YHViewChainModel.h
//  chanDemo
//
//  Created by 银河 on 2018/11/7.
//  Copyright © 2018 银河. All rights reserved.
//

#import "YHBaseViewChainModel.h"

NS_ASSUME_NONNULL_BEGIN
@class YHViewChainModel;
@interface YHViewChainModel : YHBaseViewChainModel <YHViewChainModel *>

@end



@interface UIView (YH_Chain)
@property (nonatomic, copy, readonly) YHViewChainModel *yh_viewChain;
+ (YHViewChainModel *)yh_creat;
@end
NS_ASSUME_NONNULL_END
