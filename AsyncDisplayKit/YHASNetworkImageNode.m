//
//  YHASNetworkImageNode.m
//  HiFanSmooth
//
//  Created by apple on 2019/3/27.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHASNetworkImageNode.h"
#import <PINCache/PINCache.h>
#import <PINRemoteImage/PINRemoteImage.h>
#import <SDWebImage/SDImageCache.h>

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


@interface YHASNetworkImageNode() <ASNetworkImageNodeDelegate>
@property (nonatomic, strong) ASNetworkImageNode *netImageNode;
@property (nonatomic, strong) ASImageNode *imageNode;
@end

@implementation YHASNetworkImageNode
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.netImageNode = [[ASNetworkImageNode alloc] init];
        self.netImageNode.delegate = self;
        self.netImageNode.shouldCacheImage = NO;
        [self addSubnode:self.netImageNode];

        self.imageNode = [[ASImageNode alloc] init];
        [self addSubnode:self.imageNode];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    if (!self.netImageNode.URL) {
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:self.imageNode];
    } else {
        return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:self.netImageNode];
    }
}

#pragma mark ------------------ ASNetworkImageNodeDelegate ------------------
- (void)imageNode:(ASNetworkImageNode *)imageNode didLoadImage:(UIImage *)image{
    [[SDImageCache sharedImageCache] storeImage:image forKey:imageNode.URL.absoluteString completion:nil];
}

#pragma mark ------------------ Setter ------------------
- (void)setURL:(NSString *)URL{
    _URL = URL;
    UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:_URL];
    if (image) {
        self.imageNode.image = image;
        self.netImageNode.image = nil;
    } else {
        self.netImageNode.image = nil;
        self.netImageNode.URL = [NSURL URLWithString:_URL];
    }
}

- (void)setContentMode:(UIViewContentMode)contentMode{
    _contentMode = contentMode;
    self.netImageNode.contentMode = _contentMode;
    self.imageNode.contentMode = _contentMode;
}

- (void)setImageModificationBlock:(asimagenode_modification_block_t)imageModificationBlock{
    _imageModificationBlock = imageModificationBlock;
    self.imageNode.imageModificationBlock = _imageModificationBlock;
    self.netImageNode.imageModificationBlock = _imageModificationBlock;
}


//        self.imageNode.imageModificationBlock = ^UIImage * _Nullable(UIImage * _Nonnull image) {
//            YHDebugLog(@"image:%@", image);
//            UIImage *modifiedImage;
//            CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
//            UIGraphicsBeginImageContextWithOptions(image.size, false, [[UIScreen mainScreen] scale]);
//            [image drawInRect:rect];
//            modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            YHDebugLog(@"modifiedImage:%@", modifiedImage);
//            return modifiedImage;
//        };

@end
