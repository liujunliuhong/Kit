//
//  YHImageBrowserCellDataProtocol.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/14.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * cellData协议
 */
@protocol YHImageBrowserCellDataProtocol <NSObject>

@required;

- (Class)yh_cellClass;

@end

NS_ASSUME_NONNULL_END
