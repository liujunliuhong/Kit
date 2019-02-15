//
//  YHAuthorizetionContacts.h
//  chanDemo
//
//  Created by apple on 2019/1/5.
//  Copyright © 2019 银河. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    #import <Contacts/Contacts.h>
#else
    #import <AddressBook/AddressBook.h>
#endif

NS_ASSUME_NONNULL_BEGIN
/**
 * the contacts authorizetion.
 */
NS_CLASS_AVAILABLE_IOS(8_0) @interface YHAuthorizetionContacts : NSObject

// Determine whether authorization is currently available.
+ (BOOL)isAuthorized;

// Request contacts authorizetion.
+ (void)requestAuthorizetionWithCompletion:(void(^)(BOOL granted, BOOL isFirst))completion;

@end
NS_ASSUME_NONNULL_END
