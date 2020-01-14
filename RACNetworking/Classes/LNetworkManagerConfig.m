//
//  LcHTTPSessionConfig.m
//  RACNetworkingDemo001
//
//  Created by lecochao on 2018/12/5.
//  Copyright © 2018 lecochao. All rights reserved.
//

#import "LNetworkManagerConfig.h"

@interface LNetworkManagerConfig()
//默认配置
- (NSDictionary*)headers;
@end

@implementation LNetworkManagerConfig

+ (LNetworkManagerConfig *)sharedInstance {
    static dispatch_once_t sessionConfig;
    static LNetworkManagerConfig *instance;
    dispatch_once(&sessionConfig, ^{
        instance = [[LNetworkManagerConfig alloc] init];
    });
    return instance;
}


-(AFJSONRequestSerializer *)requestSerializer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestSerializer)]) {
        AFJSONRequestSerializer *serializer = [self.delegate requestSerializer];
        NSAssert(!serializer, @"AFHTTPRequestSerializer 不能为空 ");
        return serializer;
    }
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    //请求头
    NSDictionary *headers = [self headers];
    for (NSString *key in headers.keyEnumerator) {
        [serializer setValue:headers[key] forHTTPHeaderField:key];
        NSLog(@"key = %@ ,obj = %@",key,headers[key]);
    }
    //超时时间
    [serializer willChangeValueForKey:@"timeoutInterval"];
    serializer.timeoutInterval = [self timeoutInterval];
    [serializer didChangeValueForKey:@"timeoutInterval"];
//    NSLog(@"HTTPRequestHeaders = %@ ",serializer.HTTPRequestHeaders);
    return serializer;
}


-(AFJSONResponseSerializer *)responseSerializer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(responseSerializer)]) {
        AFJSONResponseSerializer *serializer = [self.delegate responseSerializer];
        NSAssert(!serializer, @"AFJSONResponseSerializer 不能为空 ");
        return serializer;
    }
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    serializer.acceptableContentTypes = [self responseAcceptableContentTypes];
//    serializer.removesKeysWithNullValues = YES;
//    serializer.readingOptions = NSJSONReadingAllowFragments;
    return serializer;
}

-(NSDictionary *)headers
{
    NSMutableDictionary *headers = [NSMutableDictionary dictionary];
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestHeaders)]) {
        [headers addEntriesFromDictionary: [self.delegate requestHeaders]];
    }
    return headers;
}

-(NSTimeInterval)timeoutInterval
{
    NSTimeInterval t = 60;
    if (self.delegate && [self.delegate respondsToSelector:@selector(timeoutInterval)]) {
        t = [self.delegate timeoutInterval];
    }
    return t;
}

-(NSSet*)responseAcceptableContentTypes
{
    NSMutableSet *set = [NSMutableSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html",nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(responseAcceptableContentTypes)]) {
        [set addObjectsFromArray:[self.delegate responseAcceptableContentTypes]];
    }
    return set;
}

- (AFSecurityPolicy *)securityPolicy
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(securityPolicy)]) {
        AFSecurityPolicy *sp = [self.delegate securityPolicy];
        if (sp) {
           return sp;
        }
        
    }
    /// 安全策略
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = NO;
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO
    //主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    securityPolicy.validatesDomainName = NO;
    return securityPolicy;
}
@end
