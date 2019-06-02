//
//  ASCollectionNode+YHASReload.h
//  FrameDating
//
//  Created by 银河 on 2019/6/1.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Texture/AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * ASCollectionNode刷新闪烁的解决办法
 */
@interface ASCollectionNode (YHASReload)

- (void)yh_reloadData;

- (void)yh_nodeBlockForRowWithCellNode:(ASCellNode *)cellNode indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
