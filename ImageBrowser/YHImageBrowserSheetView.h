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
- (NSArray<NSString *> *)titlesForSheetView:(YHImageBrowserSheetView *)sheetView;
@end



@protocol YHImageBrowserSheetViewDelegate <NSObject>
@optional;
- (BOOL)shouldHideCancelForSheetView:(YHImageBrowserSheetView *)sheetView;

- (NSString *)titleForCancelWithSheetView:(YHImageBrowserSheetView *)sheetView;

- (void)sheetView:(YHImageBrowserSheetView *)sheetView didClickIndex:(int)clickIndex;

- (void)sheetViewDicClickCancel:(YHImageBrowserSheetView *)sheetView;

- (void)sheetViewDidHide:(YHImageBrowserSheetView *)sheetView;

@end



/**
 * 长按从底部弹出来的SheetView
 */
@interface YHImageBrowserSheetView : UIView
@property (nonatomic, weak) id<YHImageBrowserSheetViewDataSource> dataSource;
@property (nonatomic, weak) id<YHImageBrowserSheetViewDelegate> delegate;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
