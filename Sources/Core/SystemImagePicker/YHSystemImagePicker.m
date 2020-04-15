//
//  YHSystemImagePicker.m
//  FrameDating
//
//  Created by apple on 2019/5/10.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHSystemImagePicker.h"
#import <objc/message.h>
#import "YHMacro.h"
#import "YHAuthorizetion.h"

static char yh_system_image_picker_associated_key;
static char yh_system_image_picker_compleetion_associated_key;

@interface YHSystemImagePicker() <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) UIViewController *showVC;
@end

@implementation YHSystemImagePicker

- (void)dealloc{
    YHLog(@"%@ dealloc",NSStringFromClass([self class]));
}

+ (void)showIn:(UIViewController *)showVC
         title:(NSString *)title
       message:(NSString *)message
   alblumTitle:(NSString *)alblumTitle
   cameraTitle:(NSString *)cameraTitle
   cancelTitle:(NSString *)cancelTitle
completionBlock:(void (^)(UIImage * _Nullable, NSDictionary<UIImagePickerControllerInfoKey,id> * _Nullable, YHSystemImagePickerState))completionBlock{
    
    YHSystemImagePicker *picker = [[YHSystemImagePicker alloc] init];
    picker.showVC = showVC;
    objc_setAssociatedObject(showVC, &yh_system_image_picker_associated_key, picker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(picker, &yh_system_image_picker_compleetion_associated_key, completionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alblumAction = [UIAlertAction actionWithTitle:alblumTitle ? alblumTitle : @"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [YHAuthorizetion requestAuthorizetionWithType:YHAuthorizetionType_Photos completion:^(BOOL granted, BOOL isFirst) {
            if (!granted) {
                if (completionBlock) {
                    completionBlock(nil, nil, YHSystemImagePicker_PhotoDenied);
                }
                objc_setAssociatedObject(showVC, &yh_system_image_picker_associated_key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                objc_setAssociatedObject(picker, &yh_system_image_picker_compleetion_associated_key, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
                return ;
            }
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                UIImagePickerController *alnlumPicker = [[UIImagePickerController alloc] init];
                alnlumPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary | UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                alnlumPicker.allowsEditing = YES;
                alnlumPicker.delegate = picker;
                alnlumPicker.modalPresentationStyle = UIModalPresentationFullScreen;
                [showVC presentViewController:alnlumPicker animated:YES completion:nil];
            } else {
                if (completionBlock) {
                    completionBlock(nil, nil, YHSystemImagePicker_PhotoUnAvailable);
                }
                objc_setAssociatedObject(showVC, &yh_system_image_picker_associated_key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                objc_setAssociatedObject(picker, &yh_system_image_picker_compleetion_associated_key, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
            }
        }];
    }];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:cameraTitle ? cameraTitle : @"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [YHAuthorizetion requestAuthorizetionWithType:YHAuthorizetionType_Camera completion:^(BOOL granted, BOOL isFirst) {
            if (!granted) {
                if (completionBlock) {
                    completionBlock(nil, nil, YHSystemImagePicker_CameraDenied);
                }
                objc_setAssociatedObject(showVC, &yh_system_image_picker_associated_key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                objc_setAssociatedObject(picker, &yh_system_image_picker_compleetion_associated_key, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
                return ;
            }
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *cameraPicker = [[UIImagePickerController alloc] init];
                cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                cameraPicker.allowsEditing = YES;
                cameraPicker.delegate = picker;
                cameraPicker.modalPresentationStyle = UIModalPresentationFullScreen;
                [showVC presentViewController:cameraPicker animated:YES completion:nil];
            } else {
                if (completionBlock) {
                    completionBlock(nil, nil, YHSystemImagePicker_CameraUnAvailable);
                }
                objc_setAssociatedObject(showVC, &yh_system_image_picker_associated_key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                objc_setAssociatedObject(picker, &yh_system_image_picker_compleetion_associated_key, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
            }
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle ? cancelTitle : @"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        objc_setAssociatedObject(showVC, &yh_system_image_picker_associated_key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(picker, &yh_system_image_picker_compleetion_associated_key, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }];
    
    [alertController addAction:alblumAction];
    [alertController addAction:cameraAction];
    [alertController addAction:cancelAction];
    
    [showVC presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    objc_setAssociatedObject(self.showVC, &yh_system_image_picker_associated_key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &yh_system_image_picker_compleetion_associated_key, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    void(^block)(UIImage *_Nullable editImage, NSDictionary<UIImagePickerControllerInfoKey,id> *_Nullable info, YHSystemImagePickerState state) = objc_getAssociatedObject(self, &yh_system_image_picker_compleetion_associated_key);
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (block) {
        block(image, info, YHSystemImagePicker_Allow);
    }
    
    objc_setAssociatedObject(self.showVC, &yh_system_image_picker_associated_key, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &yh_system_image_picker_compleetion_associated_key, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
