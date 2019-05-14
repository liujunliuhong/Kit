//
//  YHImageBrowserCellData.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/14.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YHImageBrowserDataProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHImageBrowserCellData : NSObject <YHImageBrowserDataProtocol>

@property (nonatomic, strong, nullable) NSURL *URL;

@property (nonatomic, strong, nullable) UIImage *thumbImage;

@property (nonatomic, strong, nullable) NSURL *thumbURL;


- (void)loadData;

@end

NS_ASSUME_NONNULL_END
