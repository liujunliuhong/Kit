//
//  YHASNetworkImageNode.m
//  HiFanSmooth
//
//  Created by apple on 2019/3/27.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHASNetworkImageNode.h"

@interface YHASNetworkImageNode()
@property (nonatomic, strong) ASDisplayNode *imageURLNode;
@property (nonatomic, strong) SDAnimatedImageView *animatedImageView;
@property (nonatomic, strong) ASButtonNode *gifTagNode;
@end

@implementation YHASNetworkImageNode
- (instancetype)init
{
    self = [super init];
    if (self) {
        __weak typeof(self) weakSelf = self;
        self.imageURLNode = [[ASImageNode alloc] initWithViewBlock:^UIView * _Nonnull{
            return weakSelf.animatedImageView;
        }];
        [self addSubnode:self.imageURLNode];
        
        
        self.gifTagNode = [[ASButtonNode alloc] init];
        [self.gifTagNode setTitle:@"GIF" withFont:[UIFont systemFontOfSize:8] withColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.gifTagNode.style.preferredSize = CGSizeMake(25, 12);
        self.gifTagNode.backgroundColor = [UIColor grayColor];
        self.gifTagNode.hidden = YES;
        [self addSubnode:self.gifTagNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    ASRelativeLayoutSpec *gifTagSpec = [ASRelativeLayoutSpec relativePositionLayoutSpecWithHorizontalPosition:ASRelativeLayoutSpecPositionEnd verticalPosition:ASRelativeLayoutSpecPositionStart sizingOption:ASRelativeLayoutSpecSizingOptionDefault child:self.gifTagNode];
    ASOverlayLayoutSpec *spec = [ASOverlayLayoutSpec overlayLayoutSpecWithChild:self.imageURLNode overlay:gifTagSpec];
    return [ASWrapperLayoutSpec wrapperWithLayoutElement:spec];
}


- (void)setURL:(NSString *)URL placeholdeImage:(UIImage *)placeholdeImage contentMode:(UIViewContentMode)contentMode{
    ASDisplayNode *tmpNode = self.imageURLNode;
    self.gifTagNode.hidden = ![URL hasSuffix:@"gif"];
    dispatch_async(dispatch_get_main_queue(), ^{
        SDAnimatedImageView *animatedImageView = (SDAnimatedImageView *)tmpNode.view;
        animatedImageView.contentMode = contentMode;
        [animatedImageView sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:placeholdeImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [animatedImageView setNeedsLayout];
        }];
    });
}
- (void)setImage:(UIImage *)image contentMode:(UIViewContentMode)contentMode{
    ASDisplayNode *tmpNode = self.imageURLNode;
    self.gifTagNode.hidden = true;
    dispatch_async(dispatch_get_main_queue(), ^{
        SDAnimatedImageView *animatedImageView = (SDAnimatedImageView *)tmpNode.view;
        if (image) {
            animatedImageView.image = image;
            animatedImageView.contentMode = contentMode;
        }
    });
}
#pragma mark ------------------ Setter ------------------
- (void)setURL:(NSString *)URL{
    _URL = URL;
    ASDisplayNode *tmpNode = self.imageURLNode;
    self.gifTagNode.hidden = ![URL hasSuffix:@"gif"];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        SDAnimatedImageView *animatedImageView = (SDAnimatedImageView *)tmpNode.view;
        [animatedImageView sd_setImageWithURL:[NSURL URLWithString:self->_URL] placeholderImage:weakSelf.placeholdeImage completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [animatedImageView layoutIfNeeded];
            [animatedImageView setNeedsLayout];
        }];
    });
}

- (void)setContentMode:(UIViewContentMode)contentMode{
    _contentMode = contentMode;
    ASDisplayNode *tmpNode = self.imageURLNode;
    dispatch_async(dispatch_get_main_queue(), ^{
        SDAnimatedImageView *animatedImageView = (SDAnimatedImageView *)tmpNode.view;
        animatedImageView.contentMode = self->_contentMode;
    });
}

#pragma mark Getter
- (SDAnimatedImageView *)animatedImageView{
    if (!_animatedImageView) {
        _animatedImageView = [[SDAnimatedImageView alloc] init];
        _animatedImageView.shouldCustomLoopCount = YES;
        _animatedImageView.animationRepeatCount = NSIntegerMax;
        _animatedImageView.clipsToBounds = YES;
    }
    return _animatedImageView;
}
@end














//@interface SDWebImageDownloader (YHASCustomDownloadImage) <ASImageCacheProtocol, ASImageDownloaderProtocol>
//
//@end
//
//
//
//@implementation SDWebImageDownloader (YHASCustomDownloadImage)
//#pragma mark ------------------ ASImageDownloaderProtocol ------------------
//- (id)downloadImageWithURL:(NSURL *)URL callbackQueue:(dispatch_queue_t)callbackQueue downloadProgress:(ASImageDownloaderProgress)downloadProgress completion:(ASImageDownloaderCompletion)completion{
//    return [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:URL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
//        CGFloat progress = expectedSize == 0 ? 0 : (receivedSize / expectedSize);
////        NSLog(@"%f", progress);
//        if (downloadProgress) {
//            downloadProgress(progress);
//        }
//
//    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
//        if (image) {
//            [[SDImageCache sharedImageCache] storeImage:image forKey:URL.absoluteString completion:nil];
//        }
//        if (completion) {
//            completion(image, error, nil, nil);
//        }
//    }];
//}
//
//- (void)cancelImageDownloadForIdentifier:(id)downloadIdentifier{
//    [[SDWebImageDownloader sharedDownloader] cancel:downloadIdentifier];
//}
//
//#pragma mark ------------------ ASImageCacheProtocol ------------------
//- (void)cachedImageWithURL:(NSURL *)URL callbackQueue:(dispatch_queue_t)callbackQueue completion:(ASImageCacherCompletion)completion{
//    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:URL.absoluteString];
//    if (completion) {
//        completion(image);
//    }
//}
//
//@end
//
//
//
//@interface ASNetworkImageNode (YHASCustomNetImage)
//+ (ASNetworkImageNode *)yh_shared;
//@end
//
//
//
//@implementation ASNetworkImageNode (YHASCustomNetImage)
//+ (ASNetworkImageNode *)yh_shared{
//    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
//    return [[ASNetworkImageNode alloc] initWithCache:downloader downloader:downloader];
//}
//@end
//

