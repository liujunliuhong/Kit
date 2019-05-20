//
//  YHImageBrowserCellData.m
//  HiFanSmooth
//
//  Created by apple on 2019/5/14.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHImageBrowserCellData.h"

#if __has_include(<FLAnimatedImage/FLAnimatedImage.h>)
    #import <FLAnimatedImage/FLAnimatedImage.h>
#elif __has_include("FLAnimatedImage.h")
    #import "FLAnimatedImage.h"
#endif

#import "YHImageBrowserDefine.h"
#import "YHImageBrowserWebImageManager.h"
#import "YHImageBrowserCell.h"
#import "YHImageBrowserCellData+Private.h"
#import "YHImage+Private.h"

#import "YHAuthorizetion.h"
#import "YHPhotoManager.h"
#import "YHMBHud.h"

#define kMaxImageSize     CGSizeMake(4096.0, 4096.0)


@interface YHImageBrowserCellData() {
    __weak id _downloadToken;
}

@property (nonatomic, strong) YHImage *image;

@end


@implementation YHImageBrowserCellData

- (void)dealloc
{
    if (_downloadToken) {
        [YHImageBrowserWebImageManager cancelDownloadWithDownloadToken:_downloadToken];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isLoading = NO;
    }
    return self;
}



- (void)loadData{
    if (self.isLoading) {
        // 目的是为了触发来回滑动时，触发KVO监听
        YHImageBrowserCellDataState tmpState = self.dataState;
        self.dataState = tmpState;
        return;
    }
    
    self.isLoading = YES;
   
    if (self.image) {
        // 检查是否需要压缩
        [self checkCompressWithCompletionBlock:^{
            self.isLoading = NO;
        }];
        return;
    } else if (self.localImageBlock) {
        [self loadThumbImageWithCompletionBlock:^{
            [self decodeLocalImageWithCompletionBlock:^{
                [self checkCompressWithCompletionBlock:^{
                    self.isLoading = NO;
                }];
            }];
        }];
        return;
    } else if (self.imageURL) {
        [self loadThumbImageWithCompletionBlock:^{
            [self queryImageCacheWithCompletionBlock:^{
                if (!self.image.image && !self.image.animatedImage) {
                    [self downLoadImageWithCompletionBlock:^{
                        [self checkCompressWithCompletionBlock:^{
                            self.isLoading = NO;
                        }];
                    }];
                } else {
                    [self checkCompressWithCompletionBlock:^{
                        self.isLoading = NO;
                    }];
                }
            }];
        }];
        return;
    } else {
        // 什么都不存在
        self.dataState = YHImageBrowserCellDataState_Invalid;
        self.isLoading = NO;
    }
}

// 检查图片是否需要压缩
- (void)checkCompressWithCompletionBlock:(void(^)(void))completionBlock{
    if (!self.image) {
        self.dataState = YHImageBrowserCellDataState_ImageReady;
        if (completionBlock) {
            completionBlock();
        }
        return;
    }
    BOOL isNeedCompressImage = [self isNeedCompressImage];
    if (isNeedCompressImage) {
        if (self.compressImage) {
            self.dataState = YHImageBrowserCellDataState_CompressImageReady;
            if (completionBlock) {
                completionBlock();
            }
        } else {
            [self compressedImageWithCompletionBlock:^{
                if (completionBlock) {
                    completionBlock();
                }
            }];
        }
    } else {
        self.dataState = YHImageBrowserCellDataState_ImageReady;
        if (completionBlock) {
            completionBlock();
        }
    }
}

// 压缩图片
- (void)compressedImageWithCompletionBlock:(void(^)(void))completionBlock{
    if (!self.image || !self.image.image) {
        if (completionBlock) {
            completionBlock();
        }
        return;
    }
    self.dataState = YHImageBrowserCellDataState_IsCompressingImage;
    
    YHImageBrowserAsync(dispatch_get_global_queue(0, 0), ^{
        
        // ... 压缩中(暂未完成)
        self.compressImage = self.image.image;
        
        YHImageBrowserAsync(dispatch_get_main_queue(), ^{
            self.dataState = YHImageBrowserCellDataState_CompressImageComplete;
            if (completionBlock) {
                completionBlock();
            }
        });
    });
}


// 加载缩略图片
- (void)loadThumbImageWithCompletionBlock:(void(^)(void))completionBlock{
    if (self.thumbImage) {
        self.dataState = YHImageBrowserCellDataState_ThumbImageReady;
        if (completionBlock) {
            completionBlock();
        }
    } else if (self.thumbURL) {
        // 根据thumbURL查询缓存
        [YHImageBrowserWebImageManager queryCacheImageWithKey:self.thumbURL completionBlock:^(UIImage * _Nullable image, NSData * _Nullable data) {
            UIImage *tmpImage = [UIImage imageWithData:data];
            self.thumbImage = tmpImage ? tmpImage : image;
            self.dataState = YHImageBrowserCellDataState_ThumbImageReady;
            if (completionBlock) {
                completionBlock();
            }
        }];
    } else {
        if (completionBlock) {
            completionBlock();
        }
    }
}

// 解码本地图片
- (void)decodeLocalImageWithCompletionBlock:(void(^)(void))completionBlock{
    if (!self.localImageBlock) {
        if (completionBlock) {
            completionBlock();
        }
        return;
    }
    self.dataState = YHImageBrowserCellDataState_IsDecoding;
    YHImageBrowserAsync(dispatch_get_global_queue(0, 0), ^{
        self.image = self.localImageBlock();
        YHImageBrowserAsync(dispatch_get_main_queue(), ^{
            self.dataState = YHImageBrowserCellDataState_DecodeComplete;
            if (completionBlock) {
                completionBlock();
            }
        });
    });
}

// 查询缓存图片
- (void)queryImageCacheWithCompletionBlock:(void(^)(void))completionBlock{
    if (!self.imageURL) {
        if (completionBlock) {
            completionBlock();
        }
        return;
    }
    self.dataState = YHImageBrowserCellDataState_IsQueryingCache;
    [YHImageBrowserWebImageManager queryCacheImageWithKey:self.imageURL completionBlock:^(UIImage * _Nullable image, NSData * _Nullable data) {
        YHImageBrowserAsync(dispatch_get_global_queue(0, 0), ^{
            self.image = [[YHImage alloc] initDownloadWithImage:image imageData:data];
            YHImageBrowserAsync(dispatch_get_main_queue(), ^{
                self.dataState = YHImageBrowserCellDataState_QueryCacheComplete;
                if (completionBlock) {
                    completionBlock();
                }
            });
        });
    }];
}


// 下载图片
- (void)downLoadImageWithCompletionBlock:(void(^)(void))completionBlock{
    if (!self.imageURL) {
        if (completionBlock) {
            completionBlock();
        }
        return;
    }
    self.dataState = YHImageBrowserCellDataState_DownloadReady;
    _downloadToken = [YHImageBrowserWebImageManager downloadImageWithURL:self.imageURL progressBlock:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        YHImageBrowserAsync(dispatch_get_main_queue(), ^{
            self.dataState = YHImageBrowserCellDataState_IsDownloading;
            CGFloat value = 0.0;
            if (expectedSize > 0) {
                value = receivedSize * 1.0 / expectedSize;
            }
            //NSLog(@"☁️:%.2f", value);
            self.downloadProgress = value;
        });
    } successBlock:^(UIImage * _Nullable image, NSData * _Nullable data, BOOL finished) {
        if (!finished) {
            return ;
        }
        YHImageBrowserAsync(dispatch_get_global_queue(0, 0), ^{
            self.image = [[YHImage alloc] initDownloadWithImage:image imageData:data];
            YHImageBrowserAsync(dispatch_get_main_queue(), ^{
                [YHImageBrowserWebImageManager storeImage:image imageData:data forKey:self.imageURL toDisk:YES];
                self.dataState = YHImageBrowserCellDataState_DownloadSuccess;
                if (completionBlock) {
                    completionBlock();
                }
            });
        });
        
    } errorBlock:^(NSError * _Nullable error, BOOL finished) {
        if (!finished) {
            return ;
        }
        self.dataState = YHImageBrowserCellDataState_DownloadFailed;
        if (completionBlock) {
            completionBlock();
        }
    }];
}





// 判断是否需要压缩图片
- (BOOL)isNeedCompressImage{
    if (!self.image) {
        return NO;
    }
    if (self.image.animatedImage) {
        // GIF暂时不需要压缩，后期再做GIF的压缩
        return NO;
    } else if (self.image.image) {
        if (kMaxImageSize.width * kMaxImageSize.height < (self.image.image.size.width * self.image.image.scale) * (self.image.image.size.height * self.image.image.scale)) {
            return YES;
        } else {
            return NO;
        }
    }
    return NO;
}





#pragma mark ------------------ YHImageBrowserCellDataProtocol ------------------
- (Class)yh_cellClass{
    return [YHImageBrowserCell class];
    
}

- (void)yh_saveToPhotoAlblum:(NSString *)photoAlblumName{
    [YHAuthorizetion requestAuthorizetionWithType:YHAuthorizetionType_Photos completion:^(BOOL granted, BOOL isFirst) {
        if (granted) {
            if (self.image.animatedImage) {
                [YHPhotoManager saveToPhotoAlbumWithAlbumName:photoAlblumName data:self.image.animatedImage.data completionBlock:^(BOOL isSuccess, NSError * _Nullable error) {
                    if (isSuccess) {
                        YH_MB_HUD_Tip(@"保存成功");
                    } else {
                        YH_MB_HUD_Tip(@"保存失败");
                    }
                }];
            } else if (self.image.image) {
                [YHPhotoManager saveToPhotoAlbumWithAlbumName:photoAlblumName image:self.image.image completionBlock:^(BOOL isSuccess, NSError * _Nullable error) {
                    if (isSuccess) {
                        YH_MB_HUD_Tip(@"保存成功");
                    } else {
                        YH_MB_HUD_Tip(@"保存失败");
                    }
                }];
            } else {
                YH_MB_HUD_Tip(@"保存失败");
            }
        } else {
            YH_MB_HUD_Tip(@"保存失败，请在\"设置\"中打开相册授权");
        }
    }];
}

@end
