//
//  UIDevice+YHExtension.m
//  chanDemo
//
//  Created by apple on 2019/1/2.
//  Copyright © 2019 银河. All rights reserved.
//

#import "UIDevice+YHExtension.h"
#import <sys/utsname.h>
#import "YHMacro.h"

@implementation UIDevice (YHExtension)
+ (void)load{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *sysname = [NSString stringWithCString:systemInfo.sysname encoding:NSUTF8StringEncoding];
    NSString *nodename = [NSString stringWithCString:systemInfo.nodename encoding:NSUTF8StringEncoding];
    NSString *release = [NSString stringWithCString:systemInfo.release encoding:NSUTF8StringEncoding];
    NSString *version = [NSString stringWithCString:systemInfo.version encoding:NSUTF8StringEncoding];
    NSString *machine = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    YHDebugLog(@"\n\n\n\n*****************************************************************************************************************\n|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n*****************************************************************************************************************\nsysname:     %@\nnodename:    %@\nrelease:     %@\nversion:     %@\nmachine:     %@（%@）\n*****************************************************************************************************************\n|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||\n*****************************************************************************************************************\n\n\n\n", sysname, nodename, release, version, machine, [[UIDevice currentDevice] __formatMachine:machine]);
}



/**
 * 是否是iPhone X系列手机(刘海屏手机)
 * 备用判断方法，要跟着Apple每年发布新版手机的变化而调整
 */
+ (BOOL)yh_isIphoneX{
    NSString *machineName = [[UIDevice currentDevice] __machineName];
    BOOL res = NO;
    if ([machineName isEqualToString:@"iPhone11,8"] ||
        [machineName isEqualToString:@"iPhone11,6"] ||
        [machineName isEqualToString:@"iPhone11,4"] ||
        [machineName isEqualToString:@"iPhone11,2"] ||
        [machineName isEqualToString:@"iPhone10,6"]) {
        res = YES;
    }
    return res;
}

- (NSString *)yh_deviceName{
    NSString *machineName = [self __machineName];
    return [self __formatMachine:machineName];
}

- (NSString *)__machineName{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *hardwareString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    NSString *deviceName = hardwareString;
    if (!deviceName) {
        deviceName = [UIDevice currentDevice].systemVersion;
    }
    return deviceName;
}

- (NSString *)__formatMachine:(NSString *)machine{
    NSString *deviceName = machine;
    
    // iPhone
    // 刘海屏手机
    if ([deviceName isEqualToString:@"iPhone11,8"])   {deviceName = @"iPhone XR";}
    else if ([deviceName isEqualToString:@"iPhone11,6"])   {deviceName = @"iPhone XS Max";}
    else if ([deviceName isEqualToString:@"iPhone11,4"])   {deviceName = @"iPhone XS Max";}
    else if ([deviceName isEqualToString:@"iPhone11,2"])   {deviceName = @"iPhone XS";}
    else if ([deviceName isEqualToString:@"iPhone10,6"])   {deviceName = @"iPhone X";}
    
    // 非刘海屏手机
    else if ([deviceName isEqualToString:@"iPhone10,5"])   {deviceName = @"iPhone 8 Plus";}
    else if ([deviceName isEqualToString:@"iPhone10,4"])   {deviceName = @"iPhone 8";}
    else if ([deviceName isEqualToString:@"iPhone10,3"])   {deviceName = @"iPhone X";}
    else if ([deviceName isEqualToString:@"iPhone10,2"])   {deviceName = @"iPhone 8 Plus";}
    else if ([deviceName isEqualToString:@"iPhone10,1"])   {deviceName = @"iPhone 8";}
    else if ([deviceName isEqualToString:@"iPhone9,4"])    {deviceName = @"iPhone 7 Plus";}
    else if ([deviceName isEqualToString:@"iPhone9,3"])    {deviceName = @"iPhone 7";}
    else if ([deviceName isEqualToString:@"iPhone9,2"])    {deviceName = @"iPhone 7 Plus";}
    else if ([deviceName isEqualToString:@"iPhone9,1"])    {deviceName = @"iPhone 7";}
    else if ([deviceName isEqualToString:@"iPhone8,4"])    {deviceName = @"iPhone SE";}
    else if ([deviceName isEqualToString:@"iPhone8,2"])    {deviceName = @"iPhone 6s Plus";}
    else if ([deviceName isEqualToString:@"iPhone8,1"])    {deviceName = @"iPhone 6s";}
    else if ([deviceName isEqualToString:@"iPhone7,2"])    {deviceName = @"iPhone 6";}
    else if ([deviceName isEqualToString:@"iPhone7,1"])    {deviceName = @"iPhone 6 Plus";}
    else if ([deviceName isEqualToString:@"iPhone6,2"])    {deviceName = @"iPhone 5s";}
    else if ([deviceName isEqualToString:@"iPhone6,1"])    {deviceName = @"iPhone 5s";}
    else if ([deviceName isEqualToString:@"iPhone5,4"])    {deviceName = @"iPhone 5c";}
    else if ([deviceName isEqualToString:@"iPhone5,3"])    {deviceName = @"iPhone 5c";}
    else if ([deviceName isEqualToString:@"iPhone5,2"])    {deviceName = @"iPhone 5";}
    else if ([deviceName isEqualToString:@"iPhone5,1"])    {deviceName = @"iPhone 5";}
    else if ([deviceName isEqualToString:@"iPhone4,1"])    {deviceName = @"iPhone 4S";}
    else if ([deviceName isEqualToString:@"iPhone3,3"])    {deviceName = @"iPhone 4";}
    else if ([deviceName isEqualToString:@"iPhone3,2"])    {deviceName = @"iPhone 4";}
    else if ([deviceName isEqualToString:@"iPhone3,1"])    {deviceName = @"iPhone 4";}
    else if ([deviceName isEqualToString:@"iPhone2,1"])    {deviceName = @"iPhone 3GS";}
    else if ([deviceName isEqualToString:@"iPhone1,2"])    {deviceName = @"iPhone 3G";}
    else if ([deviceName isEqualToString:@"iPhone1,1"])    {deviceName = @"iPhone 2G";}
    
    // iPod touch
    else if ([deviceName isEqualToString:@"iPod7,1"])      {deviceName = @"iPod touch 6G";}
    else if ([deviceName isEqualToString:@"iPod5,1"])      {deviceName = @"iPod touch 5G";}
    else if ([deviceName isEqualToString:@"iPod4,1"])      {deviceName = @"iPod touch 4G";}
    else if ([deviceName isEqualToString:@"iPod3,1"])      {deviceName = @"iPod touch 3G";}
    else if ([deviceName isEqualToString:@"iPod2,1"])      {deviceName = @"iPod touch 2G";}
    else if ([deviceName isEqualToString:@"iPod1,1"])      {deviceName = @"iPod touch 1G";}
    
    // iPad
    else if ([deviceName isEqualToString:@"iPad8,1"])      {deviceName = @"iPad Pro 11";}
    else if ([deviceName isEqualToString:@"iPad8,2"])      {deviceName = @"iPad Pro 11";}
    else if ([deviceName isEqualToString:@"iPad8,3"])      {deviceName = @"iPad Pro 11";}
    else if ([deviceName isEqualToString:@"iPad8,4"])      {deviceName = @"iPad Pro 11";}
    else if ([deviceName isEqualToString:@"iPad8,5"])      {deviceName = @"iPad Pro 3G";}
    else if ([deviceName isEqualToString:@"iPad8,6"])      {deviceName = @"iPad Pro 3G";}
    else if ([deviceName isEqualToString:@"iPad8,7"])      {deviceName = @"iPad Pro 3G";}
    else if ([deviceName isEqualToString:@"iPad8,8"])      {deviceName = @"iPad Pro 3G";}
    else if ([deviceName isEqualToString:@"iPad7,6"])      {deviceName = @"iPad 6";}
    else if ([deviceName isEqualToString:@"iPad7,5"])      {deviceName = @"iPad 6";}
    else if ([deviceName isEqualToString:@"iPad7,4"])      {deviceName = @"iPad Pro";}
    else if ([deviceName isEqualToString:@"iPad7,3"])      {deviceName = @"iPad Pro";}
    else if ([deviceName isEqualToString:@"iPad7,2"])      {deviceName = @"iPad Pro";}
    else if ([deviceName isEqualToString:@"iPad7,1"])      {deviceName = @"iPad Pro";}
    else if ([deviceName isEqualToString:@"iPad6,12"])     {deviceName = @"iPad 5";}
    else if ([deviceName isEqualToString:@"iPad6,11"])     {deviceName = @"iPad 5";}
    else if ([deviceName isEqualToString:@"iPad6,8"])      {deviceName = @"iPad Pro";}
    else if ([deviceName isEqualToString:@"iPad6,7"])      {deviceName = @"iPad Pro";}
    else if ([deviceName isEqualToString:@"iPad6,4"])      {deviceName = @"iPad Pro";}
    else if ([deviceName isEqualToString:@"iPad6,3"])      {deviceName = @"iPad Pro";}
    else if ([deviceName isEqualToString:@"iPad5,4"])      {deviceName = @"iPad Air 2";}
    else if ([deviceName isEqualToString:@"iPad5,3"])      {deviceName = @"iPad Air 2";}
    else if ([deviceName isEqualToString:@"iPad5,2"])      {deviceName = @"iPad Mini 4";}
    else if ([deviceName isEqualToString:@"iPad5,1"])      {deviceName = @"iPad Mini 4";}
    else if ([deviceName isEqualToString:@"iPad4,9"])      {deviceName = @"iPad Mini 3";}
    else if ([deviceName isEqualToString:@"iPad4,8"])      {deviceName = @"iPad Mini 3";}
    else if ([deviceName isEqualToString:@"iPad4,7"])      {deviceName = @"iPad Mini 3";}
    else if ([deviceName isEqualToString:@"iPad4,6"])      {deviceName = @"iPad Mini";}
    else if ([deviceName isEqualToString:@"iPad4,5"])      {deviceName = @"iPad Mini";}
    else if ([deviceName isEqualToString:@"iPad4,4"])      {deviceName = @"iPad Mini";}
    else if ([deviceName isEqualToString:@"iPad4,3"])      {deviceName = @"iPad Air";}
    else if ([deviceName isEqualToString:@"iPad4,2"])      {deviceName = @"iPad Air";}
    else if ([deviceName isEqualToString:@"iPad4,1"])      {deviceName = @"iPad Air";}
    else if ([deviceName isEqualToString:@"iPad3,6"])      {deviceName = @"iPad 4";}
    else if ([deviceName isEqualToString:@"iPad3,5"])      {deviceName = @"iPad 4";}
    else if ([deviceName isEqualToString:@"iPad3,4"])      {deviceName = @"iPad 4";}
    else if ([deviceName isEqualToString:@"iPad3,3"])      {deviceName = @"iPad 3";}
    else if ([deviceName isEqualToString:@"iPad3,2"])      {deviceName = @"iPad 3";}
    else if ([deviceName isEqualToString:@"iPad3,1"])      {deviceName = @"iPad 3";}
    else if ([deviceName isEqualToString:@"iPad2,7"])      {deviceName = @"iPad Mini";}
    else if ([deviceName isEqualToString:@"iPad2,6"])      {deviceName = @"iPad Mini";}
    else if ([deviceName isEqualToString:@"iPad2,5"])      {deviceName = @"iPad Mini";}
    else if ([deviceName isEqualToString:@"iPad2,4"])      {deviceName = @"iPad 2";}
    else if ([deviceName isEqualToString:@"iPad2,3"])      {deviceName = @"iPad 2";}
    else if ([deviceName isEqualToString:@"iPad2,2"])      {deviceName = @"iPad 2";}
    else if ([deviceName isEqualToString:@"iPad2,1"])      {deviceName = @"iPad 2";}
    else if ([deviceName isEqualToString:@"iPad1,2"])      {deviceName = @"iPad 3G";}
    else if ([deviceName isEqualToString:@"iPad1,1"])      {deviceName = @"iPad";}
    
    // Apple TV
    else if ([deviceName isEqualToString:@"AppleTV1,1"])      {deviceName = @"Apple TV 1G";}
    else if ([deviceName isEqualToString:@"AppleTV2,1"])      {deviceName = @"Apple TV 2G";}
    else if ([deviceName isEqualToString:@"AppleTV3,1"])      {deviceName = @"Apple TV 3G";}
    else if ([deviceName isEqualToString:@"AppleTV4,1"])      {deviceName = @"Apple TV 3 2G";}
    else if ([deviceName isEqualToString:@"AppleTV5,1"])      {deviceName = @"Apple TV 4G";}
    
    // Watch
    else if ([deviceName isEqualToString:@"Watch1,1"])      {deviceName = @"Apple Watch (38 mm)";}
    else if ([deviceName isEqualToString:@"Watch1,2"])      {deviceName = @"Apple Watch (42 mm)";}
    else if ([deviceName isEqualToString:@"Watch2,3"])      {deviceName = @"Apple Watch Series 2 (38 mm)";}
    else if ([deviceName isEqualToString:@"Watch2,4"])      {deviceName = @"Apple Watch Series 2 (42 mm)";}
    else if ([deviceName isEqualToString:@"Watch2,6"])      {deviceName = @"Apple Watch Series 1 (38 mm)";}
    else if ([deviceName isEqualToString:@"Watch2,7"])      {deviceName = @"Apple Watch Series 1 (42 mm)";}
    else if ([deviceName isEqualToString:@"Watch3,1"])      {deviceName = @"Apple Watch Series 3 (38 mm/Cellular)";}
    else if ([deviceName isEqualToString:@"Watch3,2"])      {deviceName = @"Apple Watch Series 3 (42 mm/Cellular)";}
    else if ([deviceName isEqualToString:@"Watch3,3"])      {deviceName = @"Apple Watch Series 3 (38 mm)";}
    else if ([deviceName isEqualToString:@"Watch3,4"])      {deviceName = @"Apple Watch Series 3 (42 mm)";}
    else if ([deviceName isEqualToString:@"Watch4,1"])      {deviceName = @"Apple Watch Series 4 (40 mm)";}
    else if ([deviceName isEqualToString:@"Watch4,2"])      {deviceName = @"Apple Watch Series 4 (44 mm)";}
    else if ([deviceName isEqualToString:@"Watch4,3"])      {deviceName = @"Apple Watch Series 4 (40 mm/Cellular)";}
    else if ([deviceName isEqualToString:@"Watch4,4"])      {deviceName = @"Apple Watch Series 4 (42 mm/Cellular)";}
    
    // Simulator
    else if ([deviceName isEqualToString:@"i386"])         {deviceName = [NSString stringWithFormat:@"%@ Simulator", deviceName];}
    else if ([deviceName isEqualToString:@"x86_64"])       {deviceName = [NSString stringWithFormat:@"%@ Simulator", deviceName];}
    
    return deviceName;
}


@end
