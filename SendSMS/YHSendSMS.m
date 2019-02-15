//
//  YHSendSMS.m
//  chanDemo
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 银河. All rights reserved.
//

#import "YHSendSMS.h"
#import <objc/message.h>

static char yh_send_sms_completion_key;
static char yh_send_sms_associated_key;

@interface YHSendSMS() <MFMessageComposeViewControllerDelegate>
@property (nonatomic, weak) UIViewController *showVC;
@end

@implementation YHSendSMS
- (void)dealloc{
    //NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

// Send SMS to some people.
+ (void)sendSmsWithPhones:(NSArray<NSString *> *)phones smsContent:(NSString *)smsContent showVC:(UIViewController *)showVC completionBlock:(void (^ _Nullable)(MessageComposeResult, NSError * _Nullable))completionBlock{
    if ([MFMessageComposeViewController canSendText]) {
        YHSendSMS *sms = [[YHSendSMS alloc] init];
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.body = smsContent;
        controller.messageComposeDelegate = sms;
        [showVC presentViewController:controller animated:YES completion:nil];
        objc_setAssociatedObject(sms, &yh_send_sms_completion_key, completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
        objc_setAssociatedObject(showVC, &yh_send_sms_associated_key, sms, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        sms.showVC = showVC;
    } else {
        NSError *error = [NSError errorWithDomain:@"com.yinhe.sendSms" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"该设备不支持发送短信."}];
        completionBlock ? completionBlock(MessageComposeResultFailed, error) : nil;
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [controller dismissViewControllerAnimated:YES completion:nil];
    void(^block)(MessageComposeResult rt, NSError *_Nullable error) = objc_getAssociatedObject(self, &yh_send_sms_completion_key);
    block ? block(result, nil) : nil;
    objc_setAssociatedObject(self.showVC, &yh_send_sms_associated_key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);// Remove associated.
}
@end
