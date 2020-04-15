//
//  YHBaseViewChainModel.h
//  chanDemo
//
//  Created by 银河 on 2018/11/7.
//  Copyright © 2018 银河. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//__covariant:协变   程序中的对象应该是可以在不改变程序正确性的前提下被它的子类所替换的
//__contravariant:逆变 父类可以强制转为子类
//NSArray就使用了__covariant修饰符
//__kindof:表示其中的类型为该类型或者其子类
NS_ASSUME_NONNULL_BEGIN
@interface YHBaseViewChainModel <__covariant ObjcType> : NSObject

@property (nonatomic, strong, readonly) __kindof UIView *view;

- (instancetype)initWithView:(__kindof UIView *)view;

#pragma mark -
/**
 *  improves the readability
 */
@property (nonatomic, copy, readonly) ObjcType with;

#pragma mark - view
@property (nonatomic, copy, readonly) ObjcType (^frame)(CGRect frame);
@property (nonatomic, copy, readonly) ObjcType (^backgroundColor)(UIColor *backgroundColor);
@property (nonatomic, copy, readonly) ObjcType (^alpha)(CGFloat alpha);
@property (nonatomic, copy, readonly) ObjcType (^hidden)(BOOL hidden);
@property (nonatomic, copy, readonly) ObjcType (^clipsToBounds)(BOOL clipsToBounds);
@property (nonatomic, copy, readonly) ObjcType (^contentMode)(UIViewContentMode contentMode);
@property (nonatomic, copy, readonly) ObjcType (^tintColor)(UIColor *tintColor);
@property (nonatomic, copy, readonly) ObjcType (^userInteractionEnabled)(BOOL userInteractionEnabled);
#pragma mark - Layer
@property (nonatomic, copy, readonly) ObjcType (^cornerRadius)(CGFloat cornerRadius);
@property (nonatomic, copy, readonly) ObjcType (^maskToBounds)(BOOL maskToBounds);
@property (nonatomic, copy, readonly) ObjcType (^borderWidth)(CGFloat borderWidth);
@property (nonatomic, copy, readonly) ObjcType (^borderColor)(UIColor *borderColor);
@property (nonatomic, copy, readonly) ObjcType (^shadowOffset)(CGSize shadowOffset);
@property (nonatomic, copy, readonly) ObjcType (^shadowRadius)(CGFloat shadowRadius);
@property (nonatomic, copy, readonly) ObjcType (^shadowColor)(UIColor *shadowColor);
@property (nonatomic, copy, readonly) ObjcType (^shadowOpacity)(CGFloat shadowOpacity);


@end
NS_ASSUME_NONNULL_END
