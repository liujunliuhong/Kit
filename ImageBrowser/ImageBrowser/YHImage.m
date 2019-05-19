//
//  YHImage.m
//  HiFanSmooth
//
//  Created by apple on 2019/5/15.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHImage.h"

#if __has_include(<SDWebImage/UIImage+MultiFormat.h>)
    #import <SDWebImage/UIImage+MultiFormat.h>
#elif __has_include("UIImage+MultiFormat.h")
    #import "UIImage+MultiFormat.h"
#endif

#import "YHImage+Private.h"

@interface YHImage()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) FLAnimatedImage *animatedImage;
@end

@implementation YHImage

static NSArray *_NSBundlePreferredScales() {
    static NSArray *scales;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenScale = [UIScreen mainScreen].scale;
        if (screenScale <= 1) {
            scales = @[@1,@2,@3];
        } else if (screenScale <= 2) {
            scales = @[@2,@3,@1];
        } else {
            scales = @[@3,@2,@1];
        }
    });
    return scales;
}

static NSString *_NSStringByAppendingNameScale(NSString *string, CGFloat scale) {
    if (!string) return nil;
    if (fabs(scale - 1) <= __FLT_EPSILON__ || string.length == 0 || [string hasSuffix:@"/"]) return string.copy;
    return [string stringByAppendingFormat:@"@%@x", @(scale)];
}


+ (YHImage *)imageWithData:(NSData *)data{
    return [[self alloc] initDownloadWithImage:nil imageData:data];
}

+ (YHImage *)imageWithContentsOfFile:(NSString *)path{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    return [[self alloc] initDownloadWithImage:image imageData:nil];
}

+ (YHImage *)imageWithImage:(UIImage *)image{
    return [[self alloc] initDownloadWithImage:image imageData:nil];
}

+ (YHImage *)imageNamed:(NSString *)name{
    if (name.length == 0) return nil;
    if ([name hasSuffix:@"/"]) return nil;
    
    NSString *res = name.stringByDeletingPathExtension;
    NSString *ext = name.pathExtension;
    NSString *path = nil;
    CGFloat scale = 1;
    
    // If no extension, guess by system supported (same as UIImage).
    NSArray *exts = ext.length > 0 ? @[ext] : @[@"", @"png", @"jpeg", @"jpg", @"gif", @"webp", @"apng"];
    NSArray *scales = _NSBundlePreferredScales();
    for (int s = 0; s < scales.count; s++) {
        scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = _NSStringByAppendingNameScale(res, scale);
        for (NSString *e in exts) {
            path = [[NSBundle mainBundle] pathForResource:scaledName ofType:e];
            if (path) break;
        }
        if (path) break;
    }
    if (path.length == 0) {
        // Support Assets.xcassets.
        UIImage *image = [UIImage imageNamed:name];
        return [[self alloc] initDownloadWithImage:image imageData:nil];
    }
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data.length == 0) return nil;
    return [[self alloc] initDownloadWithImage:nil imageData:data];
}


- (instancetype)initDownloadWithImage:(UIImage *)image imageData:(NSData *)imageData{
    self = [super init];
    if (self) {
        BOOL isGIF = [NSData sd_imageFormatForImageData:imageData] == SDImageFormatGIF;
        if (isGIF) {
            FLAnimatedImage *animatedImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:imageData];
            if (animatedImage) {
                self.image = animatedImage.posterImage;
                self.animatedImage = animatedImage;
            } else {
                UIImage *tmpImage = [UIImage imageWithData:imageData];
                self.image = tmpImage ? tmpImage : image;
                self.animatedImage = nil;
            }
        } else {
            UIImage *tmpImage = [UIImage imageWithData:imageData];
            self.image = tmpImage ? tmpImage : image;
            self.animatedImage = nil;
        }
    }
    return self;
}


@end
