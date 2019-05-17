//
//  YHImageBrowserCellData+Private.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/15.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHImageBrowserCellData.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, YHImageBrowserCellDataState) {
    YHImageBrowserCellDataState_Invalid,                    // 非法图片
    
    YHImageBrowserCellDataState_ImageReady,                 // YHImage准备好了
    
    YHImageBrowserCellDataState_ThumbImageReady,            // 缩略图准备好了，此时可以显示缩略图
    
    YHImageBrowserCellDataState_CompressImageReady,         // 压缩图片准备好了，此时可以显示压缩图片
    
    YHImageBrowserCellDataState_IsCompressingImage,         // 正在压缩图片
    YHImageBrowserCellDataState_CompressImageComplete,      // 图片压缩完成
    
    YHImageBrowserCellDataState_IsDecoding,                 //  正在解码本地图片
    YHImageBrowserCellDataState_DecodeComplete,             // 本地图片解码完成
    
    YHImageBrowserCellDataState_IsQueryingCache,            // 正在查询本地缓存
    YHImageBrowserCellDataState_QueryCacheComplete,         // 本地缓存查询完成
    
    YHImageBrowserCellDataState_DownloadReady,              // 准备下载图片
    YHImageBrowserCellDataState_IsDownloading,              // 图片下载中(此时有下载进度)
    YHImageBrowserCellDataState_DownloadSuccess,            // 图片下载成功
    YHImageBrowserCellDataState_DownloadFailed,             // 图片下载失败
};


@interface YHImageBrowserCellData ()

@property (nonatomic, strong) UIImage *compressImage;
@property (nonatomic, assign) CGFloat downloadProgress;

@property (nonatomic, assign) YHImageBrowserCellDataState dataState;


@property (nonatomic, strong) YHImage *image;


- (void)loadData;

@end

NS_ASSUME_NONNULL_END
