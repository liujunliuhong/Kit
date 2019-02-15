//
//  YHImageViewChainModel.m
//  chanDemo
//
//  Created by apple on 2018/11/12.
//  Copyright © 2018 银河. All rights reserved.
//

#import "YHImageViewChainModel.h"

#define YH_IMAGEVIEW    ((UIImageView *)weakSelf.view)

@implementation YHImageViewChainModel
- (YHImageViewChainModel * _Nonnull (^)(UIImage * _Nonnull))image{
    __weak typeof(self) weakSelf = self;
    return ^YHImageViewChainModel * (UIImage *image) {
        YH_IMAGEVIEW.image = image;
        return weakSelf;
    };
}
- (YHImageViewChainModel * _Nonnull (^)(UIImage * _Nonnull))imageHL{
    __weak typeof(self) weakSelf = self;
    return ^YHImageViewChainModel * (UIImage *imageHL) {
        YH_IMAGEVIEW.highlightedImage = imageHL;
        return weakSelf;
    };
}

@end


@implementation UIImageView (YH_Chain)
- (YHImageViewChainModel *)yh_imageViewChain{
    return [[YHImageViewChainModel alloc] initWithView:self];
}
+ (YHImageViewChainModel *)yh_creat{
    UIImageView *imageView = [[UIImageView alloc] init];
    return [[YHImageViewChainModel alloc] initWithView:imageView];
}

@end
