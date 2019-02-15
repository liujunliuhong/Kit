//
//  UIView+YHFrame.h
//  chanDemo
//
//  Created by 银河 on 2018/11/8.
//  Copyright © 2018 银河. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UIView (YHFrame)


#pragma mark - Origin
@property (nonatomic, assign) CGPoint yh_origin;
@property (nonatomic, assign) CGFloat yh_x;
@property (nonatomic, assign) CGFloat yh_y;


#pragma mark - Size
@property (nonatomic, assign) CGSize yh_size;
@property (nonatomic, assign) CGFloat yh_width;
@property (nonatomic, assign) CGFloat yh_height;

#pragma mark - Center
@property (nonatomic, assign) CGFloat yh_centerX;
@property (nonatomic, assign) CGFloat yh_centerY;

#pragma mark - Edge
@property (nonatomic, assign) CGFloat yh_top;
@property (nonatomic, assign) CGFloat yh_bottom;
@property (nonatomic, assign) CGFloat yh_left;
@property (nonatomic, assign) CGFloat yh_right;

@end
NS_ASSUME_NONNULL_END
