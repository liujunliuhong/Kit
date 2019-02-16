//
//  YHTextViewChainModel.m
//  chanDemo
//
//  Created by apple on 2018/12/13.
//  Copyright © 2018 银河. All rights reserved.
//

#import "YHTextViewChainModel.h"

@implementation YHTextViewChainModel

@end




@implementation UITextView (YH_Chain)
- (YHTextViewChainModel *)yh_textViewChain{
    return [[YHTextViewChainModel alloc] initWithView:self];
}
+ (YHTextViewChainModel *)yh_creat{
    UITextView *textView = [[UITextView alloc] init];
    return [[YHTextViewChainModel alloc] initWithView:textView];
}
@end
