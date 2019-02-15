//
//  YHAuthorizetion.h
//  chanDemo
//
//  Created by apple on 2019/1/5.
//  Copyright © 2019 银河. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHAuthorizetionCamera.h"
#import "YHAuthorizetionPhotos.h"
#import "YHAuthorizetionContacts.h"
#import "YHAuthorizetionMicrophone.h"
#import "YHAuthorizetionCalendar.h"
#import "YHAuthorizetionReminder.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YHAuthorizetionType) {
    YHAuthorizetionType_Camera,                // Camera            NSCameraUsageDescription
    YHAuthorizetionType_Photos,                // Photos            NSPhotoLibraryUsageDescription     NSPhotoLibraryAddUsageDescription
    YHAuthorizetionType_Contacts,              // Contacts          NSContactsUsageDescription
    YHAuthorizetionType_Microphone,            // Microphone        NSMicrophoneUsageDescription
    YHAuthorizetionType_Calendar,              // Calendar          NSCalendarsUsageDescription
    YHAuthorizetionType_Reminder,              // Reminder          NSRemindersUsageDescription
};

NS_CLASS_AVAILABLE_IOS(8_0) @interface YHAuthorizetion : NSObject

// Determine whether authorization is currently available.
+ (BOOL)isAuthorizedWithType:(YHAuthorizetionType)type;

// Request authorization.
+ (void)requestAuthorizetionWithType:(YHAuthorizetionType)type completion:(void(^)(BOOL granted, BOOL isFirst))completion;

@end
NS_ASSUME_NONNULL_END
