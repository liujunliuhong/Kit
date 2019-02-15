//
//  YHScrollViewChainModel.h
//  chanDemo
//
//  Created by apple on 2018/11/13.
//  Copyright © 2018 银河. All rights reserved.
//

#import "YHBaseViewChainModel.h"

NS_ASSUME_NONNULL_BEGIN
@class YHScrollViewChainModel;
@interface YHScrollViewChainModel : YHBaseViewChainModel <YHScrollViewChainModel *>

@property (nonatomic, copy, readonly) YHScrollViewChainModel *(^delegate)(id<UIScrollViewDelegate>);

@property (nonatomic, copy, readonly) YHScrollViewChainModel *(^contentSize)(CGSize contentSize);
@property (nonatomic, copy, readonly) YHScrollViewChainModel *(^contentOffset)(CGPoint contentOffset);
@property (nonatomic, copy, readonly) YHScrollViewChainModel *(^contentInset)(UIEdgeInsets contentInset);

@property (nonatomic, copy, readonly) YHScrollViewChainModel *(^bounces)(BOOL bounces);
@property (nonatomic, copy, readonly) YHScrollViewChainModel *(^alwaysBounceVertical)(BOOL alwaysBounceVertical);
@property (nonatomic, copy, readonly) YHScrollViewChainModel *(^alwaysBounceHorizontal)(BOOL alwaysBounceHorizontal);

@property (nonatomic, copy, readonly) YHScrollViewChainModel *(^pagingEnabled)(BOOL pagingEnabled);
@property (nonatomic, copy, readonly) YHScrollViewChainModel *(^scrollEnabled)(BOOL scrollEnabled);

@property (nonatomic, copy, readonly) YHScrollViewChainModel *(^showsHorizontalScrollIndicator)(BOOL showsHorizontalScrollIndicator);
@property (nonatomic, copy, readonly) YHScrollViewChainModel *(^showsVerticalScrollIndicator)(BOOL showsVerticalScrollIndicator);

@end




@interface UIScrollView (YH_Chain)
@property (nonatomic, copy, readonly) YHScrollViewChainModel *yh_scrollChain;
+ (YHScrollViewChainModel *)yh_creat;
@end
NS_ASSUME_NONNULL_END
