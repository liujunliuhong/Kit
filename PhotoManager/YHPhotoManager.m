//
//  YHPhotoManager.m
//  HiFanSmooth
//
//  Created by 银河 on 2019/5/19.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHPhotoManager.h"


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




//图片质量压缩到某一范围内，如果后面用到多，可以抽成分类或者工具类,这里压缩递减比二分的运行时间长，二分可以限制下限。
+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength{
    //首先判断原图大小是否在要求内，如果满足要求则不进行压缩，over
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    //原图大小超过范围，先进行“压处理”，这里 压缩比 采用二分法进行处理，6次二分后的最小压缩比是0.015625，已经够小了
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //判断“压处理”的结果是否符合要求，符合要求就over
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    //缩处理，直接用大小的比例作为缩处理的比例进行处理，因为有取整处理，所以一般是需要两次处理
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        //获取处理后的尺寸
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        //通过图片上下文进行处理图片
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //获取处理后图片的大小
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return resultImage;
}

+ (NSData *)compressImageToData:(UIImage *)image toByte:(NSUInteger)maxLength{
    //首先判断原图大小是否在要求内，如果满足要求则不进行压缩，over
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    //原图大小超过范围，先进行“压处理”，这里 压缩比 采用二分法进行处理，6次二分后的最小压缩比是0.015625，已经够小了
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //判断“压处理”的结果是否符合要求，符合要求就over
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return data;
    
    //缩处理，直接用大小的比例作为缩处理的比例进行处理，因为有取整处理，所以一般是需要两次处理
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        //获取处理后的尺寸
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        //通过图片上下文进行处理图片
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        //获取处理后图片的大小
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return data;
}

@end
