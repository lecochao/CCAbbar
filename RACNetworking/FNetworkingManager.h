//
//  FNetworkingManager.h
//  fast-drugstore
//
//  Created by lecochao on 2018/12/13.
//  Copyright © 2018 lecochao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRACNetworking.h"
//#import "CWStatusBarNotification.h"
NS_ASSUME_NONNULL_BEGIN

@interface FNetworkingManager : NSObject<ConfigManager>
@property (strong, nonatomic) CWStatusBarNotification *notification;//默认背景危险红

+(instancetype) sharedInstance;

+(void)release;

+(RACSignal*) FGetDataWithUrl:(NSString *)urlStr
                       params:(nullable NSDictionary*)params;

+(RACSignal*) FPostDataWithUrl:(NSString *)urlStr
                        params:(nullable NSDictionary*)params;
@end

NS_ASSUME_NONNULL_END
