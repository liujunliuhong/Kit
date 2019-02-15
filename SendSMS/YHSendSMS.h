//
//  YHSendSMS.h
//  chanDemo
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 银河. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHSendSMS : NSObject

// Send SMS to some people.
+ (void)sendSmsWithPhones:(NSArray<NSString *> *)phones smsContent:(nullable NSString *)smsContent showVC:(UIViewController *)showVC completionBlock:(void(^_Nullable)(MessageComposeResult result, NSError *_Nullable error))completionBlock;

@end

NS_ASSUME_NONNULL_END
