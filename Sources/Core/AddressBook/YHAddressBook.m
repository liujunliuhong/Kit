//
//  YHAddressBook.m
//  chanDemo
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 银河. All rights reserved.
//

#import "YHAddressBook.h"
#import "YHChineseSort.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
    #import <Contacts/Contacts.h>
#else
    #import <AddressBook/AddressBook.h>
#endif

#ifdef DEBUG
    #define YHDebugLog(format, ...)  printf("[YHDebugLog] [YHAddressBook] [%s] [%d] %s\n" ,[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:format, ##__VA_ARGS__] UTF8String])
#else
    #define YHDebugLog(format, ...)
#endif

@implementation YHAddressBook

#pragma mark - Public Methods
// If not add 'NSContactsUsageDescription' key into info.plst, app will crash.
// If access to contact data is already restricted or denied, the error is not nil.
+ (void)getOriginAdressBookWithCompletionBlock:(void (^)(NSArray<YHAdressBookModel *> * _Nullable, NSError * _Nullable))completionBlock{
    
    dispatch_queue_t queue = dispatch_queue_create("com.yinhe.ddressBook", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        NSMutableArray<YHAdressBookModel *> *originModels = [NSMutableArray array];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0
        if (@available(iOS 9.0, *)) {
            CNContactStore *contactStore = [[CNContactStore alloc] init];
            NSArray *fetchKeys = @[
                                   [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],
                                   CNContactPhoneNumbersKey,
                                   CNContactThumbnailImageDataKey
                                   ];
            CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:fetchKeys];
            NSError *error = nil;
            // If access to contact data is already restricted or denied, the error is not nil.
            BOOL isSuccess = [contactStore enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
                NSString *name = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
                UIImage *headImage = [UIImage imageWithData:contact.thumbnailImageData];
                NSArray *phones = contact.phoneNumbers;
                for (CNLabeledValue *labelValue in phones) {
                    CNPhoneNumber *phone = labelValue.value;
                    YHDebugLog(@"Origin phone:%@",phone.stringValue);
                    NSString *tmpPhone = [self removeSpecialCharacterStringWithPhone:phone.stringValue];
                    if (tmpPhone && tmpPhone.length > 0) {
                        @autoreleasepool {
                            YHAdressBookModel *model = [[YHAdressBookModel alloc] init];
                            model.name = name;
                            model.phone = tmpPhone;
                            if (!model.name) {
                                model.name = model.phone;
                            }
                            model.headImage = headImage;
                            [originModels addObject:model];
                        }
                    }
                }
            }];
            if (!isSuccess) {
                YHDebugLog(@"Get adressbook fail, error: %@.",error);
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock ? completionBlock(@[], error) : nil;
                });
            } else {
                YHDebugLog(@"Get adressBook succes.");
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock ? completionBlock(originModels, nil) : nil;
                });
            }
        }
#else
        CFErrorRef errorRef = nil;
        
        // If access to contact data is already restricted or denied, this will fail returning a NULL ABAddressBookRef.
        // And errorRef is not nil.
        ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &errorRef);
        ABRecordRef recordRef = ABAddressBookCopyDefaultSource(addressBook);
        CFArrayRef allPeopleArray = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, recordRef, kABPersonSortByLastName);
        
        for (id personInfo in (__bridge NSArray *)allPeopleArray) {
            ABRecordRef person = (__bridge ABRecordRef)(personInfo);
            NSString *name = (__bridge_transfer NSString *)ABRecordCopyCompositeName(person);
            NSData *imageData = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
            UIImage *headImage = [UIImage imageWithData:imageData];
            
            ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
            CFIndex phoneCount = ABMultiValueGetCount(phones);
            for (CFIndex i = 0; i < phoneCount; i ++) {
                NSString *phone = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
                YHDebugLog(@"Origin phone:%@",phone);
                NSString *tmpPhone = [self removeSpecialCharacterStringWithPhone:phone];
                if (tmpPhone && tmpPhone.length > 0) {
                    @autoreleasepool {
                        YHAdressBookModel *model = [[YHAdressBookModel alloc] init];
                        model.name = name;
                        model.phone = tmpPhone;
                        if (!model.name) {
                            model.name = model.phone;
                        }
                        model.headImage = headImage;
                        [originModels addObject:model];
                    }
                }
            }
            CFRelease(phones);
        }
        if (allPeopleArray) {
            CFRelease(allPeopleArray);
        }
        if (recordRef) {
            CFRelease(recordRef);
        }
        if (addressBook) {
            CFRelease(addressBook);
        }
        
        
        NSError *error = (__bridge_transfer NSError *)errorRef;
        if (error) {
            YHDebugLog(@"Get adressbook fail, error: %@.",error);
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock ? completionBlock(@[], error) : nil;
            });
        } else {
            YHDebugLog(@"Get adressBook succes.");
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock ? completionBlock(originModels, nil) : nil;
            });
        }
#endif
    });
}

// If not add 'NSContactsUsageDescription' key into info.plst, app will crash.
// If access to contact data is already restricted or denied, the error is not nil.
+ (void)getOrderAdressBookWithCompletionBlock:(void (^)(NSArray<NSArray<YHAdressBookModel *> *> * _Nullable, NSArray<NSString *> * _Nullable, NSError * _Nullable))completionBlock{
    [self getOriginAdressBookWithCompletionBlock:^(NSArray<YHAdressBookModel *> * _Nullable originModels, NSError * _Nullable error) {
        if (error) {
            completionBlock ? completionBlock(@[], @[], error) : nil;
            return ;
        }
        YHChineseSort *sort = [[YHChineseSort alloc] init];
        [sort sortWithModels:originModels key:@"name" modelClass:[YHAdressBookModel class] completion:^(NSArray<NSArray *> * _Nonnull sortGroups, NSArray<NSString *> * _Nonnull sectionTitles) {
            completionBlock ? completionBlock(sortGroups, sectionTitles, nil) : nil;
        }];
    }];
}

#pragma mark - Private Methods
+ (nullable NSString *)removeSpecialCharacterStringWithPhone:(nullable NSString *)phone{
    if (!phone) {
        return nil;
    }
    phone = [phone stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //phone = [phone stringByReplacingOccurrencesOfString:@"(" withString:@""];
    //phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    return phone;
}
@end
