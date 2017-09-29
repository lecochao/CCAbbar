//
//  NSObject+CCObject.m
//  CCAbbar
//
//  Created by lecochao on 2017/9/29.
//  Copyright © 2017年 lecochao. All rights reserved.
//

#import "NSObject+CCObject.h"
#import <sys/utsname.h>
#import <objc/runtime.h>

@implementation NSObject (CCObject)

+ (NSString *)version
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

+ (NSInteger)build
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    return [app_build integerValue];
}

+ (NSString *)identifier
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * bundleIdentifier = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    return bundleIdentifier;
}

+ (NSString *)currentLanguage
{
    return [[NSLocale preferredLanguages] firstObject];
}

+ (NSString *)deviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}


-(void)addObserver:(NSObject *)observer
        forKeyPath:(NSString *)keyPath
           options:(NSKeyValueObservingOptions)options
           context:(void *)context
         withBlock:(KVOBlock)block
{
    objc_setAssociatedObject(observer, (__bridge const void *)(keyPath), block, OBJC_ASSOCIATION_COPY);
    [self addObserver:observer forKeyPath:keyPath options:options context:context];
}

-(void)removeBlockObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath
{
    objc_setAssociatedObject(observer, (__bridge const void *)(keyPath), nil, OBJC_ASSOCIATION_COPY);
    [self removeObserver:observer forKeyPath:keyPath];
}

-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary *)change
                      context:(void *)context
{
    KVOBlock block = objc_getAssociatedObject(self, (__bridge const void *)(keyPath));
    block(change, context);
}

-(void)addObserverForKeyPath:(NSString *)keyPath
                     options:(NSKeyValueObservingOptions)options
                     context:(void *)context
                   withBlock:(KVOBlock)block
{
    [self addObserver:self forKeyPath:keyPath options:options context:context withBlock:block];
}

-(void)removeBlockObserverForKeyPath:(NSString *)keyPath
{
    [self removeBlockObserver:self forKeyPath:keyPath];
}


@end
