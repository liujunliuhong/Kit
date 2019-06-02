//
//  YHSystemImagePicker.h
//  FrameDating
//
//  Created by apple on 2019/5/10.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YHSystemImagePickerState) {
    YHSystemImagePicker_Allow,
    YHSystemImagePicker_PhotoDenied,
    YHSystemImagePicker_CameraDenied,
    YHSystemImagePicker_PhotoUnAvailable,
    YHSystemImagePicker_CameraUnAvailable,
};

/**
 * 系统UIImagePickerController封装.
 */
@interface YHSystemImagePicker : NSObject


/**
 系统UIImagePickerController封装.(内部已实现授权)

 @param showVC present UIAlertController的控制器
 @param title UIAlertController的标题
 @param message UIAlertController的信息
 @param alblumTitle 相册标题
 @param cameraTitle 相机标题
 @param cancelTitle 取消标题
 @param completionBlock 回调
 */
+ (void)showIn:(UIViewController *)showVC
         title:(nullable NSString *)title
       message:(nullable NSString *)message
   alblumTitle:(nullable NSString *)alblumTitle
   cameraTitle:(nullable NSString *)cameraTitle
   cancelTitle:(nullable NSString *)cancelTitle
completionBlock:(void(^)(UIImage *_Nullable editImage, NSDictionary<UIImagePickerControllerInfoKey,id> *_Nullable info, YHSystemImagePickerState state))completionBlock;

@end

NS_ASSUME_NONNULL_END
