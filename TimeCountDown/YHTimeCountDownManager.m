//
//  YHTimeCountDownManager.m
//  HiFanSmooth
//
//  Created by apple on 2019/3/28.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHTimeCountDownManager.h"

NSString *const kYHTimeCountDownNotification            = @"kYHTimeCountDownNotification";
NSString *const kYHTimeCountDownIdentifierKey           = @"kYHTimeCountDownIdentifierKey";
NSString *const kYHTimeCountDownRemainingTimeKey        = @"kYHTimeCountDownRemainingTimeKey";


@interface YHTimeCountDownModel : NSObject
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, assign) NSTimeInterval startTimeInterval;
@property (nonatomic, assign) NSTimeInterval endTimeInterval;
@property (nonatomic, assign) NSTimeInterval currentTimeInterval;
@end


@implementation YHTimeCountDownModel

@end





@interface YHTimeCountDownManager()
@property (nonatomic, strong) NSMutableArray<YHTimeCountDownModel *> *timers;
@end

@implementation YHTimeCountDownManager

+ (instancetype)shareInstance{
    static YHTimeCountDownManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.timers = [NSMutableArray array];
    }
    return self;
}


- (void)startTimeCountDownWithIdentifier:(NSString *)identifier
                                interval:(NSTimeInterval)interval
                       startTimeInterval:(NSTimeInterval)startTimeInterval
                         endTimeInterval:(NSTimeInterval)endTimeInterval{
    // 先移除
    [self removeTimerIntervalWithIdentifer:identifier];
    
    
    YHTimeCountDownModel *model = [[YHTimeCountDownModel alloc] init];
    model.identifier = identifier;
    model.interval = interval;
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        __block YHTimeCountDownModel *m = nil;
        [self.timers enumerateObjectsUsingBlock:^(YHTimeCountDownModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.timer == timer) {
                m = obj;
                *stop = YES;
            }
        }];
        if (m) {
            m.currentTimeInterval += m.interval;
            
            NSTimeInterval remain = m.endTimeInterval - m.currentTimeInterval;
            NSDictionary *info = @{kYHTimeCountDownIdentifierKey : m.identifier,
                                   kYHTimeCountDownRemainingTimeKey : @(remain)};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kYHTimeCountDownNotification object:nil userInfo:info];
            
            if (m.currentTimeInterval >= m.endTimeInterval) {
                [self removeTimerIntervalWithIdentifer:m.identifier];
            }
        }
    });
    dispatch_resume(timer);
    
    model.timer = timer;
    
    
    model.startTimeInterval = startTimeInterval;
    model.endTimeInterval = endTimeInterval;
    model.currentTimeInterval = startTimeInterval;
    
    if (startTimeInterval > endTimeInterval) {
        model.startTimeInterval = endTimeInterval;
        model.endTimeInterval = endTimeInterval;
        model.currentTimeInterval = endTimeInterval;
    }
    [self.timers addObject:model];
}

- (void)removeTimerIntervalWithIdentifer:(NSString *)identifer{
    [self.timers enumerateObjectsUsingBlock:^(YHTimeCountDownModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString:identifer]) {
            dispatch_source_cancel(obj.timer);
            obj.timer = nil;
            [self.timers removeObject:obj];
            *stop = YES;
        }
    }];
}

- (void)removeAllTimer{
    [self.timers enumerateObjectsUsingBlock:^(YHTimeCountDownModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_source_cancel(obj.timer);
        obj.timer = nil;
    }];
    [self.timers removeAllObjects];
}

@end
