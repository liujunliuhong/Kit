//
//  YHLabelChainModel.h
//  chanDemo
//
//  Created by apple on 2018/11/8.
//  Copyright © 2018 银河. All rights reserved.
//

#import "YHBaseViewChainModel.h"

NS_ASSUME_NONNULL_BEGIN
@class YHLabelChainModel;
///<YHLabelChainModel *>必须加上，因为父类用了泛型
@interface YHLabelChainModel : YHBaseViewChainModel <YHLabelChainModel *>

@property (nonatomic, copy, readonly) YHLabelChainModel *(^text)(NSString *text);
@property (nonatomic, copy, readonly) YHLabelChainModel *(^textColor)(UIColor *textColor);
@property (nonatomic, copy, readonly) YHLabelChainModel *(^textAlignment)(NSTextAlignment alignment);
@property (nonatomic, copy, readonly) YHLabelChainModel *(^font)(UIFont *font);
@property (nonatomic, copy, readonly) YHLabelChainModel *(^numberOfLines)(NSInteger numberOfLines);
@property (nonatomic, copy, readonly) YHLabelChainModel *(^lineBreakMode)(NSLineBreakMode lineBreakMode);
@property (nonatomic, copy, readonly) YHLabelChainModel *(^adjustsFontSizeToFitWidth)(BOOL adjustsFontSizeToFitWidth);
@property (nonatomic, copy, readonly) YHLabelChainModel *(^attributedText)(NSAttributedString *attributedText);

@end


@interface UILabel (YH_Chain)
@property (nonatomic, copy, readonly) YHLabelChainModel *yh_labelChain;
+ (YHLabelChainModel *)yh_creat;
@end
NS_ASSUME_NONNULL_END
