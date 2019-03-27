//
//  ASTableNode+YHASReload.h
//  HiFanSmooth
//
//  Created by apple on 2019/3/27.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Texture/AsyncDisplayKit/AsyncDisplayKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * ASTableNode刷新闪烁的解决办法
 */
@interface ASTableNode (YHASReload)

- (void)yh_reloadData;

- (void)yh_nodeBlockForRowWithCellNode:(ASCellNode *)cellNode indexPath:(NSIndexPath *)indexPath;


@end

NS_ASSUME_NONNULL_END
