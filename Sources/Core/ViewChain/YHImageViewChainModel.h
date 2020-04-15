//
//  YHImageViewChainModel.h
//  chanDemo
//
//  Created by apple on 2018/11/12.
//  Copyright © 2018 银河. All rights reserved.
//

#import "YHBaseViewChainModel.h"

NS_ASSUME_NONNULL_BEGIN
@class YHImageViewChainModel;
@interface YHImageViewChainModel : YHBaseViewChainModel <YHImageViewChainModel *>

@property (nonatomic, copy, readonly) YHImageViewChainModel *(^image)(UIImage *image);
@property (nonatomic, copy, readonly) YHImageViewChainModel *(^imageHL)(UIImage *imageHL);

@end

@interface UIImageView (YH_Chain)
@property (nonatomic, copy, readonly) YHImageViewChainModel *yh_imageViewChain;
+ (YHImageViewChainModel *)yh_creat;
@end
NS_ASSUME_NONNULL_END
