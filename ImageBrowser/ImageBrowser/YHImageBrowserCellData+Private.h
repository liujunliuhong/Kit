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
    YHImageBrowserCellDataState_Invalid,
    YHImageBrowserCellDataState_ImageReady,
    YHImageBrowserCellDataState_CompressImageReady,
    YHImageBrowserCellDataState_IsCompressingImage,
    YHImageBrowserCellDataState_CompressImageComplete,
    
    YHImageBrowserCellDataState_IsDecoding,
    YHImageBrowserCellDataState_DecodeComplete,
    
    YHImageBrowserCellDataState_IsQueryingCache,
    YHImageBrowserCellDataState_QueryCacheComplete,
};


@interface YHImageBrowserCellData ()

@property (nonatomic, strong) UIImage *compressImage;

@property (nonatomic, assign) YHImageBrowserCellDataState dataState;


@end

NS_ASSUME_NONNULL_END
