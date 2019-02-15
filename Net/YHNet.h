//
//  YHNet.h
//  LocalDating
//
//  Created by apple on 2019/2/15.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_include(<AFNetworking/AFNetworking.h>)
    #import <AFNetworking/AFNetworking.h>
    #import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#elif __has_include("AFNetworking.h")
    #import "AFNetworking.h"
    #import "AFNetworkActivityIndicatorManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

typedef void(^YHHttpRequestProgressBlock)(CGFloat progress);
typedef void(^YHHttpRequestSuccessBlock)(id responseObject);
typedef void(^YHHttpRequestErrorBlock)(NSError *error);

/** Request method */
typedef NS_ENUM(NSUInteger, YHHttpMethod) {
    YHHttpMethodPOST = 0,    // POST
    YHHttpMethodGET = 1,     // GET
};

/** Request serializer type */
typedef NS_ENUM(NSUInteger, YHHttpRequestSerializerType) {
    YHHttpRequestSerializerTypeJSON = 0,   // JSON
    YHHttpRequestSerializerTypeHTTP = 1,   // HTTP
};

/** Response serializer type */
typedef NS_ENUM(NSUInteger, YHHttpResponseSerializerType) {
    YHHttpResponseSerializerTypeJSON = 0,        // JSON
    YHHttpResponseSerializerTypeHTTP = 1,        // HTTP
};

@class YHUploadFileModel;
@interface YHNet : NSObject

+ (YHNet *)sharedNet;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

#if __has_include(<AFNetworking/AFNetworking.h>) || __has_include("AFNetworking.h")

// HTTP请求
- (nullable NSURLSessionDataTask *)httpRequestWithMethod:(YHHttpMethod)httpMethod
                                                     url:(NSString *)url
                                                   param:(nullable id)param
                                                 headers:(nullable NSDictionary<NSString *, NSString *> *)headers
                                              isUseHttps:(BOOL)isUseHttps
                                   requestSerializerType:(YHHttpRequestSerializerType)requestSerializerType
                                  responseSerializerType:(YHHttpResponseSerializerType)responseSerializerType
                                           progressBlock:(nullable YHHttpRequestProgressBlock)progressBlock
                                            successBlock:(nullable YHHttpRequestSuccessBlock)successBlock
                                              errorBlock:(nullable YHHttpRequestErrorBlock)errorBlock;


// HTTP for json request and json response.
- (nullable NSURLSessionDataTask *)httpCommonRequestWithMethod:(YHHttpMethod)httpMethod
                                                           url:(NSString *)url
                                                         param:(nullable id)param
                                                       headers:(nullable NSDictionary<NSString *, NSString *> *)headers
                                                    isUseHttps:(BOOL)isUseHttps
                                                 progressBlock:(nullable YHHttpRequestProgressBlock)progressBlock
                                                  successBlock:(nullable YHHttpRequestSuccessBlock)successBlock
                                                    errorBlock:(nullable YHHttpRequestErrorBlock)errorBlock;


// POST上传方法
- (nullable NSURLSessionDataTask *)uploadWithURL:(NSString *)url
                                           files:(NSArray<YHUploadFileModel *> *)files
                                           param:(nullable id)param
                                         headers:(nullable NSDictionary<NSString *, NSString *> *)headers
                                      isUseHttps:(BOOL)isUseHttps
                                   progressBlock:(nullable YHHttpRequestProgressBlock)progressBlock
                                    successBlock:(nullable YHHttpRequestSuccessBlock)successBlock
                                      errorBlock:(nullable YHHttpRequestErrorBlock)errorBlock;


- (void)cancelRequestWithTask:(nullable NSURLSessionDataTask *)task;

#endif

@end



@interface YHNet (YHRequestHTTP)
#if __has_include(<AFNetworking/AFNetworking.h>) || __has_include("AFNetworking.h")
+ (AFHTTPRequestSerializer *)requestSerializerForHTTP;
#endif
@end

@interface YHNet (YHRequestJSON)
#if __has_include(<AFNetworking/AFNetworking.h>) || __has_include("AFNetworking.h")
+ (AFJSONRequestSerializer *)requestSerializerForJSON;
#endif
@end

@interface YHNet (YHResponseHTTP)
#if __has_include(<AFNetworking/AFNetworking.h>) || __has_include("AFNetworking.h")
+ (AFHTTPResponseSerializer *)responseSerializerForHTTP;
#endif
@end


@interface YHNet (YHResponseJSON)
#if __has_include(<AFNetworking/AFNetworking.h>) || __has_include("AFNetworking.h")
+ (AFJSONResponseSerializer *)responseSerializerForJSON;
#endif
@end




@interface YHUploadFileModel : NSObject
/**
 * name
 */
@property (nonatomic, copy) NSString                            *name;
/**
 * 文件名
 */
@property (nonatomic, copy) NSString                            *fileName;
/**
 * mimeType
 * image/jpeg、image/png
 */
@property (nonatomic, copy) NSString                            *mimeType;
/**
 * 上传data(如果data和fileURL重复，则优先取data，如果data为空，则取fileURL，如果fileURL为空，如跳过上传此对象)
 */
@property (nonatomic, strong, nullable) NSData                  *data;
/**
 * 本地文件路径
 */
@property (nonatomic, strong, nullable) NSURL                   *fileURL;

@end






NS_ASSUME_NONNULL_END
