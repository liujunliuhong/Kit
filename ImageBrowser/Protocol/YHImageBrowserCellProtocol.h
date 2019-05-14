//
//  YHImageBrowserCellProtocol.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/14.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHImageBrowserDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * cell协议
 */
@protocol YHImageBrowserCellProtocol <NSObject>

@required;

- (void)yh_setCellData:(id<YHImageBrowserDataProtocol>)data;





@end

NS_ASSUME_NONNULL_END
