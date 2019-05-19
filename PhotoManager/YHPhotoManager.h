//
//  YHPhotoManager.h
//  HiFanSmooth
//
//  Created by 银河 on 2019/5/19.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class PHAssetCollection;
@interface YHPhotoManager : NSObject

/**
 * 检查某个相册是否存在，一般是自定义相册名
 */
+ (void)checkAlbumIsExistWithAlbum:(NSString *)albumName completionBlock:(void(^)(BOOL isExist))completionBlock;

/**
 * 创建一个自定义相册
 */
+ (void)createAlbum:(NSString *)albumName completionBlock:(void(^)(BOOL isSuccess, PHAssetCollection *_Nullable assetCollection))completionBlock;



@end

NS_ASSUME_NONNULL_END
