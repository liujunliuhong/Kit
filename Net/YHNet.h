//
//  YHNet.h
//  LocalDating
//
//  Created by apple on 2019/2/15.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

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

/** Network status **/
typedef NS_ENUM(NSUInteger, YHNetworkStatus) {
    YHNetworkStatus_Unkonwn,        // 未知网络
    YHNetworkStatus_NotReachable,   // 无网络连接
    YHNetworkStatus_ViaWWAN,        // 移动网络(2G、3G、4G...)
    YHNetworkStatus_ViaWiFi,        // WiFi
};

@class YHUploadFileModel;
@interface YHNet : NSObject

+ (YHNet *)sharedInstance;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

#if __has_include(<AFNetworking/AFNetworking.h>) || __has_include("AFNetworking.h")

// 当前网络状态，会根据实际网络状态实时变化
@property (nonatomic, assign, readonly) YHNetworkStatus networkStatus;
@property (nonatomic, assign, readonly) BOOL isReachable;


/// 开启网络监控
- (void)startMonitoringNetwork;

/// 关闭网络监控
- (void)stopMonitoringNetwork;

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

// 取消某个网络请求
- (void)cancelRequestWithTask:(nullable NSURLSessionDataTask *)task;

// 根据URL取消某个网络请求
// 此处的url为baseURL之后的相对路径
- (void)cancelRequestWithURL:(nullable NSString *)url;

// 取消所有的网络请求
- (void)cancelAllRequest;

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
