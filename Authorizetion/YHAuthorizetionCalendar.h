//
//  YHAuthorizetionCalendar.h
//  chanDemo
//
//  Created by apple on 2019/1/5.
//  Copyright © 2019 银河. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * the calendar authorizetion.
 */
@interface YHAuthorizetionCalendar : NSObject

// Determine whether authorization is currently available.
+ (BOOL)isAuthorized;

// Request calendar authorizetion.
+ (void)requestAuthorizetionWithCompletion:(void(^_Nullable)(BOOL granted, BOOL isFirst))completion;

@end
NS_ASSUME_NONNULL_END
