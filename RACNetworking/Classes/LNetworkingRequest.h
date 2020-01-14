//
//  LRequest.h
//  RACNetworkingDemo001
//
//  Created by lecochao on 2018/12/6.
//  Copyright © 2018 lecochao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LNetworkingConst.h"
NS_ASSUME_NONNULL_BEGIN

@interface LFileParameters : NSObject
/// 要上传的文件
@property (nonatomic, readwrite, strong) NSArray<NSData *> *fileDatas;
/// 文件类型
/// image/png text/html video/quicktime
@property (nonatomic, readwrite, strong) NSString * mimeType;
/// 参数名
@property (nonatomic, readwrite, strong) NSString *name;

+(instancetype)createWithName:(NSString *)name
                     mimeType:(LFileMimeType)mimeType
                    fileDatas:(NSArray<NSData *> *)fileDatas;
@end

@interface LNetworkingRequest : NSObject
/// 路径
@property (nonatomic, readwrite, strong) NSString *path;
/// 参数列表
@property (nonatomic, readwrite, strong) NSDictionary *parameters;
/// 方法 （POST/GET）
@property (nonatomic, readwrite, strong, nullable) NSString *method;
/// 文件参数属性
@property (nonatomic, readwrite, strong, nullable) LFileParameters *fileParameters;


+(instancetype)createWithMethod:(LHTTPMethod)method
                           path:(NSString *)path
                     parameters:(NSDictionary *)parameters;


/**
 上传文件的请求

 @param method 方式
 @param path 地址
 @param parameters 参数
 @param fileDatas 文件datas
 @param mimeType 文件类型
 @param name 文件对应字段名称
 @return LNetworkingRequest
 */
+(instancetype)createWithMethod:(LHTTPMethod)method
                           path:(NSString *)path
                     parameters:(NSDictionary *)parameters
                      fileDatas:(NSArray<NSData *> *)fileDatas
                       mimeType:(LFileMimeType)mimeType
                           name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
