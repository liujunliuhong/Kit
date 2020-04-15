//
//  YHImageBrowserCellData.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/14.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "YHImageBrowserCellDataProtocol.h"
#import "YHImage.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHImageBrowserCellData : NSObject <YHImageBrowserCellDataProtocol>
/**
 * 网络图片链接
 */
@property (nonatomic, strong, nullable) NSURL *imageURL;

/**
 * 缩略图
 */
@property (nonatomic, strong, nullable) UIImage *thumbImage;

/**
 * 缩略图链接(不会去下载缩略图，只是根据缩略图链接去本地缓存查找是否有该图片，有就显示)
 */
@property (nonatomic, strong, nullable) NSURL *thumbURL;

/**
 * 本地图片
 */
@property (nonatomic, copy, nullable) YHImage *(^localImageBlock)(void);


/**
 * 最终的YHImage对象
 */
@property (nonatomic, strong, readonly) YHImage *image;

@end

NS_ASSUME_NONNULL_END
