//
//  YHDragCardConfig.h
//  FrameDating
//
//  Created by apple on 2019/5/22.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YHDragCardConfig : NSObject

@property (nonatomic, assign) int visibleCount;

- (instancetype)init;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
