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

typedef void(^QueryCacheCompletionBlock)(UIImage *_Nullable image, NSData *_Nullable data);
typedef void(^DownloadProgressBlock)(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL);
typedef void(^DownloadSuccessBlock)(UIImage * _Nullable image, NSData * _Nullable data, BOOL finished);
typedef void(^DownloadErrorBlock)(NSError * _Nullable error, BOOL finished);

@interface YHImageBrowserWebImageManager : NSObject


+ (void)queryCacheImageWithKey:(NSURL *)key
               completionBlock:(nullable QueryCacheCompletionBlock)completionBlock;


+ (id)downloadImageWithURL:(NSURL *)URL
             progressBlock:(nullable DownloadProgressBlock)progressBlock
              successBlock:(nullable DownloadSuccessBlock)successBlock
                errorBlock:(nullable DownloadErrorBlock)errorBlock;

+ (void)cancelDownloadWithDownloadToken:(id)token;

+ (void)storeImage:(nullable UIImage *)image
         imageData:(nullable NSData *)data
            forKey:(NSURL *)key toDisk:(BOOL)toDisk;

@end

NS_ASSUME_NONNULL_END
