//
//  YHButtonChainModel.h
//  chanDemo
//
//  Created by 银河 on 2018/11/9.
//  Copyright © 2018 银河. All rights reserved.
//

#import "YHBaseViewChainModel.h"

NS_ASSUME_NONNULL_BEGIN
@class YHButtonChainModel;
@interface YHButtonChainModel : YHBaseViewChainModel <YHButtonChainModel *>

@property (nonatomic, copy, readonly) YHButtonChainModel *(^title)(NSString *title);
@property (nonatomic, copy, readonly) YHButtonChainModel *(^titleHL)(NSString *titleHL);

@property (nonatomic, copy, readonly) YHButtonChainModel *(^titleColor)(UIColor *titleColor);
@property (nonatomic, copy, readonly) YHButtonChainModel *(^titleColorHL)(UIColor *titleColorHL);

@property (nonatomic, copy, readonly) YHButtonChainModel *(^image)(UIImage *image);
@property (nonatomic, copy, readonly) YHButtonChainModel *(^imageHL)(UIImage *imageHL);
@property (nonatomic, copy, readonly) YHButtonChainModel *(^imageSelected)(UIImage *imageSelected);

@property (nonatomic, copy, readonly) YHButtonChainModel *(^backgroundImage)(UIImage *backgroundImage);
@property (nonatomic, copy, readonly) YHButtonChainModel *(^backgroundImageHL)(UIImage *backgroundImageHL);

@property (nonatomic, copy, readonly) YHButtonChainModel *(^backgroundImageColor)(UIColor *backgroundImageColor);
@property (nonatomic, copy, readonly) YHButtonChainModel *(^backgroundImageColorHL)(UIColor *backgroundImageColorHL);

@property (nonatomic, copy, readonly) YHButtonChainModel *(^attributedTitle)(NSAttributedString *attributedTitle);

@property (nonatomic, copy, readonly) YHButtonChainModel *(^titleFont)(UIFont *titleFont);

@property (nonatomic, copy, readonly) YHButtonChainModel *(^contentVAlign)(UIControlContentVerticalAlignment contentVAlign);
@property (nonatomic, copy, readonly) YHButtonChainModel *(^contentHAlign)(UIControlContentHorizontalAlignment contentHAlign);


@property (nonatomic, copy, readonly) YHButtonChainModel *(^contentEdgeInsets)(UIEdgeInsets contentEdgeInsets);
@property (nonatomic, copy, readonly) YHButtonChainModel *(^titleEdgeInsets)(UIEdgeInsets titleEdgeInsets);
@property (nonatomic, copy, readonly) YHButtonChainModel *(^imageEdgeInsets)(UIEdgeInsets imageEdgeInsets);


@property (nonatomic, copy, readonly) YHButtonChainModel *(^selected)(BOOL selected);
@property (nonatomic, copy, readonly) YHButtonChainModel *(^highlighted)(BOOL highlighted);

@property (nonatomic, copy, readonly) YHButtonChainModel *(^adjustsFontSizeToFitWidth)(BOOL adjustsFontSizeToFitWidth);

@end


@interface UIButton (YH_Chain)
@property (nonatomic, copy, readonly) YHButtonChainModel *yh_buttonChain;
+ (YHButtonChainModel *)yh_system_creat;
+ (YHButtonChainModel *)yh_custom_creat;
@end
NS_ASSUME_NONNULL_END
