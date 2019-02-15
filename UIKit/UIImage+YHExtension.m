//
//  UIImage+YHExtension.m
//  Kit
//
//  Created by apple on 2019/1/17.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "UIImage+YHExtension.h"

@implementation UIImage (YHExtension)

// Color Transfer Picture.
+ (UIImage *)yh_imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
