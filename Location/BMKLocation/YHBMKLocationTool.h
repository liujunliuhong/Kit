//
//  YHBMKLocationTool.h
//  FrameDating
//
//  Created by apple on 2019/5/10.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<BMKLocationKit/BMKLocationComponent.h>)
    #import <BMKLocationKit/BMKLocationComponent.h>
#endif

NS_ASSUME_NONNULL_BEGIN

// 定位状态
typedef NS_ENUM(NSUInteger, YHBMKLocationState) {
    YHBMKLocationState_Default,            // 定位默认状态
    YHBMKLocationState_Locationing,        // 定位中
    YHBMKLocationState_Success,            // 定位成功
    YHBMKLocationState_Fail,               // 定位失败
};

/**
 * 百度单次定位封装
 */
@interface YHBMKLocation : NSObject
#if __has_include(<BMKLocationKit/BMKLocationComponent.h>)
// 是否允许定位
@property (nonatomic, assign) BOOL isAllowLocation;

// 定位状态  请在isAllowLocation为YES时，判断该状态
@property (nonatomic, assign) YHBMKLocationState locationState;

@property (nonatomic, copy, nullable) NSString *country;
@property (nonatomic, copy, nullable) NSString *province;
@property (nonatomic, copy, nullable) NSString *city;
@property (nonatomic, copy, nullable) NSString *cityCode;

@property (nonatomic, strong, nullable) BMKLocation *bmkLocation;
#endif
@end

@interface YHBMKLocationTool : NSObject

#if __has_include(<BMKLocationKit/BMKLocationComponent.h>)
+ (instancetype)sharedInstance;

@property (nonatomic, strong) YHBMKLocation *location;

/**
 * 初始化百度SDK
 */
- (void)initSDK:(NSString *)key;

/**
 * 单次定位
 */
- (void)requestLocationWithShowHUD:(BOOL)showHUD
                            target:(id)target
                   completionBlock:(void(^)(void))completionBlock;
#endif
@end

NS_ASSUME_NONNULL_END
