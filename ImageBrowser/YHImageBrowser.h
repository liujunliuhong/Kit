//
//  YHImageBrowser.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/16.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHImageBrowserCellDataProtocol.h"
#import "YHImageBrowserCellData.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHImageBrowser : UIView

@property (nonatomic, strong) NSArray<id<YHImageBrowserCellDataProtocol>> *dataSourceArray;

- (void)show;

@end

NS_ASSUME_NONNULL_END
