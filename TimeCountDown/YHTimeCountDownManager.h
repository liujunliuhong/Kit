//
//  YHTimeCountDownManager.h
//  HiFanSmooth
//
//  Created by apple on 2019/3/28.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kYHTimeCountDownNotification;       // NotificationName
extern NSString *const kYHTimeCountDownIdentifierKey;      // identifier
extern NSString *const kYHTimeCountDownGroupIdentifierKey; // groupIdentifier
extern NSString *const kYHTimeCountDownRemainingTimeKey;   // 剩余时间

@interface YHTimeCountDownManager : NSObject

+ (instancetype)shareInstance;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;



- (void)startTimeCountDownWithGroupIdentifier:(NSString *)groupIdentifier
                                   identifier:(NSString *)identifier
                                     interval:(NSTimeInterval)interval
                            startTimeInterval:(NSTimeInterval)startTimeInterval
                              endTimeInterval:(NSTimeInterval)endTimeInterval;

- (void)removeTimerIntervalWithGroupIdentifer:(NSString *)groupIdentifier;
- (void)removeAllTimer;

@end

NS_ASSUME_NONNULL_END
