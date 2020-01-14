//
//  LRACNetworking.h
//  RACNetworkingDemo001
//
//  Created by lecochao on 2018/12/5.
//  Copyright © 2018 lecochao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNetworkManagerConfig.h"
#import "LNetworkingRequest.h"
#import "LNetworkingResponse.h"
#import "ReactiveObjC.h"

#define LERROR(eCode,desc) [NSError errorWithDomain:@"LRACNetworking" code:eCode userInfo:@{NSLocalizedDescriptionKey:desc}]

NS_ASSUME_NONNULL_BEGIN

@interface LSignalValue : NSObject
@property (nonatomic, readwrite, strong, nullable) id value;
@property (nonatomic, readwrite, assign) LSignalValueType type;

+ (instancetype) createWithType:(LSignalValueType)type value:(nullable id)value;
@end



@interface LRACNetworking : NSObject
@property (nonatomic, readwrite, assign) AFNetworkReachabilityStatus networkstatus;
///要在初始化Config之后加载，否则config delegate 不起作用
+(instancetype) sharedInstance;
///释放manager,因请求头发生变化
+(void)releaseManager;

/**
 RAC 网络请求

 @param url 请求完整地址
 @param method 请求方式
 @param parameters 参数
 @return RAC 信号
 */
- (RACSignal*)requestUrl:(NSString *)url
                  method:(LHTTPMethod)method
              parameters:(nullable NSDictionary *)parameters;


/**
 RAC 上传文件网络请求

 @param url 请求完整地址
 @param parameters 参数
 @param fileDatas 文件data数组
 @param mimeType 文件类型
 @param name 文件对应字段名
 @return RAC 信号
 */
- (RACSignal*)uploadUrl:(NSString *)url
             parameters:(nullable NSDictionary *)parameters
              fileDatas:(NSArray<NSData *> *)fileDatas
               mimeType:(LFileMimeType)mimeType
                   name:(NSString *)name;


/**
 * RAC 下载文件网络请求，等待更新...
 */
 
@end

NS_ASSUME_NONNULL_END
