//
//  UIView+YHFrame.m
//  chanDemo
//
//  Created by 银河 on 2018/11/8.
//  Copyright © 2018 银河. All rights reserved.
//

#import "UIView+YHFrame.h"

@implementation UIView (YHFrame)

#pragma mark - origin
- (CGPoint)yh_origin{
    return self.frame.origin;
}
- (void)setYh_origin:(CGPoint)yh_origin{
    CGRect frame = self.frame;
    frame.origin = yh_origin;
    self.frame = frame;
}
- (CGFloat)yh_x{
    return self.frame.origin.x;
}
- (void)setYh_x:(CGFloat)yh_x{
    CGRect frame = self.frame;
    frame.origin.x = yh_x;
    self.frame = frame;
}
- (CGFloat)yh_y{
    return self.frame.origin.y;
}
- (void)setYh_y:(CGFloat)yh_y{
    CGRect frame = self.frame;
    frame.origin.y = yh_y;
    self.frame = frame;
}


#pragma mark - Size
- (CGSize)yh_size{
    return self.frame.size;
}
- (void)setYh_size:(CGSize)yh_size{
    CGRect frame = self.frame;
    frame.size = yh_size;
    self.frame = frame;
}
- (CGFloat)yh_width{
    return self.frame.size.width;
}
- (void)setYh_width:(CGFloat)yh_width{
    CGRect frame = self.frame;
    frame.size.width = yh_width;
    self.frame = frame;
}
- (CGFloat)yh_height{
    return self.frame.size.height;
}
- (void)setYh_height:(CGFloat)yh_height{
    CGRect frame = self.frame;
    frame.size.height = yh_height;
    self.frame = frame;
}

#pragma mark - Center
- (CGFloat)yh_centerX{
    return self.center.x;
}
- (void)setYh_centerX:(CGFloat)yh_centerX{
    self.center = CGPointMake(yh_centerX, self.center.y);
}
- (CGFloat)yh_centerY{
    return self.center.y;
}
- (void)setYh_centerY:(CGFloat)yh_centerY{
    self.center = CGPointMake(self.center.x, yh_centerY);
}

#pragma mark - Edge
- (CGFloat)yh_top{
    return self.frame.origin.y;
}
- (void)setYh_top:(CGFloat)yh_top{
    CGRect frame = self.frame;
    frame.origin.y = yh_top;
    self.frame = frame;
}
- (CGFloat)yh_bottom{
    return self.frame.origin.y + self.frame.size.height;
}
- (void)setYh_bottom:(CGFloat)yh_bottom{
    CGRect frame = self.frame;
    frame.origin.y = yh_bottom - self.frame.size.height;
    self.frame = frame;
}
- (CGFloat)yh_left{
    return self.frame.origin.x;
}
- (void)setYh_left:(CGFloat)yh_left{
    CGRect frame = self.frame;
    frame.origin.x = yh_left;
    self.frame = frame;
}
- (CGFloat)yh_right{
    return self.frame.origin.x + self.frame.size.width;
}
- (void)setYh_right:(CGFloat)yh_right{
    CGRect frame = self.frame;
    frame.origin.x = yh_right - self.frame.size.width;
    self.frame = frame;
}



@end
