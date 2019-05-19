//
//  YHPhotoManager.m
//  HiFanSmooth
//
//  Created by 银河 on 2019/5/19.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHPhotoManager.h"
#import <Photos/Photos.h>

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

- (void)dadsa{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCreationRequest *creationRequest = [PHAssetCreationRequest creationRequestForAsset];
        [creationRequest addResourceWithType:PHAssetResourceTypePhoto data:[NSData data] options:nil];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        
    }];
}

@end
