//
//  FNetworking.h
//  Fast
//
//  Created by lecochao on 2018/1/7.
//  Copyright © 2018年 lecochao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBaseRequestModel.h"
#import "FBaseResponseModel.h"

extern NSString *const NotificationTokenAbnormal401;

@interface FNetworking : NSObject



+ (void)FGET_JSONDataWithUrl:(NSString *)urlStr
                        Params:(NSDictionary*)params
                       success:(void (^)(FBaseResponseModel *response))success
                          fail:(void (^)(NSError *error))fail;

+ (void)FPOST_JSONDataWithUrl:(NSString *)urlStr
                        Params:(NSDictionary*)params
                       success:(void (^)(FBaseResponseModel *response))success
                          fail:(void (^)(NSError *error))fail;
@end
