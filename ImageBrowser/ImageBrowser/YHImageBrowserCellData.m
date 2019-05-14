//
//  YHImageBrowserCellData.m
//  HiFanSmooth
//
//  Created by apple on 2019/5/14.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHImageBrowserCellData.h"

#import <FLAnimatedImage/FLAnimatedImage.h>

#import "YHImageBrowserWebImageManager.h"
#import "YHImageBrowserCell.h"

@interface YHImageBrowserCellData()
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) FLAnimatedImage *image;
@end


@implementation YHImageBrowserCellData



- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



- (void)loadData{
    if (self.isLoading) {
        
    } else {
        
    }
}


- (void)loadNetworkImage{
    if (!self.URL) {
        return;
    }
    
    [YHImageBrowserWebImageManager queryCacheImageWithKey:self.URL completionBlock:^(UIImage * _Nullable image, NSData * _Nullable data) {
        
    }];
    
}


#pragma mark ------------------ YHImageBrowserDataProtocol ------------------
- (Class)yh_cellClass{
    return [YHImageBrowserCell class];
}


@end
