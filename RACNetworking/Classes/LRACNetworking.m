//
//  LRACNetworking.m
//  RACNetworkingDemo001
//
//  Created by lecochao on 2018/12/5.
//  Copyright © 2018 lecochao. All rights reserved.
//

#import "LRACNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "CWStatusBarNotification.h"


@implementation LSignalValue

+(instancetype)createWithType:(LSignalValueType)type value:(id)value
{
    return [[self alloc] initWithType:type value:value];
}

-(instancetype)initWithType:(LSignalValueType)type value:(id)value
{
    self = [super init];
    if (self) {
        _type = type;
        _value = value;
    }
    return self;
}

@end


@interface LRACNetworking()
//网络管理工具
@property (nonatomic,strong) AFHTTPSessionManager * manager;
@property (strong, nonatomic) CWStatusBarNotification *notification;
@end
@implementation LRACNetworking

static LRACNetworking * _instance = nil;

+(instancetype) sharedInstance {
    if (_instance == nil) {
        _instance = [[super alloc] init];
    }
    return _instance;
}

//防止出现不是单例的单例
+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return _instance;
}

-(CWStatusBarNotification *)notification
{
    if (!_notification) {
        _notification = [CWStatusBarNotification new];
        _notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
        _notification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
        _notification.notificationAnimationOutStyle = CWNotificationAnimationStyleTop;
        _notification.multiline = YES;//多行显示
        _notification.notificationLabelBackgroundColor = kColorWithHex(0xFF7F13);
        _notification.notificationLabelTextColor = [UIColor whiteColor];
        _notification.notificationLabelFont = [UIFont systemFontOfSize:15];
        _notification.notificationAnimationDuration = 1;
        _notification.preferredStatusBarStyle = UIStatusBarStyleLightContent;
        
    }
    return _notification;
}

+ (void)releaseManager
{
    _instance.manager = nil;
}

-(AFHTTPSessionManager *)manager
{
    if (!_manager) {
        //初始化 网络管理器
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer = [LNetworkManagerConfig sharedInstance].responseSerializer;
        _manager.requestSerializer = [LNetworkManagerConfig sharedInstance].requestSerializer;
        _manager.securityPolicy = [LNetworkManagerConfig sharedInstance].securityPolicy;
        /// 开启网络监测
        @weakify(self);
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [_manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            @strongify(self);
            self.networkstatus = status;
            if (status == AFNetworkReachabilityStatusUnknown) {
                NSLog(@"--- 未知网络 ---");
                [self.notification displayNotificationWithMessage:@"未知网络" completion:nil];
            }else if (status == AFNetworkReachabilityStatusNotReachable) {
                NSLog(@"--- 似乎已断开与互联网的连接。 ---");
                [self.notification displayNotificationWithMessage:@"似乎已断开与互联网的连接" completion:nil];
            }else{
                NSLog(@"--- 有网络 ---");
                if (self.notification.notificationIsShowing) {
                    [self.notification dismissNotification];
                }
            }
        }];
        [_manager.reachabilityManager startMonitoring];
        
        self.notification.notificationTappedBlock = ^{
            //被点击了
            @strongify(self);
            [self.notification dismissNotification];
        };
    }
    return _manager;
}


- (RACSignal*)requestUrl:(NSString *)url method:(LHTTPMethod)method parameters:(NSDictionary *)parameters
{
#ifdef DEBUG
    printf("--------------------------Request-------------------------\n");
    //    NSLog(@"-->");
    printf("method -> %s\n", LStringFromHttpMethod(method).UTF8String);
    printf("URL -> %s\n", url.UTF8String);
    if (parameters.toString.length>512) {
        printf("param -> %1024.512s\n", parameters.toString.UTF8String);
    }else
        printf("param -> %s\n", parameters.toString.UTF8String);
    printf("----------------------------------------------------------\n");
#endif
    LNetworkingRequest *req = [LNetworkingRequest createWithMethod:method path:url parameters:parameters];
    return [self requestNetworkData:req];
}


- (RACSignal*)requestNetworkData:(LNetworkingRequest *)req
{
    /// request 必须的有值
    if (!req) return [RACSignal error:[NSError errorWithDomain:@"LNetworkingRequest NONNUL" code:-1 userInfo:nil]];
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        @strongify(self);
        /// 获取request
        NSError *serializationError = nil;
        NSMutableURLRequest *request = [self.manager.requestSerializer requestWithMethod:req.method URLString:req.path parameters:req.parameters error:&serializationError];
        if (serializationError) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.manager.completionQueue ?: dispatch_get_main_queue(), ^{
                [subscriber sendError:serializationError];
            });
#pragma clang diagnostic pop
            
            return [RACDisposable disposableWithBlock:^{
            }];
        }
        /// 获取请求任务
        __block NSURLSessionDataTask *task = nil;
        task = [self.manager dataTaskWithRequest:request
                                  uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
            //                                      NSLog(@"uploadProgress - %lld - %lld",uploadProgress.totalUnitCount,uploadProgress.completedUnitCount);
            //                                      [subscriber sendNext:[LSignalValue createWithType:LSignalValueTypeUploadProgress value:uploadProgress]];
        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            //                                      NSLog(@"downloadProgress - %lld - %lld",downloadProgress.totalUnitCount,downloadProgress.completedUnitCount);
            //                                      [subscriber sendNext:[LSignalValue createWithType:LSignalValueTypeDownloadProgress value:downloadProgress]];
        }
                               completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error){
            //            @strongify(self);
            if (error) {
                //错误处理
                NSInteger statusCode = [(NSHTTPURLResponse*)task.response statusCode];
                if (statusCode ==401){
                    [subscriber sendError:LERROR(401, @"登录异常，请重新登录")];
                }else{
                    [FHUDManager hideHud];
                    if (self->_networkstatus == AFNetworkReachabilityStatusNotReachable){
                        if (!self->_notification.notificationIsShowing) {
                            [self->_notification displayNotificationWithMessage:@"似乎已断开与互联网的连接" completion:nil];
                        }
                    }else
                        [subscriber sendError:error];
                }
                
            }else{
#ifdef DEBUG
                printf("--------------------------response------------------------\n");
                //                                       NSLog(@"-->");
                printf("URL -> %s\n", req.path.UTF8String);
                NSString *str = [(NSObject*)responseObject toString];
                if (str.length>512) {
                    printf("responseObject -> %1024.512s\n", str.UTF8String);
                }else
                    printf("responseObject -> %s\n", str.UTF8String);
                
                printf("----------------------------------------------------------\n");
#endif
                NSError *er;
                LNetworkingResponse *model = [[LNetworkingResponse alloc] initWithDictionary:responseObject error:&er];
                if (!er) {
                    if (model.success) {
                        //                                               [subscriber sendNext:[LSignalValue createWithType:LSignalValueTypeResponseObj value:model.result]];
                        [subscriber sendNext:model.result];
                    }else{
                        if ([model.code isEqualToString:@"400001"]) {
                            [subscriber sendError:LERROR(400001, model.message)];
                        }else if ([model.code isEqualToString:@"4x1147"]) {
                            [subscriber sendError:LERROR(401147, model.message)];
                        }else
                            [subscriber sendError:LERROR(9999, model.message)];
                    }
                    
                }else {
                    NSLog(@" LNetworkingResponse 解析失败");
                    [subscriber sendError:er];
                }
            }
            [subscriber sendCompleted];
        }];
        
        // 开启请求任务
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    //多次订阅同样的信号，执行一次
    return [signal replayLazily];
    
}


- (RACSignal*)uploadUrl:(NSString *)url parameters:(NSDictionary *)parameters fileDatas:(NSArray<NSData *> *)fileDatas mimeType:(LFileMimeType)mimeType name:(NSString *)name
{
    
    NSAssert(fileDatas.count==0, @"fileDatas is not Null %lu", (unsigned long)fileDatas.count);
#ifdef DEBUG
    printf("--------------------Request upload--------------------\n");
    NSLog(@"URL -> %@", url);
    NSLog(@"param -> %@", parameters);
    NSLog(@"fileDatas num -> %ld", (long)fileDatas.count);
    printf("-------------------------------------------------------\n");
#endif
    LNetworkingRequest *req = [LNetworkingRequest createWithMethod:1 path:url parameters:parameters fileDatas:fileDatas mimeType:mimeType name:name];
    return [self uploadNetworkData:req];
}

- (RACSignal*)uploadNetworkData:(LNetworkingRequest *)req
{
    /// request 必须的有值
    if (!req) return [RACSignal error:[NSError errorWithDomain:@"LNetworkingRequest is not nil" code:-1 userInfo:nil]];
    if (!req.fileParameters) return [RACSignal error:[NSError errorWithDomain:@"LNetworkingRequest.fileParameters  is not nil" code:-1 userInfo:nil]];
    @weakify(self);
    /// 创建信号
    RACSignal *signal = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        @strongify(self);
        /// 获取request
        NSError *serializationError = nil;
        
        NSMutableURLRequest *request = [self.manager.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:req.path parameters:req.parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            NSInteger count = req.fileParameters.fileDatas.count;
            for (int i = 0; i< count; i++) {
                /// 取出fileData
                NSData *fileData = req.fileParameters.fileDatas[i];
                
                /// 断言
                NSAssert([fileData isKindOfClass:NSData.class], @"fileData is not an NSData class: %@", fileData);
                
                // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                // 要解决此问题，
                // 可以在上传时使用当前的系统事件作为文件名
                
                static NSDateFormatter *formatter = nil;
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    formatter = [[NSDateFormatter alloc] init];
                });
                // 设置时间格式
                [formatter setDateFormat:@"yyyyMMddHHmmss"];
                NSString *dateString = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString  stringWithFormat:@"file_img_%@_%d.jpg", dateString , i];
                
                [formData appendPartWithFileData:fileData name:req.fileParameters.name fileName:fileName mimeType:req.fileParameters.mimeType];
                
            }
            
        } error:&serializationError];
        if (serializationError) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(self.manager.completionQueue ?: dispatch_get_main_queue(), ^{
                [subscriber sendError:serializationError];
            });
#pragma clang diagnostic pop
            
            return [RACDisposable disposableWithBlock:^{
            }];
        }
        
        __block NSURLSessionDataTask *task = [self.manager  uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
            //            [subscriber sendNext:[LSignalValue createWithType:LSignalValueTypeUploadProgress value:uploadProgress]];
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                //错误处理
                NSInteger statusCode = [(NSHTTPURLResponse*)task.response statusCode];
                if (statusCode ==401){
                    [subscriber sendError:LERROR(401, @"登录异常，请重新登录")];
                }else
                    [subscriber sendError:error];
                
            }else{
#ifdef DEBUG
                printf("--------------------------response------------------------\n");
                NSLog(@"URL -> %@", req.path);
                NSLog(@"responseObject -> %@", responseObject);
                printf("----------------------------------------------------------\n");
#endif
                NSError *er;
                LNetworkingResponse *model = [[LNetworkingResponse alloc] initWithDictionary:responseObject error:&er];
                if (!er) {
                    if (model.success) {
                        //                        [subscriber sendNext:[LSignalValue createWithType:LSignalValueTypeResponseObj value:model.result]];
                        [subscriber sendNext:model.result];
                    }else{
                        if ([model.code isEqualToString:@"400001"]) {
                            [subscriber sendError:LERROR(400001, model.message)];
                        }else
                            [subscriber sendError:LERROR(9999, model.message)];
                    }
                }else {
                    NSLog(@" LNetworkingResponse 解析失败");
                    [subscriber sendError:er];
                }
            }
            [subscriber sendCompleted];
        }];
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
    return [signal replayLazily];
}
@end
