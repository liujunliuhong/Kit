//
//  YHAuthorizetionPhotos.m
//  chanDemo
//
//  Created by apple on 2019/1/5.
//  Copyright © 2019 银河. All rights reserved.
//

#import "YHAuthorizetionPhotos.h"

@implementation YHAuthorizetionPhotos

// Determine whether authorization is currently available.
+ (BOOL)isAuthorized{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    return status == PHAuthorizationStatusAuthorized;
}

// Request photo authorizetion.
+ (void)requestAuthorizetionWithCompletion:(void (^)(BOOL, BOOL))completion{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusAuthorized:
        {
            completion ? completion(YES, NO) : nil;
        }
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
        {
            completion ? completion(NO, NO) : nil;
        }
            break;
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion ? completion(status == PHAuthorizationStatusAuthorized, YES) : nil;
                });
            }];
        }
            break;
        default:
            break;
    }
}




@end
