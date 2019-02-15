//
//  YHCustomNavigationBar.m
//  Kit
//
//  Created by apple on 2019/1/24.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHCustomNavigationBar.h"
#import <Masonry/Masonry.h>

@interface YHCustomNavigationBar()
@property (nonatomic, strong) UIView *barContentView;
@property (nonatomic, strong) UIView *bottomContentView;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, assign) CGFloat currentBottomViewHeight;
@end


@implementation YHCustomNavigationBar

- (void)dealloc{
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
        self.leftHorizontalEdgeInset = 0.0;
        self.rightHorizontalEdgeInset = 0.0;
        
        [self addSubview:self.bottomContentView];
        [self addSubview:self.barContentView];
        [self addSubview:self.line];
        
        __weak typeof(self) weakSelf = self;
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.equalTo(weakSelf);
            make.height.mas_equalTo(1.0);
        }];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
}

#pragma mark - Methods

- (void)updateSubViewsConstraint{
    __weak typeof(self) weakSelf = self;
    [self.bottomContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(weakSelf.currentBottomViewHeight);
    }];
    
    
    [self.barContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf.bottomContentView.mas_top);
        make.height.mas_equalTo([YHCustomNavigationBar barHeight]);
    }];
    
    
    __block UIView *leftView = nil;
    if (self.leftViews) {
        [self.leftViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (!leftView) {
                    make.left.equalTo(weakSelf.barContentView).mas_offset(weakSelf.leftHorizontalEdgeInset);
                    make.bottom.equalTo(weakSelf.barContentView);
                    make.top.equalTo(weakSelf.barContentView);
                    make.width.mas_equalTo(obj.frame.size.width > 0 ? obj.frame.size.width : [YHCustomNavigationBar itemBaseWidth]);
                } else {
                    make.left.equalTo(leftView.mas_right);
                    make.bottom.equalTo(weakSelf.barContentView);
                    make.top.equalTo(weakSelf.barContentView);
                    make.width.mas_equalTo(obj.frame.size.width > 0 ? obj.frame.size.width : [YHCustomNavigationBar itemBaseWidth]);
                }
            }];
            leftView = obj;
        }];
    }
    
    __block UIView *rightView = nil;
    if (self.rightViews) {
        [self.rightViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
                if (!rightView) {
                    make.right.equalTo(weakSelf.barContentView).mas_offset(-weakSelf.rightHorizontalEdgeInset);
                    make.bottom.equalTo(weakSelf.barContentView);
                    make.top.equalTo(weakSelf.barContentView);
                    make.width.mas_equalTo(obj.frame.size.width > 0 ? obj.frame.size.width : [YHCustomNavigationBar itemBaseWidth]);
                } else {
                    make.right.equalTo(rightView.mas_left);
                    make.bottom.equalTo(weakSelf.barContentView);
                    make.top.equalTo(weakSelf.barContentView);
                    make.width.mas_equalTo(obj.frame.size.width > 0 ? obj.frame.size.width : [YHCustomNavigationBar itemBaseWidth]);
                }
            }];
            rightView = obj;
        }];
    }
    
    [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.bottom.equalTo(weakSelf);
        make.height.mas_equalTo(1.0);
    }];
    
    [self.superview layoutIfNeeded];// 获取自定义导航栏的frame
    [self layoutIfNeeded];// 获取自定义导航栏子View的frame
    [self.barContentView layoutIfNeeded];// 获取barContentView子View的frame
    
    CGFloat left_origin_x = leftView ? leftView.frame.origin.x + leftView.frame.size.width : self.leftHorizontalEdgeInset;
    CGFloat right_origin_x = rightView ? self.frame.size.width - rightView.frame.origin.x : self.rightHorizontalEdgeInset;
    
    CGFloat max_margin = MAX(left_origin_x, right_origin_x);
    CGFloat titleViewWidth = self.frame.size.width - max_margin * 2;
    
    [self.titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.barContentView);
        make.top.equalTo(weakSelf.barContentView);
        make.centerX.equalTo(weakSelf.barContentView);
        make.width.mas_equalTo(titleViewWidth < 0 ? 0 : titleViewWidth);
    }];
    
    
//    [self layoutIfNeeded];// 再次获取titleView的frame
//
//    NSLog(@"self.frame:%@", NSStringFromCGRect(self.frame));
//    NSLog(@"self.barContentView.frame:%@", self.barContentView ? NSStringFromCGRect(self.barContentView.frame) : [NSNull null]);
//    NSLog(@"self.bottomView.frame:%@", self.bottomView ? NSStringFromCGRect(self.bottomView.frame) : [NSNull null]);
//    NSLog(@"self.line.frame:%@", NSStringFromCGRect(self.line.frame));
//    NSLog(@"self.titleView.frame:%@", NSStringFromCGRect(self.titleView.frame));
//    if (self.leftViews) {
//        [self.leftViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSLog(@"self.leftViews的各个子View的frame:%@", NSStringFromCGRect(obj.frame));
//        }];
//    }
//    if (self.rightViews) {
//        [self.rightViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            NSLog(@"self.rightViews的各个子View的frame:%@", NSStringFromCGRect(obj.frame));
//        }];
//    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"frame"]) {
        [self updateSubViewsConstraint];
    }
}

+ (CGFloat)itemBaseWidth{
    return 45.0;
}

+ (CGFloat)barHeight{
    return 44.0;
}

#pragma mark - Setter
- (void)setLeftHorizontalEdgeInset:(CGFloat)leftHorizontalEdgeInset{
    if (leftHorizontalEdgeInset <= 0.0) {
        leftHorizontalEdgeInset = 0.0;
    }
    _leftHorizontalEdgeInset = leftHorizontalEdgeInset;
}

- (void)setRightHorizontalEdgeInset:(CGFloat)rightHorizontalEdgeInset{
    if (rightHorizontalEdgeInset <= 0.0) {
        rightHorizontalEdgeInset = 0.0;
    }
    _rightHorizontalEdgeInset = rightHorizontalEdgeInset;
}

- (void)setTitleView:(UIView *)titleView{
    if (_titleView) {
        [_titleView removeFromSuperview];
    }
    
    _titleView = titleView;
    
    [self.barContentView addSubview:_titleView];
}

- (void)setBottomView:(UIView *)bottomView{
    
    self.currentBottomViewHeight = 0.0;
    
    if (!bottomView) {
        return;
    }
    if (_bottomView) {
        [_bottomView removeFromSuperview];
    }
    _bottomView = bottomView;
    
    
    if (_bottomView) {
        
        self.currentBottomViewHeight = _bottomView.frame.size.height;
        
        [self.bottomContentView addSubview:_bottomView];
        
        [_bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.bottom.equalTo(self.bottomContentView);
            make.height.mas_equalTo(self->_bottomView.frame.size.height);
        }];
    }
}

- (void)setLeftViews:(NSArray<UIView *> *)leftViews{
    if (_leftViews && _leftViews.count > 0) {
        [_leftViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeObserver:self forKeyPath:@"frame"];
            [obj removeFromSuperview];
        }];
    }
    
    _leftViews = leftViews;
    
    if (_leftViews) {
        [_leftViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.barContentView addSubview:obj];
            [obj addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }];
    }
}

- (void)setRightViews:(NSArray<UIView *> *)rightViews{
    if (_rightViews && _rightViews.count > 0) {
        [_rightViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeObserver:self forKeyPath:@"frame"];
            [obj removeFromSuperview];
        }];
    }
    
    _rightViews = rightViews;
    
    if (_rightViews) {
        [_rightViews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.barContentView addSubview:obj];
            [obj addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }];
    }
}

#pragma mark - Getter
- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    }
    return _line;
}
- (UIView *)barContentView{
    if (!_barContentView) {
        _barContentView = [[UIView alloc] init];
    }
    return _barContentView;
}
- (UIView *)bottomContentView{
    if (!_bottomContentView) {
        _bottomContentView = [[UIView alloc] init];
        _bottomContentView.clipsToBounds = YES;
    }
    return _bottomContentView;
}
@end





