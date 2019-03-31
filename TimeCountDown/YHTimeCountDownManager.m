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
NSString *const kYHTimeCountDownGroupIdentifierKey      = @"kYHTimeCountDownGroupIdentifierKey";
NSString *const kYHTimeCountDownRemainingTimeKey        = @"kYHTimeCountDownRemainingTimeKey";



// 组
@interface YHTimeCountDownGroup : NSObject
@property (nonatomic, copy) NSString *groupIdentifier;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) BOOL isStart;
@end


@implementation YHTimeCountDownGroup

@end



// Model
@interface YHTimeCountDownModel : NSObject
@property (nonatomic, strong) YHTimeCountDownGroup *group;
@property (nonatomic, copy) NSString *identifier;
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}


- (void)startTimeCountDownWithGroupIdentifier:(NSString *)groupIdentifier
                                   identifier:(NSString *)identifier
                                     interval:(NSTimeInterval)interval
                            startTimeInterval:(NSTimeInterval)startTimeInterval
                              endTimeInterval:(NSTimeInterval)endTimeInterval{
    
    // 根据identifier和groupIdentifier找到是否存在YHTimeCountDownModel.
    __block YHTimeCountDownModel *tmpModel = nil;
    [self.timers enumerateObjectsUsingBlock:^(YHTimeCountDownModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.identifier isEqualToString:identifier] && obj.group && [obj.group.groupIdentifier isEqualToString:groupIdentifier]) {
            tmpModel = obj;
            *stop = YES;
        }
    }];
    if (tmpModel) {
        return;
    }
    
    // 不存在YHTimeCountDownModel，新建；但是新建的YHTimeCountDownModel可能和timers里面的某个model有相同的groupIdentifier.
    YHTimeCountDownModel * model = [[YHTimeCountDownModel alloc] init];
    model.identifier = identifier;
    
    model.startTimeInterval = startTimeInterval;
    model.endTimeInterval = endTimeInterval;
    model.currentTimeInterval = 0;
    
    if (startTimeInterval > endTimeInterval) {
        model.startTimeInterval = endTimeInterval;
        model.endTimeInterval = endTimeInterval;
    }
    
    
    
    // 根据groupIdentifer找到group
    __block YHTimeCountDownGroup *tmpGroup = nil;
    [self.timers enumerateObjectsUsingBlock:^(YHTimeCountDownModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.group && [obj.group.groupIdentifier isEqualToString:groupIdentifier]) {
            tmpGroup = obj.group;
            *stop = YES;
        }
    }];
    
    if (!tmpGroup) {
        YHTimeCountDownGroup *group = [[YHTimeCountDownGroup alloc] init];
        group.interval = interval;
        group.groupIdentifier = groupIdentifier;
        
        dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            // 找到所有属于groupIdentifer的models集合
            NSMutableArray<YHTimeCountDownModel *> *models = [NSMutableArray array];
            [self.timers enumerateObjectsUsingBlock:^(YHTimeCountDownModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.group.groupIdentifier isEqualToString:groupIdentifier]) {
                    [models addObject:obj];
                }
            }];
            [models enumerateObjectsUsingBlock:^(YHTimeCountDownModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.currentTimeInterval += obj.group.interval;
                NSTimeInterval remain = obj.endTimeInterval - (obj.currentTimeInterval + obj.startTimeInterval);
                if (remain < 0) {
                    remain = 0;
                }
                NSDictionary *info = @{kYHTimeCountDownIdentifierKey : obj.identifier,
                                       kYHTimeCountDownGroupIdentifierKey : obj.group.groupIdentifier,
                                       kYHTimeCountDownRemainingTimeKey : @(remain)};
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kYHTimeCountDownNotification object:nil userInfo:info];
                
//                if (obj.currentTimeInterval >= obj.endTimeInterval) {
//                    [self removeTimerIntervalWithIdentifer:obj.identifier];
//                }
            }];
        });
        dispatch_resume(timer);
        group.timer = timer;
        model.group = group;
    } else {
        model.group = tmpGroup;
    }
    [self.timers addObject:model];
}

- (void)removeTimerIntervalWithGroupIdentifer:(NSString *)groupIdentifier{
    __block NSMutableArray<YHTimeCountDownModel *> *models = [NSMutableArray array];
    [self.timers enumerateObjectsUsingBlock:^(YHTimeCountDownModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.group.groupIdentifier isEqualToString:groupIdentifier]) {
            if (obj.group.timer) {
                dispatch_source_cancel(obj.group.timer);
                obj.group.timer = nil;
            }
            [models addObject:obj];
        }
    }];
    [self.timers removeObjectsInArray:models];
}

- (void)removeAllTimer{
    [self.timers enumerateObjectsUsingBlock:^(YHTimeCountDownModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.group && obj.group.timer) {
            dispatch_source_cancel(obj.group.timer);
            obj.group.timer = nil;
        }
    }];
    [self.timers removeAllObjects];
}


#pragma mark ------------------ Notification ------------------
- (void)didEnterBackground:(NSNotification *)noti{
    /// TODO:即将完成
}

- (void)willEnterForeground:(NSNotification *)noti{
    /// TODO:即将完成
}
@end
