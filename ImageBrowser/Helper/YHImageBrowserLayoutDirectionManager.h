//
//  YHImageBrowserLayoutDirectionManager.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/16.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YHImageBrowserLayoutDirection) {
    YHImageBrowserLayoutDirection_Vertical,         // 水平
    YHImageBrowserLayoutDirection_Horizontal,       // 垂直
};

@interface YHImageBrowserLayoutDirectionManager : NSObject

@property (nonatomic, copy) void(^layoutDirectionChangedBlock)(YHImageBrowserLayoutDirection direction);

- (void)startObserve;

+ (YHImageBrowserLayoutDirection)getCurrntLayoutDirection;

@end

NS_ASSUME_NONNULL_END
