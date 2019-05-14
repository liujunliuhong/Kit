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


+ (void)queryCacheImageWithKey:(NSURL *)key completionBlock:(void(^_Nullable)(UIImage *_Nullable image, NSData *_Nullable data))completionBlock;


@end

NS_ASSUME_NONNULL_END
