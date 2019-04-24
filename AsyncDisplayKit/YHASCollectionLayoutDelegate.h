//
//  YHASCollectionLayoutDelegate.h
//  HiFanSmooth
//
//  Created by apple on 2019/4/24.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Texture/AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * ASCollectionNode瀑布流配置
 */
@interface YHASCollectionLayoutDelegate : NSObject <ASCollectionLayoutDelegate, ASCollectionViewLayoutInspecting>

- (instancetype)initWithNumberOfColumns:(NSInteger)numberOfColumns
                          columnSpacing:(CGFloat)columnSpacing
                       interItemSpacing:(CGFloat)interItemSpacing
                          sectionInsets:(UIEdgeInsets)sectionInsets
                        scrollDirection:(ASScrollDirection)scrollDirection;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
