//
//  YHImageBrowserWebImageManager.m
//  HiFanSmooth
//
//  Created by apple on 2019/5/14.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHImageBrowserWebImageManager.h"

#if __has_include(<SDWebImage/SDWebImage.h>)
    #import <SDWebImage/SDWebImage.h>
#elif __has_include("SDWebImage.h")
    #import "SDWebImage.h"
#endif

#if __has_include(<SDWebImageWebPCoder/SDWebImageWebPCoder.h>)
    #import <SDWebImageWebPCoder/SDWebImageWebPCoder.h>
#elif __has_include("SDWebImageWebPCoder.h")
    #import "SDWebImageWebPCoder.h"
#endif


@implementation YHImageBrowserWebImageManager

+ (void)initialize{
    
}

+ (void)queryCacheImageWithKey:(NSURL *)key
               completionBlock:(QueryCacheCompletionBlock)completionBlock{
    
    NSString *cacheKey = [[SDWebImageManager sharedManager] cacheKeyForURL:key];
    
    if (!cacheKey) {
        if (completionBlock) {
            completionBlock(nil, nil);
        }
        return;
    }
    
    [[SDImageCache sharedImageCache] queryCacheOperationForKey:cacheKey done:^(UIImage * _Nullable image, NSData * _Nullable data, SDImageCacheType cacheType) {
        if (completionBlock) {
            completionBlock(image, data);
        }
    }];
}


+ (id)downloadImageWithURL:(NSURL *)URL
             progressBlock:(DownloadProgressBlock)progressBlock
              successBlock:(DownloadSuccessBlock)successBlock
                errorBlock:(DownloadErrorBlock)errorBlock{
    // 适配SDImageWeb 5.0版本
#if __has_include(<SDWebImageWebPCoder/SDWebImageWebPCoder.h>) || __has_include("SDWebImageWebPCoder.h")
    SDImageWebPCoder *webPCoder = [SDImageWebPCoder sharedCoder];
    if (![[SDImageCodersManager sharedManager].coders containsObject:webPCoder]) {
        [[SDImageCodersManager sharedManager] addCoder:webPCoder];
    }
#endif
    SDWebImageDownloadToken *token = [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:URL options:SDWebImageDownloaderLowPriority context:nil progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if (progressBlock) {
            progressBlock(receivedSize, expectedSize, targetURL);
        }
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
        if (error) {
            if (errorBlock) {
                errorBlock(error, finished);
                return ;
            }
        }
        if (successBlock) {
            successBlock(image, data, finished);
        }
    }];
    return token;
}


+ (void)cancelDownloadWithDownloadToken:(id)token{
    if (token && [token isKindOfClass:[SDWebImageDownloadToken class]]) {
        SDWebImageDownloadToken *downloadToken = token;
        [downloadToken cancel];
    }
}


+ (void)storeImage:(UIImage *)image
         imageData:(NSData *)data
            forKey:(NSURL *)key
            toDisk:(BOOL)toDisk{
    if (!key) {
        return;
    }
    NSString *cacheKey = [[SDWebImageManager sharedManager] cacheKeyForURL:key];
    if (!cacheKey) {
        return;
    }
    
    [[SDImageCache sharedImageCache] storeImage:image imageData:data forKey:cacheKey toDisk:toDisk completion:nil];
}

@end
