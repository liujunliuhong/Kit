//
//  YHASCollectionLayoutDelegate.h
//  HiFanSmooth
//
//  Created by apple on 2019/4/24.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * ASCollectionNode瀑布流配置
 * 目前这儿有个bug，只支持垂直方向的滚动，水平方向的滚动暂时不支持
 */
@interface YHASCollectionLayoutDelegate : NSObject <ASCollectionLayoutDelegate, ASCollectionViewLayoutInspecting>

/**
 * 无Header和Footer的配置方法
 */
- (instancetype)initWithNumberOfColumns:(NSInteger)numberOfColumns
                          columnSpacing:(CGFloat)columnSpacing
                       interItemSpacing:(CGFloat)interItemSpacing
                          sectionInsets:(UIEdgeInsets)sectionInsets
                        scrollDirection:(ASScrollDirection)scrollDirection;

/**
 * 有Header或者Footer的配置方法
 * isHeaderWidthBaseSectionInsets:Header的宽度是否根据SctionInsets来动态调整，默认NO
 * isFooterWidthBaseSectionInsets:Footer的宽度是否根据SctionInsets来动态调整，默认NO
 * bottomOffset:CollectionNode底部偏移量，默认大于0，如果小于0，框架内部自动设置为0
 */
- (instancetype)initWithNumberOfColumns:(NSInteger)numberOfColumns
                          columnSpacing:(CGFloat)columnSpacing
                       interItemSpacing:(CGFloat)interItemSpacing
                          sectionInsets:(UIEdgeInsets)sectionInsets
         isHeaderWidthBaseSectionInsets:(BOOL)isHeaderWidthBaseSectionInsets
         isFooterWidthBaseSectionInsets:(BOOL)isFooterWidthBaseSectionInsets
                            bottomOffset:(CGFloat)bottomOffset
                        scrollDirection:(ASScrollDirection)scrollDirection;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
