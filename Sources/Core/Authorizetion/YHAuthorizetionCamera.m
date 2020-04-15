//
//  YHAuthorizetionCamera.m
//  chanDemo
//
//  Created by apple on 2019/1/5.
//  Copyright © 2019 银河. All rights reserved.
//

#import "YHAuthorizetionCamera.h"

@implementation YHAuthorizetionCamera

// Determine whether authorization is currently available.
+ (BOOL)isAuthorized{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return status == AVAuthorizationStatusAuthorized;
}

// Request camera authorizetion.
+ (void)requestAuthorizetionWithCompletion:(void (^)(BOOL, BOOL))completion{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusAuthorized:
        {
            completion ? completion(YES, NO) : nil;
        }
            break;
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
        {
            completion ? completion(NO, NO) : nil;
        }
            break;
        case AVAuthorizationStatusNotDetermined:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion ? completion(granted, YES) : nil;
                });
            }];
        }
            break;
        default:
            break;
    }
}


@end
