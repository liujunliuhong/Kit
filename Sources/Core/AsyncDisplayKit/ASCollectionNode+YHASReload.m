//
//  ASCollectionNode+YHASReload.m
//  FrameDating
//
//  Created by 银河 on 2019/6/1.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "ASCollectionNode+YHASReload.h"
#import <objc/message.h>

const char _yh_reload_path_key__;

@interface ASCollectionNode ()
@property (nonatomic, strong) NSArray *yh_reloadPaths;
@end


@implementation ASCollectionNode (YHASReload)
- (void)setYh_reloadPaths:(NSArray *)yh_reloadPaths{
    objc_setAssociatedObject(self, &_yh_reload_path_key__, yh_reloadPaths, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray *)yh_reloadPaths{
    return objc_getAssociatedObject(self, &_yh_reload_path_key__);
}

- (void)yh_reloadData{
    self.yh_reloadPaths = self.self.indexPathsForVisibleItems;
    [self reloadData];
}

- (void)yh_nodeBlockForRowWithCellNode:(ASCellNode *)cellNode indexPath:(NSIndexPath *)indexPath{
    if ([self.yh_reloadPaths containsObject:indexPath]) {
        cellNode.neverShowPlaceholders = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            cellNode.neverShowPlaceholders = NO;
        });
    }
    else {
        cellNode.neverShowPlaceholders = NO;
    }
}
@end
