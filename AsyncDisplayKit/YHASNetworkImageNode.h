//
//  YHASNetworkImageNode.h
//  HiFanSmooth
//
//  Created by apple on 2019/3/27.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <SDWebImage/SDWebImage.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 解决ASNetworkImageNode闪烁的问题
 */
@interface YHASNetworkImageNode : ASControlNode
@property (nonatomic, strong, readonly) SDAnimatedImageView *animatedImageView;

@property (nonatomic, strong, nullable) UIImage *placeholdeImage; // 请在设置URL之前设置placeholdeImage
@property (nonatomic, copy) NSString *URL;
@property (nonatomic, assign) UIViewContentMode contentMode;
- (void)setURL:(NSString *)URL placeholdeImage:(nullable UIImage *)placeholdeImage contentMode:(UIViewContentMode)contentMode;


@end

NS_ASSUME_NONNULL_END
