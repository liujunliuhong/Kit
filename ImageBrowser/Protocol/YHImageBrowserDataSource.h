//
//  YHImageBrowserDataSource.h
//  HiFanSmooth
//
//  Created by 银河 on 2019/5/18.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YHImageBrowser;
@protocol YHImageBrowserDataSource <NSObject>
@required;
// item个数
- (NSUInteger)numberOfCellForImageBrowser:(YHImageBrowser *)imageBrowser;

// item所属data赋值
- (id<YHImageBrowserCellDataProtocol>)imageBrowser:(YHImageBrowser *)imageBrowser dataForCellAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
