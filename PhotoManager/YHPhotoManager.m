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

@end
