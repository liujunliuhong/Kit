//
//  YHImageBrowserCellData.m
//  HiFanSmooth
//
//  Created by apple on 2019/5/14.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHImageBrowserCellData.h"

#import <FLAnimatedImage/FLAnimatedImage.h>

#import "YHImageBrowserWebImageManager.h"
#import "YHImageBrowserCell.h"

#import "YHImageBrowserCellData+Private.h"

static CGSize kMaxImageSize = (CGSize){4096, 4096};

@interface YHImageBrowserCellData()
@property (nonatomic, assign) BOOL isLoading;


@property (nonatomic, strong) YHImage *image;

@end


@implementation YHImageBrowserCellData



- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



- (void)loadData{
    
    
    if (self.image) {
        
    } else if (self.localImageBlock) {
        
    } else if (self.URL) {
        
    } else if (self.thumbURL) {
        
    }
}


- (void)loadNetworkImage{
    if (!self.URL) {
        return;
    }
    
    [YHImageBrowserWebImageManager queryCacheImageWithKey:self.URL completionBlock:^(UIImage * _Nullable image, NSData * _Nullable data) {
        
    }];
    
}

- (void)loadLocalImage{
    if (!self.image) {
        return;
    }
    BOOL isNeedCompressImage = [self isNeedCompressImage];
    if (isNeedCompressImage) {
        if (self.compressImage) {
            
        } else {
            [self compressedImage];
        }
    } else {
        self.dataState = YHImageBrowserCellDataState_ImageReady;
    }
}


- (void)decodeLocalImage{
    if (!self.localImageBlock) {
        return;
    }
    self.dataState = YHImageBrowserCellDataState_IsDecoding;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.image = self.localImageBlock();
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataState = YHImageBrowserCellDataState_DecodeComplete;
            if (self.image) {
                [self loadLocalImage];
            }
        });
    });
}


// 判断是否需要压缩图片
- (BOOL)isNeedCompressImage{
    if (!self.image) {
        return NO;
    }
    if (kMaxImageSize.width * kMaxImageSize.height < (self.image.size.width * self.image.scale) * (self.image.size.height * self.image.scale)) {
        return YES;
    }
    return NO;
}

// 压缩图片
- (void)compressedImage{
    
}


#pragma mark ------------------ YHImageBrowserDataProtocol ------------------
- (Class)yh_cellClass{
    return [YHImageBrowserCell class];
}


@end
