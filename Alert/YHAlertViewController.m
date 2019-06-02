//
//  YHAlertViewController.m
//  FrameDating
//
//  Created by 银河 on 2019/6/2.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHAlertViewController.h"

@interface YHAlertModel : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) UIAlertActionStyle style;
@end

@implementation YHAlertModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"";
        self.style = UIAlertActionStyleDefault;
    }
    return self;
}
@end


@interface YHAlertViewController ()
@property (nonatomic, strong) NSMutableArray<YHAlertModel *> *alertActions;
@property (nonatomic, copy, readonly) void (^alertActionBlock)(YHAlertActionBlock actionBlock);
@end

@implementation YHAlertViewController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle{
    YHAlertViewController *alertController = [super alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    if (alertController) {
        alertController.view.translatesAutoresizingMaskIntoConstraints = NO;
        alertController.alertActions = [NSMutableArray array];
    }
    return alertController;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.didDismissBlock) {
        self.didDismissBlock();
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.didShowBlock) {
        self.didShowBlock();
    }
}

- (YHAlertViewController * _Nonnull (^)(NSString * _Nonnull))addDefaultActionTitle{
    __weak typeof(self) weakSelf = self;
    return ^YHAlertViewController *(NSString *title) {
        YHAlertModel *model = [[YHAlertModel alloc] init];
        model.title = title;
        model.style = UIAlertActionStyleDefault;
        [weakSelf.alertActions addObject:model];
        return weakSelf;
    };
}

- (YHAlertViewController * _Nonnull (^)(NSString * _Nonnull))addCancelActionTitle{
    __weak typeof(self) weakSelf = self;
    return ^YHAlertViewController *(NSString *title) {
        YHAlertModel *model = [[YHAlertModel alloc] init];
        model.title = title;
        model.style = UIAlertActionStyleCancel;
        [weakSelf.alertActions addObject:model];
        return weakSelf;
    };
}

- (YHAlertViewController * _Nonnull (^)(NSString * _Nonnull))addDestructiveActionTitle{
    __weak typeof(self) weakSelf = self;
    return ^YHAlertViewController *(NSString *title) {
        YHAlertModel *model = [[YHAlertModel alloc] init];
        model.title = title;
        model.style = UIAlertActionStyleDestructive;
        [weakSelf.alertActions addObject:model];
        return weakSelf;
    };
}

- (void (^)(YHAlertActionBlock))alertActionBlock{
    __weak typeof(self) weakSelf = self;
    return ^(YHAlertActionBlock actionBlock) {
        [weakSelf.alertActions enumerateObjectsUsingBlock:^(YHAlertModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:obj.title style:obj.style handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (actionBlock) {
                    actionBlock((int)idx, action, strongSelf);
                }
            }];
            [weakSelf addAction:action];
        }];
    };
}

@end

@implementation UIViewController (YHAlertViewController)
- (void)yh_showAlertWithTitle:(NSString *)title
                      message:(NSString *)message
                        style:(UIAlertControllerStyle)style
           actionProcessBlock:(void (^)(YHAlertViewController * _Nonnull))actionProcessBlock
                 didShowBlock:(void (^)(void))didShowBlock
              didDismissBlock:(void (^)(void))didDismissBlock actionBlock:(YHAlertActionBlock)actionBlock{
    YHAlertViewController *alertController = [YHAlertViewController alertControllerWithTitle:title message:message preferredStyle:style];
    if (!alertController) {
        return;
    }
    if (!actionProcessBlock) {
        return;
    }
    
    actionProcessBlock(alertController);
    alertController.alertActionBlock(actionBlock);
    
    alertController.didShowBlock = didShowBlock;
    alertController.didDismissBlock = didDismissBlock;
    
    alertController.popoverPresentationController.sourceView = self.view;
    alertController.popoverPresentationController.sourceRect = CGRectMake(0,0,1.0,1.0);
    
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
