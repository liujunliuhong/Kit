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
extern NSString *const kYHTimeCountDownIntervalKey;        // interval
extern NSString *const kYHTimeCountDownTimeIntervalKey;    // timeInterval

@interface YHTimeCountDownManager : NSObject

+ (instancetype)shareInstance;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


- (void)addTimeInterval:(NSTimeInterval)interval
             identifier:(NSString *)identifier;

- (void)removeTimerIntervalWithIdentifer:(NSString *)identifier;
- (void)removeAllTimer;

@end

NS_ASSUME_NONNULL_END
