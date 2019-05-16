//
//  YHImageBrowserCellData.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/14.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "YHImageBrowserCellDataProtocol.h"
#import "YHImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHImageBrowserCellData : NSObject <YHImageBrowserCellDataProtocol>

@property (nonatomic, strong, nullable) NSURL *URL;

@property (nonatomic, strong, nullable) UIImage *thumbImage;

@property (nonatomic, strong, nullable) NSURL *thumbURL;

@property (nonatomic, copy, nullable) YHImage *(^localImageBlock)(void);


@property (nonatomic, strong, readonly) YHImage *image;






@end

NS_ASSUME_NONNULL_END
