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
extern NSString *const kYHTimeCountDownRemainingTimeKey;   // 剩余时间

@interface YHTimeCountDownManager : NSObject

+ (instancetype)shareInstance;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


/**
 开启倒计时功能

 @param identifier 唯一标志符
 @param interval 倒计时间隔时间
 @param startTimeInterval 开始时间戳
 @param endTimeInterval 结束时间戳
 */
- (void)startTimeCountDownWithIdentifier:(NSString *)identifier
                                interval:(NSTimeInterval)interval
                       startTimeInterval:(NSTimeInterval)startTimeInterval
                         endTimeInterval:(NSTimeInterval)endTimeInterval;


/**
 根据某个identifer移除倒计时

 @param identifer 唯一标志符
 */
- (void)removeTimerIntervalWithIdentifer:(NSString *)identifer;



/**
 移除所有倒计时
 */
- (void)removeAllTimer;

@end

NS_ASSUME_NONNULL_END
