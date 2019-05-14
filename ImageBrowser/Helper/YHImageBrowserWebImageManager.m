//
//  YHImageBrowserWebImageManager.m
//  HiFanSmooth
//
//  Created by apple on 2019/5/14.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHImageBrowserWebImageManager.h"

#import <SDWebImage/SDWebImageManager.h>


@implementation YHImageBrowserWebImageManager

+ (void)queryCacheImageWithKey:(NSURL *)key completionBlock:(void (^)(UIImage * _Nullable, NSData * _Nullable))completionBlock{
    
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


@end
