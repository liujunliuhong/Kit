//
//  YHImage+Private.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/16.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHImage.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHImage ()

- (instancetype)initDownloadWithImage:(nullable UIImage *)image imageData:(nullable NSData *)imageData;

@end

NS_ASSUME_NONNULL_END
