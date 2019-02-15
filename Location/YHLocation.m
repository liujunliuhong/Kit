//
//  YHLocation.m
//  Kit
//
//  Created by 银河 on 2019/2/12.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHLocation.h"
#import <objc/message.h>


static char yh_location_associated_key;
static char yh_location_completion_key;

@interface YHLocation () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) id target;
@end

@implementation YHLocation

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)startLocationWithTarget:(id)target completionBlock:(void (^ _Nullable)(CLPlacemark * _Nullable, NSError * _Nullable))completionBlock{
    YHLocation *location = [[YHLocation alloc] init];
    location.target = target;
    if ([CLLocationManager locationServicesEnabled]) {
        location.locationManager = [[CLLocationManager alloc] init];
        location.locationManager.delegate = location;
        [location.locationManager requestWhenInUseAuthorization];
        location.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        location.locationManager.distanceFilter = 5.0;
        [location.locationManager startUpdatingLocation];
        
        objc_setAssociatedObject(target, &yh_location_associated_key, location, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(location, &yh_location_completion_key, completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    } else {
        if (completionBlock) {
            completionBlock(nil, [NSError errorWithDomain:@"com.yhkit.location" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"Location Service Unavailable."}]);
        }
    }
}


#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [manager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    void(^block)(CLPlacemark *_Nullable placemark, NSError *_Nullable error) = objc_getAssociatedObject(self, &yh_location_completion_key);
    
    [geoCoder reverseGeocodeLocation:currentLocation  completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error) {
            if (block) {
                block(nil, error);
            }
        } else {
            if (placemarks.count <= 0) {
                block(nil, [NSError errorWithDomain:@"com.yhkit.location" code:-1 userInfo:@{NSLocalizedDescriptionKey:@"No Place"}]);
            } else {
                CLPlacemark *placemark = placemarks[0];
                block(placemark, nil);
            }
        }
        // country      当前国家
        // locality     当前的城市
        // subLocality  当前的位置
        // thoroughfare 当前街道
        // name         具体地址
    }];
    objc_setAssociatedObject(self.target, &yh_location_associated_key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);// Remove associated.
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    void(^block)(CLPlacemark *_Nullable placemark, NSError *_Nullable error) = objc_getAssociatedObject(self, &yh_location_completion_key);
    if (block) {
        block(nil, error);
    }
    objc_setAssociatedObject(self.target, &yh_location_associated_key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);// Remove associated.
}

@end
