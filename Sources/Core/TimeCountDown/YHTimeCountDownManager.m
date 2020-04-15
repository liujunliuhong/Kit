//
//  YHTimeCountDownManager.m
//  HiFanSmooth
//
//  Created by apple on 2019/3/28.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHTimeCountDownManager.h"
#import <UIKit/UIKit.h>

NSString *const kYHTimeCountDownNotification            = @"kYHTimeCountDownNotification";

NSString *const kYHTimeCountDownIdentifierKey           = @"kYHTimeCountDownIdentifierKey";
NSString *const kYHTimeCountDownIntervalKey             = @"kYHTimeCountDownIntervalKey";
NSString *const kYHTimeCountDownTimeIntervalKey         = @"kYHTimeCountDownTimeIntervalKey";


// Model
@interface YHTimeCountDownModel : NSObject
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) BOOL isPause;
@end


@implementation YHTimeCountDownModel

@end


@interface YHTimeCountDownManager()
@property (nonatomic, strong) NSMutableArray<YHTimeCountDownModel *> *timers;

@property (nonatomic, assign) CFAbsoluteTime lastTime;
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)addTimeInterval:(NSTimeInterval)interval identifier:(NSString *)identifier{
    __block BOOL isContain = NO;
    [self.timers enumerateObjectsUsingBlock:^(YHTimeCountDownModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString:identifier]) {
            isContain = YES;
            *stop = YES;
        }
    }];
    if (isContain) {
        return;
    }
    
    YHTimeCountDownModel *model = [[YHTimeCountDownModel alloc] init];
    model.identifier = identifier;
    model.interval = interval;
    model.timeInterval = 0;
    model.isPause = NO;
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        [weakSelf.timers enumerateObjectsUsingBlock:^(YHTimeCountDownModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.timer == timer) {
                obj.timeInterval += obj.interval;
                NSDictionary *info = @{kYHTimeCountDownIdentifierKey : obj.identifier,
                                       kYHTimeCountDownIntervalKey : @(obj.interval),
                                       kYHTimeCountDownTimeIntervalKey : @(obj.timeInterval)};
                [[NSNotificationCenter defaultCenter] postNotificationName:kYHTimeCountDownNotification object:nil userInfo:info];
            }
        }];
    });
    dispatch_resume(timer);
    
    
    model.timer = timer;
    
    [self.timers addObject:model];
}

- (void)removeTimerIntervalWithIdentifer:(NSString *)identifier{
    [self.timers enumerateObjectsUsingBlock:^(YHTimeCountDownModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString:identifier]) {
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


#pragma mark ------------------ Notification ------------------
- (void)didEnterBackground:(NSNotification *)noti{
    self.lastTime = CFAbsoluteTimeGetCurrent();
    [self.timers enumerateObjectsUsingBlock:^(YHTimeCountDownModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.isPause) {
            obj.isPause = YES;
            dispatch_suspend(obj.timer);
        }
    }];
}

- (void)willEnterForeground:(NSNotification *)noti{
    CFAbsoluteTime timeInterval = CFAbsoluteTimeGetCurrent() - self.lastTime;
    [self.timers enumerateObjectsUsingBlock:^(YHTimeCountDownModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.timeInterval += timeInterval;
        if (obj.isPause) {
            obj.isPause = NO;
            dispatch_resume(obj.timer);
        }
    }];
}
@end
