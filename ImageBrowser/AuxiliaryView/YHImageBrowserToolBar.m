//
//  YHImageBrowserToolBar.m
//  HiFanSmooth
//
//  Created by 银河 on 2019/5/18.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHImageBrowserToolBar.h"
#import "YHMacro.h"
#import "YHImageBrowserDefine.h"

@interface YHImageBrowserToolBar ()
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UILabel *indexLabel;
@end

@implementation YHImageBrowserToolBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.layer addSublayer:self.gradientLayer];
        [self addSubview:self.indexLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
    
    if (YH_DeviceOrientation == UIInterfaceOrientationPortrait || YH_DeviceOrientation == UIInterfaceOrientationPortraitUpsideDown || YH_DeviceOrientation ==  UIInterfaceOrientationUnknown) {
        if (YH_IS_IPHONE_X) {
            self.indexLabel.frame = CGRectMake(0, self.frame.size.height - 50, self.frame.size.width, 50);
        } else {
            self.indexLabel.frame = self.bounds;
        }
    } else {
        self.indexLabel.frame = self.bounds;
    }
}

- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.startPoint = CGPointMake(0.5, 0);
        _gradientLayer.endPoint = CGPointMake(0.5, 1);
        _gradientLayer.colors = @[(id)[UIColor colorWithRed:0  green:0  blue:0 alpha:0.3].CGColor, (id)[UIColor colorWithRed:0  green:0  blue:0 alpha:0].CGColor];
    }
    return _gradientLayer;
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.font = [UIFont boldSystemFontOfSize:15];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
        _indexLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _indexLabel;
}


@end
