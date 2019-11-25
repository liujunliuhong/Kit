//
//  YHPhotoManager.m
//  HiFanSmooth
//
//  Created by 银河 on 2019/5/19.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHPhotoManager.h"
#import <ImageIO/ImageIO.h>

@implementation YHPhotoManager
+ (void)checkAlbumIsExistWithAlbum:(NSString *)albumName completionBlock:(void (^)(BOOL))completionBlock{
    PHFetchResult *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    __block PHAssetCollection *createCollection = nil;
    for (PHAssetCollection *collection in collections)  {
        if ([collection.localizedTitle isEqualToString:albumName]) {
            createCollection = collection;
            break;
        }
    }
    if (completionBlock) {
        completionBlock(createCollection ? YES : NO);
    }
}


+ (void)createAlbum:(NSString *)albumName completionBlock:(void (^)(BOOL, PHAssetCollection * _Nullable))completionBlock{
    NSError *error = nil;
    __block NSString *collectionId = nil;
    BOOL res = [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];
    
    if (!error && res && collectionId) {
        PHAssetCollection *assetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].firstObject;
        if (completionBlock) {
            completionBlock(YES, assetCollection);
        }
    } else {
        if (completionBlock) {
            completionBlock(NO, nil);
        }
    }
}

+ (void)getAlbumWithAlbum:(NSString *)albumName completionBlock:(void (^)(PHAssetCollection * _Nullable))completionBlock{
    PHFetchResult *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    __block PHAssetCollection *createCollection = nil;
    __block NSString *collectionID = nil;
    for (PHAssetCollection *collection in collections)  {
        if ([collection.localizedTitle isEqualToString:albumName]) {
            createCollection = collection;
            break;
        }
    }
    NSError *error = nil;
    if (!createCollection) {
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            collectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:albumName].placeholderForCreatedAssetCollection.localIdentifier;
        } error:&error];
        createCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionID] options:nil].firstObject;
    }
    if (completionBlock) {
        completionBlock(createCollection);
    }
}


+ (void)saveToPhotoAlbumWithAlbumName:(NSString *)albumName data:(NSData *)data completionBlock:(void (^ _Nullable)(BOOL, NSError * _Nullable))completionBlock{
    [YHPhotoManager getAlbumWithAlbum:albumName completionBlock:^(PHAssetCollection * _Nullable assetCollection) {
        if (assetCollection) {
            __block NSString *assetId = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetCreationRequest *creationRequest = [PHAssetCreationRequest creationRequestForAsset];
                [creationRequest addResourceWithType:PHAssetResourceTypePhoto data:data options:nil];
                assetId = creationRequest.placeholderForCreatedAsset.localIdentifier;
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                        PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
                        [request addAssets:@[asset]];
                    } completionHandler:^(BOOL success, NSError * _Nullable error) {
                        if (success) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (completionBlock) {
                                    completionBlock(YES, nil);
                                }
                            });
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (completionBlock) {
                                    completionBlock(NO, error);
                                }
                            });
                        }
                    }];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completionBlock) {
                            completionBlock(NO, error);
                        }
                    });
                }
            }];
        }
    }];
}

+ (void)saveToPhotoAlbumWithAlbumName:(NSString *)albumName image:(UIImage *)image completionBlock:(void (^)(BOOL, NSError * _Nullable))completionBlock{
    [YHPhotoManager getAlbumWithAlbum:albumName completionBlock:^(PHAssetCollection * _Nullable assetCollection) {
        if (assetCollection) {
            __block NSString *assetId = nil;
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                assetId = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
                        PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
                        [request addAssets:@[asset]];
                    } completionHandler:^(BOOL success, NSError * _Nullable error) {
                        if (success) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (completionBlock) {
                                    completionBlock(YES, nil);
                                }
                            });
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (completionBlock) {
                                    completionBlock(NO, error);
                                }
                            });
                        }
                    }];
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completionBlock) {
                            completionBlock(NO, error);
                        }
                    });
                }
            }];
        }
    }];
}



+ (NSData *)compressImageWithImage1:(UIImage *)sourceImage toByte:(NSUInteger)maxSize{
    //先判断当前质量是否满足要求，不满足再进行压缩
    __block NSData *finallImageData = UIImageJPEGRepresentation(sourceImage,1.0);
    NSUInteger sizeOrigin   = finallImageData.length;
    NSUInteger sizeOriginKB = sizeOrigin / 1000;
    
    if (sizeOriginKB <= maxSize) {
        return finallImageData;
    }
    
    //获取原图片宽高比
    CGFloat sourceImageAspectRatio = sourceImage.size.width/sourceImage.size.height;
    //先调整分辨率
    CGSize defaultSize = CGSizeMake(1024, 1024/sourceImageAspectRatio);
    UIImage *newImage = [self newSizeImage:defaultSize image:sourceImage];
    
    finallImageData = UIImageJPEGRepresentation(newImage,1.0);
    
    //保存压缩系数
    NSMutableArray *compressionQualityArr = [NSMutableArray array];
    CGFloat avg   = 1.0/250;
    CGFloat value = avg;
    for (int i = 250; i >= 1; i--) {
        value = i*avg;
        [compressionQualityArr addObject:@(value)];
    }
    
    /*
     调整大小
     说明：压缩系数数组compressionQualityArr是从大到小存储。
     */
    //思路：使用二分法搜索
    __block NSData *canCompressMinData = [NSData data];//当无法压缩到指定大小时，用于存储当前能够压缩到的最小值数据。
    [self halfFuntion:compressionQualityArr image:newImage sourceData:finallImageData maxSize:maxSize resultBlock:^(NSData *finallData, NSData *tempData) {
        finallImageData = finallData;
        canCompressMinData = tempData;
    }];
    //如果还是未能压缩到指定大小，则进行降分辨率
    while (finallImageData.length == 0) {
        //每次降100分辨率
        CGFloat reduceWidth = 100.0;
        CGFloat reduceHeight = 100.0/sourceImageAspectRatio;
        if (defaultSize.width-reduceWidth <= 0 || defaultSize.height-reduceHeight <= 0) {
            break;
        }
        defaultSize = CGSizeMake(defaultSize.width-reduceWidth, defaultSize.height-reduceHeight);
        UIImage *image = [self newSizeImage:defaultSize
                                      image:[UIImage imageWithData:UIImageJPEGRepresentation(newImage,[[compressionQualityArr lastObject] floatValue])]];
        [self halfFuntion:compressionQualityArr image:image sourceData:UIImageJPEGRepresentation(image,1.0) maxSize:maxSize resultBlock:^(NSData *finallData, NSData *tempData) {
            finallImageData = finallData;
            canCompressMinData = tempData;
        }];
    }
    //如果分辨率已经无法再降低，则直接使用能够压缩的那个最小值即可
    if (finallImageData.length==0) {
        finallImageData = canCompressMinData;
    }
    return finallImageData;
}


#pragma mark 调整图片分辨率/尺寸（等比例缩放）
///调整图片分辨率/尺寸（等比例缩放）
+ (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)sourceImage {
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    //    UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark 二分法
///二分法，block回调中finallData长度不为零表示最终压缩到了指定的大小，如果为零则表示压缩不到指定大小。tempData表示当前能够压缩到的最小值。
+ (void)halfFuntion:(NSArray *)arr image:(UIImage *)image sourceData:(NSData *)finallImageData maxSize:(NSInteger)maxSize resultBlock:(void(^)(NSData *finallData, NSData *tempData))block {
    NSData *tempData = [NSData data];
    NSUInteger start = 0;
    NSUInteger end = arr.count - 1;
    NSUInteger index = 0;
    
    NSUInteger difference = NSIntegerMax;
    while(start <= end) {
        index = start + (end - start)/2;
        
        finallImageData = UIImageJPEGRepresentation(image,[arr[index] floatValue]);
        
        NSUInteger sizeOrigin = finallImageData.length;
        NSUInteger sizeOriginKB = sizeOrigin / 1000;
        NSLog(@"当前降到的质量：%ld", (unsigned long)sizeOriginKB);
        //        NSLog(@"\nstart：%zd\nend：%zd\nindex：%zd\n压缩系数：%lf", start, end, (unsigned long)index, [arr[index] floatValue]);
        
        if (sizeOriginKB > maxSize) {
            start = index + 1;
        } else if (sizeOriginKB < maxSize) {
            if (maxSize-sizeOriginKB < difference) {
                difference = maxSize-sizeOriginKB;
                tempData = finallImageData;
            }
            if (index<=0) {
                break;
            }
            end = index - 1;
        } else {
            break;
        }
    }
    NSData *d = [NSData data];
    if (tempData.length==0) {
        d = finallImageData;
    }
    if (block) {
        block(tempData, d);
    }
//    return tempData;
}











+ (NSData *)compressImageWithImage2:(UIImage *)sourceImage toByte:(NSUInteger)maxSize{
    if (!sourceImage) {
        return nil;
    }
    //二分法压缩图片
    CGFloat compression = 1;
    NSData *imageData = UIImageJPEGRepresentation(sourceImage, compression);
    NSUInteger fImageBytes = maxSize * 1000;//需要压缩的字节Byte，iOS系统内部的进制1000
    if (imageData.length <= fImageBytes){
        return imageData;
    }
    CGFloat max = 1;
    CGFloat min = 0;
    //指数二分处理，首先计算最小值
    compression = pow(2, -6);
    imageData = UIImageJPEGRepresentation(sourceImage, compression);
    if (imageData.length < fImageBytes) {
        //二分最大10次，区间范围精度最大可达0.00097657；最大6次，精度可达0.015625
        for (int i = 0; i < 6; ++i) {
            compression = (max + min) / 2;
            imageData = UIImageJPEGRepresentation(sourceImage, compression);
            //容错区间范围0.9～1.0
            if (imageData.length < fImageBytes * 0.9) {
                min = compression;
            } else if (imageData.length > fImageBytes) {
                max = compression;
            } else {
                break;
            }
        }
        return imageData;
    }
    
    // 对于图片太大上面的压缩比即使很小压缩出来的图片也是很大，不满足使用。
    //然后再一步绘制压缩处理
    UIImage *resultImage = [UIImage imageWithData:imageData];
    while (imageData.length > fImageBytes) {
        @autoreleasepool {
            CGFloat ratio = (CGFloat)fImageBytes / imageData.length;
            //使用NSUInteger不然由于精度问题，某些图片会有白边
            NSLog(@">>>>>>>>>>>>>>>>>%f>>>>>>>>>>>>%f>>>>>>>>>>>%f",resultImage.size.width,sqrtf(ratio),resultImage.size.height);
            CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                     (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
            //            resultImage = [self drawWithWithImage:resultImage Size:size];
            //            resultImage = [self scaledImageWithData:imageData withSize:size scale:resultImage.scale orientation:UIImageOrientationUp];
            resultImage = [YHPhotoManager thumbnailForData:imageData maxPixelSize:MAX(size.width, size.height)];
            imageData = UIImageJPEGRepresentation(resultImage, compression);
        }
    }
    
    //   整理后的图片尽量不要用UIImageJPEGRepresentation方法转换，后面参数1.0并不表示的是原质量转换。
    return imageData;
}

+ (UIImage *)thumbnailForData:(NSData *)data maxPixelSize:(NSUInteger)size {
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGImageSourceRef source = CGImageSourceCreateWithDataProvider(provider, NULL);
    
    CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(source, 0, (__bridge CFDictionaryRef) @{
                                                                                                      (NSString *)kCGImageSourceCreateThumbnailFromImageAlways : @YES,
                                                                                                      (NSString *)kCGImageSourceThumbnailMaxPixelSize : @(size),
                                                                                                      (NSString *)kCGImageSourceCreateThumbnailWithTransform : @YES,
                                                                                                      });
    CFRelease(source);
    CFRelease(provider);
    
    if (!imageRef) {
        return nil;
    }
    
    UIImage *toReturn = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    
    return toReturn;
}
@end
