//
//  YHImageBrowserCell.m
//  HiFanSmooth
//
//  Created by apple on 2019/5/14.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHImageBrowserCell.h"
#import "YHImageBrowserCellProtocol.h"


#import <FLAnimatedImage/FLAnimatedImage.h>

@interface YHImageBrowserCell() <YHImageBrowserCellProtocol>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) FLAnimatedImageView *mainImageView;
@end


@implementation YHImageBrowserCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.mainScrollView];
        [self.mainScrollView addSubview:self.mainImageView];
        
    }
    return self;
}

- (void)prepareForReuse{
    // 复原
    self.mainScrollView.zoomScale = 1;
    self.mainImageView.image = nil;
    [super prepareForReuse];
}


- (void)updateMainScrollViewSize:(CGSize)mainScrollViewSize{
    self.mainScrollView.frame = CGRectMake(0, 0, mainScrollViewSize.width, mainScrollViewSize.height);
}


#pragma mark ------------------ YHImageBrowserCellProtocol ------------------
- (void)yh_setCellData:(id<YHImageBrowserDataProtocol>)data{
    
}





























































#pragma mark ------------------ Getter ------------------
- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.delegate = self;
        //_mainScrollView.showsVerticalScrollIndicator = NO;
        //_mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.maximumZoomScale = 1;
        _mainScrollView.minimumZoomScale = 1;
        _mainScrollView.alwaysBounceVertical = NO;
        _mainScrollView.alwaysBounceHorizontal = NO;
        if (@available(iOS 11.0, *)) {
            _mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mainScrollView;
}

- (FLAnimatedImageView *)mainImageView{
    if (!_mainImageView) {
        _mainImageView = [[FLAnimatedImageView alloc] init];
    }
    return _mainImageView;
}

@end

