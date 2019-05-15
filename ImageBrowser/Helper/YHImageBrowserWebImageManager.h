//
//  YHImageBrowserWebImageManager.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/14.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHImageBrowserWebImageManager : NSObject


+ (void)queryCacheImageWithKey:(NSURL *)key
               completionBlock:(void(^_Nullable)(UIImage *_Nullable image, NSData *_Nullable data))completionBlock;


+ (id)downloadImageWithURL:(NSURL *)URL
                                    progressBlock:(void(^_Nullable)(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL))progressBlock
                                          successBlock:(void(^_Nullable)(UIImage * _Nullable image, NSData * _Nullable data, BOOL finished))successBlock
                                           errorBlock:(void(^_Nullable)(NSError * _Nullable error, BOOL finished))errorBlock;

+ (void)cancelDownloadWithDownloadToken:(id)token;

+ (void)storeImage:(nullable UIImage *)image imageData:(nullable NSData *)data forKey:(NSURL *)key toDisk:(BOOL)toDisk;

@end

NS_ASSUME_NONNULL_END
