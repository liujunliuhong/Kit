//
//  YHAuthorizetionContacts.m
//  chanDemo
//
//  Created by apple on 2019/1/5.
//  Copyright © 2019 银河. All rights reserved.
//

#import "YHAuthorizetionContacts.h"

@implementation YHAuthorizetionContacts

// Determine whether authorization is currently available.
+ (BOOL)isAuthorized{
    BOOL res = NO;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        res = status == CNAuthorizationStatusAuthorized;
    }
#else
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    res = status == kABAuthorizationStatusAuthorized;
#endif
    return res;
}

// Request contacts authorizetion.
+ (void)requestAuthorizetionWithCompletion:(void (^)(BOOL, BOOL))completion{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status) {
            case CNAuthorizationStatusAuthorized:
            {
                completion ? completion(YES, NO) : nil;
            }
                break;
            case CNAuthorizationStatusDenied:
            case CNAuthorizationStatusRestricted:
            {
                completion ? completion(NO, NO) : nil;
            }
                break;
            case CNAuthorizationStatusNotDetermined:
            {
                [[[CNContactStore alloc] init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
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
#else
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    switch (status) {
        case kABAuthorizationStatusAuthorized:
        {
            completion ? completion(YES, NO) : nil;
        }
            break;
        case kABAuthorizationStatusDenied:
        case kABAuthorizationStatusRestricted:
        {
            completion ? completion(NO, NO) : nil;
        }
            break;
        case kABAuthorizationStatusNotDetermined:
        {
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion ? completion(granted, YES) : nil;
                });
            });
        }
            break;
        default:
            break;
    }
#endif
}

@end
