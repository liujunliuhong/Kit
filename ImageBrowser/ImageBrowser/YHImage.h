//
//  YHImage.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/15.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <FLAnimatedImage/FLAnimatedImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHImage : NSObject

@property (nonatomic, strong, readonly, nullable) UIImage *image;
@property (nonatomic, strong, readonly, nullable) FLAnimatedImage *animatedImage;

+ (YHImage *)imageNamed:(NSString *)name;
+ (YHImage *)imageWithImage:(UIImage *)image;
+ (YHImage *)imageWithData:(NSData *)data;
+ (YHImage *)imageWithContentsOfFile:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
