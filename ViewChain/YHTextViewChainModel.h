//
//  YHTextViewChainModel.h
//  chanDemo
//
//  Created by apple on 2018/12/13.
//  Copyright © 2018 银河. All rights reserved.
//

#import "YHBaseViewChainModel.h"

NS_ASSUME_NONNULL_BEGIN
@class YHTextViewChainModel;
@interface YHTextViewChainModel : YHBaseViewChainModel <YHTextViewChainModel *>





@end









@interface UITextView (YH_Chain)
@property (nonatomic, copy, readonly) YHTextViewChainModel *yh_textViewChain;
+ (YHTextViewChainModel *)yh_creat;
@end
NS_ASSUME_NONNULL_END
