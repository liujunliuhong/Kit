//
//  YHASNetworkImageNode.h
//  HiFanSmooth
//
//  Created by apple on 2019/3/27.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Texture/AsyncDisplayKit/AsyncDisplayKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * 解决ASNetworkImageNode闪烁的问题
 */
@interface YHASNetworkImageNode : ASDisplayNode

@property (nonatomic, strong, readonly) ASNetworkImageNode *netImageNode;
@property (nonatomic, strong, readonly) ASImageNode *imageNode;

@property (nonatomic, copy) NSString *URL;
@property (nonatomic, assign) UIViewContentMode contentMode;
@property (nonatomic, copy) asimagenode_modification_block_t imageModificationBlock;
@end

NS_ASSUME_NONNULL_END
