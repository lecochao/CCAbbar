//
//  LRequest.m
//  RACNetworkingDemo001
//
//  Created by lecochao on 2018/12/6.
//  Copyright © 2018 lecochao. All rights reserved.
//

#import "LNetworkingRequest.h"

@implementation LFileParameters

+(instancetype)createWithName:(NSString *)name mimeType:(LFileMimeType)mimeType fileDatas:(NSArray<NSData *> *)fileDatas
{
    return [[self alloc] initWithName:name mimeType:mimeType fileDatas:fileDatas];
}

- (instancetype)initWithName:(NSString *)name mimeType:(LFileMimeType)mimeType fileDatas:(NSArray<NSData *> *)fileDatas
{
    self = [super init];
    if (self) {
        self.mimeType = LStringFromLFileMimeType(mimeType);
        self.name = name;
        self.fileDatas = fileDatas;
    }
    return self;
}
@end


@implementation LNetworkingRequest

+(instancetype)createWithMethod:(LHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [[self alloc] initWithMethod:method path:path parameters:parameters fileParameters:nil];
}

+(instancetype)createWithMethod:(LHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters fileDatas:(NSArray<NSData *> *)fileDatas mimeType:(LFileMimeType)mimeType name:(NSString *)name
{
    LFileParameters *fileParameters = [LFileParameters createWithName:name mimeType:mimeType fileDatas:fileDatas];
    return [[self alloc] initWithMethod:method path:path parameters:parameters fileParameters:fileParameters];
}

- (instancetype)initWithMethod:(LHTTPMethod)method path:(NSString *)path parameters:(NSDictionary *)parameters fileParameters:(LFileParameters*)fileParameters
{
    self = [super init];
    if (self) {
        self.method = LStringFromHttpMethod(method);
        self.path = path;
        self.parameters = parameters;
        self.fileParameters = fileParameters;
    }
    return self;
}

@end
