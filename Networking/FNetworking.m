//
//  FNetworking.m
//  Fast
//
//  Created by lecochao on 2018/1/7.
//  Copyright © 2018年 lecochao. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import "FNetworking.h"
const NSTimeInterval timeoutInterval = 60;
@implementation FNetworking

NSString *const NotificationTokenAbnormal401 = @"NotificationTokenAbnormal401";

+ (AFJSONRequestSerializer *)requestSerializer
{
    AFJSONRequestSerializer *rs = [AFJSONRequestSerializer serializer];
//    药企项目因为访问地址不同so不需要osstype
//    [rs setValue:X_Fast_Oss_Type forHTTPHeaderField:@"X-Fast-Oss-Type"];
    [rs setValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [rs setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"CCAbbar.token"];
    if (token) {
        [rs setValue:token forHTTPHeaderField:@"X-Fast-Token"];
    }
    
    return rs;
}


+ (void)FGET_JSONDataWithUrl:(NSString *)urlStr
                      Params:(NSDictionary*)params
                     success:(void (^)(FBaseResponseModel *response))success
                        fail:(void (^)(NSError *error))fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求格式
    manager.requestSerializer = self.requestSerializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html",nil];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    printf("~~~~~~~~~~~~~~~~~~~~~~~~~Request~~POST~~~~~~~~~~~~~~~~~~~~~~~~\n");
    NSLog(@"GET_Url == %@", urlStr);
    NSLog(@"GET_param == %@", params);
    printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
    [manager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (task.response) {//200
            printf("--------------------------response------------------------\n");
            NSLog(@"GET_Url == %@", urlStr);
            NSLog(@" %@", responseObject);
            printf("----------------------------------------------------------\n");
            NSError *error;
            FBaseResponseModel *model = [[FBaseResponseModel alloc] initWithDictionary:responseObject error:&error];
            if (!error) {
                if(success) success(model);
                if (!model.success && model.code.intValue ==400001) {
//                    [ToolsHelper tokenAbnormal];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationTokenAbnormal401 object:nil];
                }
            }else NSLog(@" FBaseResponseModel 解析失败");
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //401
        NSInteger statusCode = [(NSHTTPURLResponse*)task.response statusCode];
        if (statusCode ==401){
//            [ToolsHelper tokenAbnormal];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationTokenAbnormal401 object:nil];
        }
        if (fail) {
            fail(error);
        }
    }];
    
}

+ (void)FPOST_JSONDataWithUrl:(NSString *)urlStr
                       Params:(NSDictionary*)params
                      success:(void (^)(FBaseResponseModel *response))success
                         fail:(void (^)(NSError *error))fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求格式
    manager.requestSerializer = self.requestSerializer;;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html",nil];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    printf("~~~~~~~~~~~~~~~~~~~~~~~~~Request~~POST~~~~~~~~~~~~~~~~~~~~~~~~\n");
    NSLog(@"POST_Url == %@", urlStr);
    NSLog(@"POST_param == %@", params);
    printf("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n");
    [manager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (task.response) {//200
            printf("--------------------------response------------------------\n");
            NSLog(@"POST_Url == %@", urlStr);
            NSLog(@" %@", responseObject);
            printf("----------------------------------------------------------\n");
            NSError *error;
            FBaseResponseModel *model = [[FBaseResponseModel alloc] initWithDictionary:responseObject error:&error];
            if (!error) {
                if(success) success(model);
                if (!model.success && model.code.intValue ==400001) {
//                    [ToolsHelper tokenAbnormal];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationTokenAbnormal401 object:nil];
                }
                
            }else {
                NSLog(@" FBaseResponseModel 解析失败");
                if(success) success(nil);
            }
            
        }else{
            if(success) success(nil);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSInteger statusCode = [(NSHTTPURLResponse*)task.response statusCode];
        if (statusCode ==401){
//            [ToolsHelper tokenAbnormal];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationTokenAbnormal401 object:nil];
        }
            
        if (fail) {
            fail(error);
        }
    }];
}
@end
