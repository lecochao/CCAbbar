//
//  LcHTTPSessionConfig.h
//  RACNetworkingDemo001
//
//  Created by lecochao on 2018/12/5.
//  Copyright © 2018 lecochao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ConfigManager <NSObject>
@optional
//请求头，追加不覆盖
- (NSDictionary*)requestHeaders;
//超时时间默认60s
- (NSTimeInterval)timeoutInterval;
//serializerTypes，追加不覆盖
- (NSArray *)responseAcceptableContentTypes;
//覆盖默认设置
- (AFJSONResponseSerializer *)responseSerializer;
//覆盖默认设置
- (AFJSONRequestSerializer  *)requestSerializer;
//安全策略，覆盖默认设置
- (AFSecurityPolicy *)securityPolicy;
@end


@interface LNetworkManagerConfig : NSObject

//配置单例
+ (LNetworkManagerConfig *)sharedInstance;

@property (weak,nonatomic) id<ConfigManager> delegate;

- (AFJSONResponseSerializer *)responseSerializer;

- (AFJSONRequestSerializer  *)requestSerializer;

- (AFSecurityPolicy *)securityPolicy;

@end

NS_ASSUME_NONNULL_END
