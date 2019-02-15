//
//  YHNet.m
//  LocalDating
//
//  Created by apple on 2019/2/15.
//  Copyright © 2019 yinhe. All rights reserved.
//

#import "YHNet.h"
#import "NSString+YHExtension.h"
#import <pthread/pthread.h>

#define kYHNetTimeOutInterval        60

#define kLock     pthread_mutex_lock(&self->_lock);
#define kUnLock   pthread_mutex_unlock(&self->_lock);

@interface YHNet()
#if __has_include(<AFNetworking/AFNetworking.h>) || __has_include("AFNetworking.h")
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
#endif
@end

@implementation YHNet {
    pthread_mutex_t _lock;
}

+ (YHNet *)sharedNet{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#if __has_include(<AFNetworking/AFNetworking.h>) || __has_include("AFNetworking.h")

- (instancetype)init
{
    self = [super init];
    if (self) {
        pthread_mutex_init(&_lock, NULL);
        self.sessionManager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (NSURLSessionDataTask *)httpRequestWithMethod:(YHHttpMethod)httpMethod
                                            url:(NSString *)url
                                          param:(id)param
                                        headers:(NSDictionary<NSString *, NSString *> *)headers
                                     isUseHttps:(BOOL)isUseHttps
                          requestSerializerType:(YHHttpRequestSerializerType)requestSerializerType
                         responseSerializerType:(YHHttpResponseSerializerType)responseSerializerType
                                  progressBlock:(YHHttpRequestProgressBlock)progressBlock
                                   successBlock:(YHHttpRequestSuccessBlock)successBlock
                                     errorBlock:(YHHttpRequestErrorBlock)errorBlock{
    
    NSURLSessionDataTask *task = nil;
    
    kLock
    
    NSString *newURL = url.yh_urlTranscoding;
    
    if (requestSerializerType == YHHttpRequestSerializerTypeHTTP) {
        self.sessionManager.requestSerializer = [YHNet requestSerializerForHTTP];
    } else if (requestSerializerType == YHHttpRequestSerializerTypeJSON) {
        self.sessionManager.requestSerializer = [YHNet requestSerializerForJSON];
    }
    
    if (responseSerializerType == YHHttpResponseSerializerTypeHTTP) {
        self.sessionManager.responseSerializer = [YHNet responseSerializerForHTTP];
    } else if (responseSerializerType == YHHttpResponseSerializerTypeJSON) {
        self.sessionManager.responseSerializer = [YHNet responseSerializerForJSON];
    }
    
    if (isUseHttps) {
        [self useHttps];
    }
    
    if (headers) {
        [headers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            [self.sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    // 开启转圈圈
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    
    if (httpMethod == YHHttpMethodPOST) {
        task = [self POST_WithURL:newURL param:param responseSerializerType:responseSerializerType progressBlock:progressBlock successBlock:successBlock errorBlock:errorBlock];
    } else if (httpMethod == YHHttpMethodGET) {
        task = [self GET_WithURL:newURL param:param responseSerializerType:responseSerializerType progressBlock:progressBlock successBlock:successBlock errorBlock:errorBlock];
    }
    
    kUnLock
    
    return task;
}

- (NSURLSessionDataTask *)httpCommonRequestWithMethod:(YHHttpMethod)httpMethod
                                                  url:(NSString *)url
                                                param:(id)param
                                              headers:(NSDictionary<NSString *,NSString *> *)headers
                                           isUseHttps:(BOOL)isUseHttps
                                        progressBlock:(YHHttpRequestProgressBlock)progressBlock
                                         successBlock:(YHHttpRequestSuccessBlock)successBlock
                                           errorBlock:(YHHttpRequestErrorBlock)errorBlock{
    
    NSURLSessionDataTask *task = nil;
    
    kLock
    
    NSString *newURL = url.yh_urlTranscoding;
    
    self.sessionManager.requestSerializer = [YHNet requestSerializerForJSON];
    self.sessionManager.responseSerializer = [YHNet responseSerializerForJSON];
    
    if (isUseHttps) {
        [self useHttps];
    }
    
    if (headers) {
        [headers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            [self.sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    // 开启转圈圈
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    
    if (httpMethod == YHHttpMethodPOST) {
        task = [self POST_WithURL:newURL param:param responseSerializerType:YHHttpResponseSerializerTypeJSON progressBlock:progressBlock successBlock:successBlock errorBlock:errorBlock];
    } else if (httpMethod == YHHttpMethodGET) {
        task = [self GET_WithURL:newURL param:param responseSerializerType:YHHttpResponseSerializerTypeJSON progressBlock:progressBlock successBlock:successBlock errorBlock:errorBlock];
    }
    
    kUnLock
    
    return task;
    
}

- (NSURLSessionDataTask *)POST_WithURL:(NSString *)url
                                 param:(id)param
                responseSerializerType:(YHHttpResponseSerializerType)responseSerializerType
                         progressBlock:(YHHttpRequestProgressBlock)progressBlock
                          successBlock:(YHHttpRequestSuccessBlock)successBlock
                            errorBlock:(YHHttpRequestErrorBlock)errorBlock{
    NSURLSessionDataTask *task = [self.sessionManager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        if (progressBlock) {
            progressBlock(progress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id result = responseObject;
        if (responseSerializerType == YHHttpResponseSerializerTypeHTTP) {
            result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }
        if (successBlock) {
            successBlock(result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)GET_WithURL:(NSString *)url
                                 param:(id)param
                responseSerializerType:(YHHttpResponseSerializerType)responseSerializerType
                         progressBlock:(YHHttpRequestProgressBlock)progressBlock
                          successBlock:(YHHttpRequestSuccessBlock)successBlock
                            errorBlock:(YHHttpRequestErrorBlock)errorBlock{
    NSURLSessionDataTask *task = [self.sessionManager GET:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        if (progressBlock) {
            progressBlock(progress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id result = responseObject;
        if (responseSerializerType == YHHttpResponseSerializerTypeHTTP) {
            result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }
        if (successBlock) {
            successBlock(result);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    return task;
}


- (NSURLSessionDataTask *)uploadWithURL:(NSString *)url
                                  files:(NSArray<YHUploadFileModel *> *)files
                                  param:(id)param
                                headers:(NSDictionary<NSString *,NSString *> *)headers
                             isUseHttps:(BOOL)isUseHttps
                          progressBlock:(YHHttpRequestProgressBlock)progressBlock
                           successBlock:(YHHttpRequestSuccessBlock)successBlock
                             errorBlock:(YHHttpRequestErrorBlock)errorBlock{
    
    NSURLSessionDataTask *task = nil;
    
    kLock
    
    NSString *newURL = url.yh_urlTranscoding;
    
    self.sessionManager.requestSerializer = [YHNet requestSerializerForJSON];
    self.sessionManager.responseSerializer = [YHNet responseSerializerForJSON];
    
    if (isUseHttps) {
        [self useHttps];
    }
    
    if (headers) {
        [headers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            [self.sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    task = [self.sessionManager POST:newURL parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [files enumerateObjectsUsingBlock:^(YHUploadFileModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.data) {
                [formData appendPartWithFileData:obj.data name:obj.name fileName:obj.fileName mimeType:obj.mimeType];
            } else if (obj.fileURL) {
                [formData appendPartWithFileURL:obj.fileURL name:obj.name fileName:obj.fileName mimeType:obj.mimeType error:nil];
            }
        }];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        if (progressBlock) {
            progressBlock(progress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    
    kUnLock
    
    return task;
}

- (void)useHttps{
    //NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"cerName" ofType:@"cer"];//证书的路径
    //NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 如果是需要验证自建证书，需要设置为YES   allowInvalidCertificates  是否允许无效证书（也就是自建的证书），默认为NO
    securityPolicy.allowInvalidCertificates = YES;
    //validatesDomainName 是否需要验证域名，默认为YES；
    securityPolicy.validatesDomainName = YES;
    //securityPolicy.pinnedCertificates = [NSSet setWithObject:cerData];
    securityPolicy.pinnedCertificates = [AFSecurityPolicy certificatesInBundle:[NSBundle mainBundle]];
    self.sessionManager.securityPolicy = securityPolicy;
}

- (void)cancelRequestWithTask:(NSURLSessionDataTask *)task{
    kLock
    if (!task) {
        return;
    }
    [task cancel];
    kUnLock
}

#endif

@end



@implementation YHNet (YHRequestHTTP)
#if __has_include(<AFNetworking/AFNetworking.h>) || __has_include("AFNetworking.h")
+ (AFHTTPRequestSerializer *)requestSerializerForHTTP{
    static AFHTTPRequestSerializer *HTTPRequestSerializer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HTTPRequestSerializer = [AFHTTPRequestSerializer serializer];
        HTTPRequestSerializer.timeoutInterval = kYHNetTimeOutInterval;
    });
    return HTTPRequestSerializer;
}
#endif
@end



@implementation YHNet (YHRequestJSON)
#if __has_include(<AFNetworking/AFNetworking.h>) || __has_include("AFNetworking.h")
+ (AFJSONRequestSerializer *)requestSerializerForJSON{
    static AFJSONRequestSerializer *JSONRequestSerializer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JSONRequestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers];
        JSONRequestSerializer.timeoutInterval = kYHNetTimeOutInterval;
        [JSONRequestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    });
    return JSONRequestSerializer;
}
#endif
@end


@implementation YHNet (YHResponseHTTP)
#if __has_include(<AFNetworking/AFNetworking.h>) || __has_include("AFNetworking.h")
+ (AFHTTPResponseSerializer *)responseSerializerForHTTP{
    static AFHTTPResponseSerializer *HTTPResponseSerializer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HTTPResponseSerializer = [AFHTTPResponseSerializer serializer];
        HTTPResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"text/html",
                                                         @"text/css",
                                                         @"text/xml",
                                                         @"text/plain",
                                                         @"application/javascript",
                                                         @"image/*",
                                                         nil];
    });
    return HTTPResponseSerializer;
}
#endif
@end

@implementation YHNet (YHResponseJSON)
#if __has_include(<AFNetworking/AFNetworking.h>) || __has_include("AFNetworking.h")
+ (AFJSONResponseSerializer *)responseSerializerForJSON{
    static AFJSONResponseSerializer *JSONResponseSerializer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JSONResponseSerializer = [AFJSONResponseSerializer serializer];
        JSONResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"text/html",
                                                         @"text/css",
                                                         @"text/xml",
                                                         @"text/plain",
                                                         @"application/javascript",
                                                         @"image/*",
                                                         nil];
    });
    return JSONResponseSerializer;
}
#endif
@end






@implementation YHUploadFileModel

@end
