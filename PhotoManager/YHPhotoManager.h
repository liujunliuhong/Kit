//
//  YHPhotoManager.h
//  HiFanSmooth
//
//  Created by 银河 on 2019/5/19.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN
@interface YHPhotoManager : NSObject

/**
 * 检查某个相册是否存在，一般是自定义相册名
 */
+ (void)checkAlbumIsExistWithAlbum:(NSString *)albumName completionBlock:(void(^)(BOOL isExist))completionBlock;

/**
 * 创建一个自定义相册
 */
+ (void)createAlbum:(NSString *)albumName completionBlock:(void(^)(BOOL isSuccess, PHAssetCollection *_Nullable assetCollection))completionBlock;

/**
 * 根据相册名字获取PHAssetCollection相册实例，如果没有给定相册名字的相册，则会新建
 */
+ (void)getAlbumWithAlbum:(NSString *)albumName completionBlock:(void(^)(PHAssetCollection *_Nullable assetCollection))completionBlock;

/**
 * 把data存进相册，支持Image和GIF
 */
+ (void)saveToPhotoAlbumWithAlbumName:(NSString *)albumName data:(NSData *)data completionBlock:(void(^_Nullable)(BOOL isSuccess, NSError *_Nullable error))completionBlock;

/**
 * 把Image存进相册
 */
+ (void)saveToPhotoAlbumWithAlbumName:(NSString *)albumName image:(UIImage *)image completionBlock:(void(^_Nullable)(BOOL isSuccess, NSError *_Nullable error))completionBlock;



// 把图片压缩到指定尺寸
+ (nullable NSData *)compressImageWithImage1:(UIImage *)sourceImage toByte:(NSUInteger)maxSize; // 第一种方法
+ (nullable NSData *)compressImageWithImage2:(UIImage *)sourceImage toByte:(NSUInteger)maxSize; // 第二种方法



@end

NS_ASSUME_NONNULL_END
