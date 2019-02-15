//
//  YHAuthorizetionMicrophone.m
//  chanDemo
//
//  Created by apple on 2019/1/5.
//  Copyright © 2019 银河. All rights reserved.
//

#import "YHAuthorizetionMicrophone.h"

@implementation YHAuthorizetionMicrophone

// Determine whether authorization is currently available.
+ (BOOL)isAuthorized{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    return status == AVAuthorizationStatusAuthorized;
}

// Request microphone authorizetion.
+ (void)requestAuthorizetionWithCompletion:(void (^)(BOOL, BOOL))completion{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
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
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
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
