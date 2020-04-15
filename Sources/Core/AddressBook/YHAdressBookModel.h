//
//  YHAdressBookModel.h
//  chanDemo
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 银河. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface YHAdressBookModel : NSObject

// name.
@property (nonatomic, copy) NSString *name;
// phone.
@property (nonatomic, copy) NSString *phone;
// avatar.
@property (nonatomic, strong, nullable) UIImage *headImage;

@end
NS_ASSUME_NONNULL_END
