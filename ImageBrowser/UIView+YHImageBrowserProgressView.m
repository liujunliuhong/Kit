//
//  UIView+YHImageBrowserProgressView.m
//  HiFanSmooth
//
//  Created by apple on 2019/5/17.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "UIView+YHImageBrowserProgressView.h"
#import <objc/message.h>

#if __has_include(<Masonry/Masonry.h>)
    #import <Masonry/Masonry.h>
#elif __has_include("Masonry.h")
    #import "Masonry.h"
#endif

#define kProgressWidth         60.0
#define kProgressHeight        60.0

static char yh_imageBrowserView_associated_key;

@interface YBImageBrowserProgressDrawView : UIView
@property (nonatomic, assign) CGFloat progress;
@end

@implementation YBImageBrowserProgressDrawView
- (void)drawRect:(CGRect)rect {
    if (self.isHidden) return;
    CGFloat strokeWidth = 3;
    CGFloat radius = MIN(kProgressWidth, kProgressHeight) / 2.0 - strokeWidth / 2.0;
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    [[UIColor lightGrayColor] setStroke];
    UIBezierPath *bottomPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    bottomPath.lineWidth = 4.0;
    bottomPath.lineCapStyle = kCGLineCapRound;
    bottomPath.lineJoinStyle = kCGLineCapRound;
    [bottomPath stroke];
    
    [[UIColor whiteColor] setStroke];
    UIBezierPath *activePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-M_PI / 2.0 endAngle:M_PI * 2 * _progress - M_PI / 2.0 clockwise:true];
    activePath.lineWidth = strokeWidth;
    activePath.lineCapStyle = kCGLineCapRound;
    activePath.lineJoinStyle = kCGLineCapRound;
    [activePath stroke];
}
@end



@interface YHImageBrowserProgressView : UIView
@property (nonatomic, strong) UILabel     *textLabel;
@property (nonatomic, strong) YBImageBrowserProgressDrawView *drawView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

- (void)showProgres:(CGFloat)progress;
- (void)showLoading;
@end


@implementation YHImageBrowserProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        self.userInteractionEnabled = NO;
        
        [self addSubview:self.textLabel];
        [self addSubview:self.drawView];
        [self addSubview:self.activityIndicatorView];
        
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.drawView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)showProgres:(CGFloat)progress{
    self.drawView.hidden = NO;
    self.textLabel.hidden = NO;
    [self.activityIndicatorView stopAnimating];
    self.activityIndicatorView.hidden = YES;
    
    self.drawView.progress = progress;
    [self.drawView setNeedsDisplay];
    
    self.textLabel.text = [NSString stringWithFormat:@"%.2f%@", progress * 100, @"%"];
}

- (void)showLoading{
    self.drawView.hidden = YES;
    self.textLabel.hidden = YES;
    [self.activityIndicatorView startAnimating];
    self.activityIndicatorView.hidden = NO;
}

#pragma mark ------------------ Getter ------------------
- (YBImageBrowserProgressDrawView *)drawView {
    if (!_drawView) {
        _drawView = [YBImageBrowserProgressDrawView new];
        _drawView.backgroundColor = [UIColor clearColor];
    }
    return _drawView;
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [UILabel new];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.numberOfLines = 0;
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.userInteractionEnabled = NO;
    }
    return _textLabel;
}

- (UIActivityIndicatorView *)activityIndicatorView{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.hidesWhenStopped = YES;
    }
    return _activityIndicatorView;
}

@end





@interface UIView()
@property (nonatomic, strong) YHImageBrowserProgressView *yh_progressView;
@end


@implementation UIView (YHImageBrowserProgressView)
- (void)yh_showProgressViewWithValue:(CGFloat)value{
    [self yh_showProgressView];
    [self.yh_progressView showProgres:value];
}

- (void)yh_showLoading{
    [self yh_showProgressView];
    [self.yh_progressView showLoading];
}

- (void)yh_hideProgressView{
    YHImageBrowserProgressView *progressView = self.yh_progressView;
    if (progressView && progressView.superview) {
        self.yh_progressView = nil;
        [progressView removeFromSuperview];
        progressView = nil;
    }
}

- (void)yh_showProgressView {
    YHImageBrowserProgressView *progressView = self.yh_progressView;
    if (!progressView) {
        progressView = [YHImageBrowserProgressView new];
        self.yh_progressView = progressView;
    }
    
    if (!progressView.superview) {
        [self addSubview:progressView];
        [progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
            make.width.mas_equalTo(kProgressWidth);
            make.height.mas_equalTo(kProgressHeight);
        }];
    }
}





- (void)setYh_progressView:(YHImageBrowserProgressView * _Nonnull)yh_progressView{
    objc_setAssociatedObject(self, &yh_imageBrowserView_associated_key, yh_progressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (YHImageBrowserProgressView *)yh_progressView{
    return objc_getAssociatedObject(self, &yh_imageBrowserView_associated_key);
}
@end
