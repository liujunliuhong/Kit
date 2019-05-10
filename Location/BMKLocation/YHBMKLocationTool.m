//
//  YHBMKLocationTool.m
//  FrameDating
//
//  Created by apple on 2019/5/10.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHBMKLocationTool.h"
#import "YHMacro.h"
#import "YHLocation.h"
#import "YHMBHud.h"

@implementation YHBMKLocation

@end


@interface YHBMKLocationTool()
#if __has_include(<BMKLocationKit/BMKLocationComponent.h>)
<BMKLocationAuthDelegate>
#endif
#if __has_include(<BMKLocationKit/BMKLocationComponent.h>)
@property (nonatomic, strong) BMKLocationManager *locationManager;
@property (nonatomic, strong) MBProgressHUD *hud;
#endif
@end

@implementation YHBMKLocationTool
#if __has_include(<BMKLocationKit/BMKLocationComponent.h>)
+ (instancetype)sharedInstance{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.location = [[YHBMKLocation alloc] init];
        self.location.isAllowLocation = YES;
        self.location.locationState = YHBMKLocationState_Default;
        self.location.province = nil;
        self.location.city = nil;
        self.location.cityCode = nil;
        self.location.country = nil;
        self.location.bmkLocation = nil;
    }
    return self;
}

- (void)initSDK:(NSString *)key{
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:key authDelegate:self];
}

- (void)requestLocationWithShowHUD:(BOOL)showHUD
                            target:(id)target
                   completionBlock:(void (^)(void))completionBlock{
    // 第一步：获取定位权限
    // 第二步：获取用户当前位置
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.location.isAllowLocation = YES;
        weakSelf.location.locationState = YHBMKLocationState_Locationing;
        weakSelf.location.province = nil;
        weakSelf.location.city = nil;
        weakSelf.location.cityCode = nil;
        weakSelf.location.country = nil;
        weakSelf.location.bmkLocation = nil;
        if (completionBlock) {
            completionBlock();
        }
        
        if (showHUD) {
            weakSelf.hud = [YHMBHud hudWithMessage:nil inView:nil];
        }
        
        [YHLocation requestLocationAuthorizationStatusWhenInUseWithTarget:target completionBlock:^(BOOL granted, NSError * _Nullable error) {
            YHDebugLog(@"获取定位授权状态error:%@", error);
            if (!granted) {
                [YHMBHud hideHud:weakSelf.hud];
                if (completionBlock) {
                    weakSelf.location.isAllowLocation = NO;
                    weakSelf.location.locationState = YHBMKLocationState_Fail;
                    weakSelf.location.province = nil;
                    weakSelf.location.city = nil;
                    weakSelf.location.cityCode = nil;
                    weakSelf.location.country = nil;
                    weakSelf.location.bmkLocation = nil;
                    completionBlock();
                }
                return ;
            }
            
            weakSelf.locationManager = [[BMKLocationManager alloc] init];
            weakSelf.locationManager.pausesLocationUpdatesAutomatically = NO;
            [weakSelf.locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
                [YHMBHud hideHud:weakSelf.hud];
                if (!error && location.rgcData) {
                    NSString *country = location.rgcData.country;
                    NSString *province = location.rgcData.province;
                    NSString *city = location.rgcData.city;
                    NSString *cityCode = location.rgcData.cityCode;
                    NSString *locationDescribe = location.rgcData.locationDescribe;
                    YHDebugLog(@"\n百度定位成功:\nprovince:%@\ncity:%@\ncityCode:%@\nlocationDescribe:%@\n", province, city, cityCode, locationDescribe);
                    weakSelf.location.isAllowLocation = YES;
                    weakSelf.location.locationState = YHBMKLocationState_Success;
                    weakSelf.location.province = province;
                    weakSelf.location.city = city;
                    weakSelf.location.cityCode = cityCode;
                    weakSelf.location.country = country;
                    weakSelf.location.bmkLocation = location;
                    if (completionBlock) {
                        completionBlock();
                    }
                } else {
                    YHDebugLog(@"百度定位失败:%@", error);
                    weakSelf.location.isAllowLocation = YES;
                    weakSelf.location.locationState = YHBMKLocationState_Fail;
                    weakSelf.location.province = nil;
                    weakSelf.location.city = nil;
                    weakSelf.location.cityCode = nil;
                    weakSelf.location.country = nil;
                    weakSelf.location.bmkLocation = nil;
                    if (completionBlock) {
                        completionBlock();
                    }
                }
            }];
        }];
    });
}


#pragma mark ------------------ BMKLocationAuthDelegate ------------------
- (void)onCheckPermissionState:(BMKLocationAuthErrorCode)iError{
    switch (iError) {
        case BMKLocationAuthErrorSuccess:
        {
            YHDebugLog(@"百度定位鉴权状态:鉴权成功");
        }
            break;
        case BMKLocationAuthErrorFailed:
        {
            YHDebugLog(@"百度定位鉴权状态:KEY非法鉴权失败");
        }
            break;
        case BMKLocationAuthErrorUnknown:
        {
            YHDebugLog(@"百度定位鉴权状态:未知错误");
        }
            break;
        case BMKLocationAuthErrorNetworkFailed:
        {
            YHDebugLog(@"百度定位鉴权状态:因网络鉴权失败");
        }
            break;
        default:
            break;
    }
}
#endif
@end
