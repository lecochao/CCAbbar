//
//  NSObject+CCObject.h
//  CCAbbar
//
//  Created by lecochao on 2017/9/29.
//  Copyright © 2017年 lecochao. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^KVOBlock)(NSDictionary *change, void *context);
@interface NSObject (CCObject)

+ (NSString *)version;

+ (NSInteger)build;

+ (NSString *)identifier;

+ (NSString *)currentLanguage;

+ (NSString *)deviceModel;

- (void)addObserver:(NSObject *)observer
         forKeyPath:(NSString *)keyPath
            options:(NSKeyValueObservingOptions)options
            context:(void *)context
          withBlock:(KVOBlock)block;

-(void)removeBlockObserver:(NSObject *)observer
                forKeyPath:(NSString *)keyPath;

-(void)addObserverForKeyPath:(NSString *)keyPath
                     options:(NSKeyValueObservingOptions)options
                     context:(void *)context
                   withBlock:(KVOBlock)block;

-(void)removeBlockObserverForKeyPath:(NSString *)keyPath;

@end
