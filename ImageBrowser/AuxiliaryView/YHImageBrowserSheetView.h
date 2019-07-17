//
//  YHImageBrowserSheetView.h
//  HiFanSmooth
//
//  Created by 银河 on 2019/5/17.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class YHImageBrowserSheetView;
@protocol YHImageBrowserSheetViewDataSource <NSObject>
@required;
/**
 * 数据源
 */
- (NSArray<NSString *> *)titlesForSheetView:(YHImageBrowserSheetView *)sheetView;
@end



@protocol YHImageBrowserSheetViewDelegate <NSObject>
@optional;
/**
 * CanelButton是否隐藏（默认NO）
 * 当为YES，titleForCancelWithSheetView和sheetViewDicClickCancel这两个回调无效
 */
- (BOOL)shouldHideCancelForSheetView:(YHImageBrowserSheetView *)sheetView;

/**
 * CanelButton的标题（默认"取消"）
 */
- (NSString *)titleForCancelWithSheetView:(YHImageBrowserSheetView *)sheetView;

/**
 * 点击索引回调
 */
- (void)sheetView:(YHImageBrowserSheetView *)sheetView didClickIndex:(int)clickIndex;

/**
 * 点击了CanelButton
 * 当实现了此协议，如果需要隐藏sheetView，请自行调用hide方法
 */
- (void)sheetViewDicClickCancel:(YHImageBrowserSheetView *)sheetView;

/**
 * SheetView隐藏回调
 */
- (void)sheetViewDidHide:(YHImageBrowserSheetView *)sheetView;

@end



/**
 * 长按从底部弹出来的SheetView
 * 内部已做了横竖屏切换的适配
 */
@interface YHImageBrowserSheetView : UIView

@property (nonatomic, weak) id<YHImageBrowserSheetViewDataSource> dataSource;

@property (nonatomic, weak) id<YHImageBrowserSheetViewDelegate> delegate;

/**
 * 显示SheetView
 */
- (void)show;

/**
 * 隐藏SheetView
 */
- (void)hide;
@end

NS_ASSUME_NONNULL_END
