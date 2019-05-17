//
//  YHImageBrowser.h
//  HiFanSmooth
//
//  Created by apple on 2019/5/16.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHImageBrowserCellDataProtocol.h"
#import "YHImageBrowserCellData.h"

NS_ASSUME_NONNULL_BEGIN
@class YHImageBrowser;
@protocol YHImageBrowserDelegate <NSObject>
/**
 * YHImageBrowser长按.
 * 如果不实现该协议，长按时，框架内部使用默认的sheetView.
 */
- (void)imageBrowser:(YHImageBrowser *)imageBrowser imageData:(YHImage *)imagedata longGesture:(UILongPressGestureRecognizer *)longGesture;




@end





@interface YHImageBrowser : UIView

@property (nonatomic, strong) NSArray<id<YHImageBrowserCellDataProtocol>> *dataSourceArray;

@property (nonatomic, weak) id<YHImageBrowserDelegate> delegate;

- (void)show;

@end

NS_ASSUME_NONNULL_END
