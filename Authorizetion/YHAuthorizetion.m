//
//  YHAuthorizetion.m
//  chanDemo
//
//  Created by apple on 2019/1/5.
//  Copyright © 2019 银河. All rights reserved.
//

#import "YHAuthorizetion.h"


@implementation YHAuthorizetion

// Determine whether authorization is currently available.
+ (BOOL)isAuthorizedWithType:(YHAuthorizetionType)type{
    switch (type) {
        case YHAuthorizetionType_Camera:
        {
            return [YHAuthorizetionCamera isAuthorized];
        }
            break;
        case YHAuthorizetionType_Photos:
        {
            return [YHAuthorizetionPhotos isAuthorized];
        }
            break;
        case YHAuthorizetionType_Contacts:
        {
            return [YHAuthorizetionContacts isAuthorized];
        }
            break;
        case YHAuthorizetionType_Microphone:
        {
            return [YHAuthorizetionMicrophone isAuthorized];
        }
            break;
        case YHAuthorizetionType_Calendar:
        {
            return [YHAuthorizetionCalendar isAuthorized];
        }
            break;
        case YHAuthorizetionType_Reminder:
        {
            return [YHAuthorizetionReminder isAuthorized];
        }
            break;
        default:
        {
            return NO;
        }
            break;
    }
}

// Request authorization.
+ (void)requestAuthorizetionWithType:(YHAuthorizetionType)type completion:(void (^)(BOOL, BOOL))completion{
    switch (type) {
        case YHAuthorizetionType_Camera:
        {
            [YHAuthorizetionCamera requestAuthorizetionWithCompletion:completion];
        }
            break;
        case YHAuthorizetionType_Photos:
        {
            [YHAuthorizetionPhotos requestAuthorizetionWithCompletion:completion];
        }
            break;
        case YHAuthorizetionType_Contacts:
        {
            [YHAuthorizetionContacts requestAuthorizetionWithCompletion:completion];
        }
            break;
        case YHAuthorizetionType_Microphone:
        {
            [YHAuthorizetionMicrophone requestAuthorizetionWithCompletion:completion];
        }
            break;
        case YHAuthorizetionType_Calendar:
        {
            [YHAuthorizetionCalendar requestAuthorizetionWithCompletion:completion];
        }
            break;
        case YHAuthorizetionType_Reminder:
        {
            [YHAuthorizetionReminder requestAuthorizetionWithCompletion:completion];
        }
            break;
        default:
            break;
    }
}
@end
