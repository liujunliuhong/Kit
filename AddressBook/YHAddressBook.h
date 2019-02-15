//
//  YHAddressBook.h
//  chanDemo
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 银河. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHAdressBookModel.h"

NS_ASSUME_NONNULL_BEGIN

NS_CLASS_AVAILABLE_IOS(8_0) @interface YHAddressBook : NSObject 

// If not add 'NSContactsUsageDescription' key into info.plst, app will crash.
// If access to contact data is already restricted or denied, the error is not nil.
+ (void)getOriginAdressBookWithCompletionBlock:(void(^_Nullable)(NSArray<YHAdressBookModel *> *_Nullable originModels, NSError *_Nullable error))completionBlock;

// If not add 'NSContactsUsageDescription' key into info.plst, app will crash.
// If access to contact data is already restricted or denied, the error is not nil.
+ (void)getOrderAdressBookWithCompletionBlock:(void(^_Nullable)(NSArray<NSArray<YHAdressBookModel *> *> *_Nullable orderModels, NSArray<NSString *> *_Nullable sectionTitles, NSError *_Nullable error))completionBlock;

@end

NS_ASSUME_NONNULL_END
