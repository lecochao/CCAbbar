//
//  FNetworkingManager.m
//  fast-drugstore
//
//  Created by lecochao on 2018/12/13.
//  Copyright © 2018 lecochao. All rights reserved.
//

#import "FNetworkingManager.h"

@implementation FNetworkingManager

static FNetworkingManager * _instanceManager = nil;

+(void)load
{
    [LNetworkManagerConfig sharedInstance].delegate = [FNetworkingManager sharedInstance];
    [LRACNetworking sharedInstance];
}

+(void)release
{
    [LRACNetworking releaseManager];
}

+(instancetype) sharedInstance {
    
    if (_instanceManager == nil) {
        _instanceManager = [[super alloc] init];
        [_instanceManager manager];
    }
    return _instanceManager;
}
//防止出现不是单例的单例
+ (id)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceManager = [super allocWithZone:zone];
        
    });
    return _instanceManager;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instanceManager;
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    return _instanceManager;
}

- (void)manager
{
    @weakify(self);
    self.notification.notificationTappedBlock = ^{
        //被点击了
        @strongify(self);
        [self.notification dismissNotification];
    };
}



-(CWStatusBarNotification *)notification
{
    if (!_notification) {
        _notification = [CWStatusBarNotification new];
        _notification.notificationStyle = CWNotificationStyleNavigationBarNotification;
        _notification.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
        _notification.notificationAnimationOutStyle = CWNotificationAnimationStyleTop;
        _notification.multiline = YES;//多行显示
        _notification.notificationLabelBackgroundColor = FConfig.FColorDangerousRed;
        _notification.notificationLabelTextColor = [UIColor whiteColor];
        _notification.notificationLabelFont = [UIFont systemFontOfSize:15];
        _notification.notificationAnimationDuration = 0.25;//动画进出时间
        _notification.preferredStatusBarStyle = UIStatusBarStyleLightContent;
    }
    return _notification;
    
    //    UIView *view = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:nil options:nil][0];
    //    [self.notification displayNotificationWithView:view forDuration:self.sliderDuration.value];
    //}
}


# pragma mark - ConfigManager -

- (nonnull NSDictionary *)requestHeaders {
    
    NSMutableDictionary *header = @{@"Accept":@"*/*",@"Content-Type":@"application/json"}.mutableCopy;
    NSString *appVerion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [header setObject:appVerion forKey:@"X-Fast-Version"];
    [header setObject:FConfig.userAgent forKey:@"X-Fast-DeviceId"];
    if (X_Fast_Oss_Type) {
        [header setObject:X_Fast_Oss_Type forKey:@"ossType"];
    }
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"CCAbbar.token"];
    if (token) {
        [header setObject:token forKey:@"appToken"];
    }
    return header;
}


- (NSTimeInterval)timeoutInterval {
    return 60;
}


# pragma mark - NetworkingManager -

+(RACSignal*) FGetDataWithUrl:(NSString *)urlStr
                       params:(NSDictionary*)params
{
    return [self requestDataWithUrl:urlStr method:LHTTPGET params:params];
}

+(RACSignal*) FPostDataWithUrl:(NSString *)urlStr
                        params:(NSDictionary*)params
{
    if (!params) {
        params = [NSDictionary dictionary];
    }
    return [self requestDataWithUrl:urlStr method:LHTTPPOST params:params];
}


+ (RACSignal*)requestDataWithUrl:(NSString *)urlStr
                          method:(LHTTPMethod)method
                          params:(NSDictionary*)params
{
    NSParameterAssert(urlStr);
    NSString *url = urlStr;
    if ([urlStr rangeOfString:@"http://"].location == NSNotFound &&
        [urlStr rangeOfString:@"https://"].location == NSNotFound) {
        url = [FastBaseUrl stringByAppendingString:urlStr];
    }
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        LRACNetworking *networking = [LRACNetworking sharedInstance];
        
        RACSignal *originalSignal = [networking requestUrl:url method:method parameters:params];
        
        [originalSignal subscribeNext:^(id  _Nullable x) {
            [subscriber sendNext:x];
            [subscriber sendCompleted];
           
        } error:^(NSError * _Nullable error) {
            [FHUDManager hideHud];
            NSLog(@"---->%@<----",error.userInfo[NSLocalizedDescriptionKey]);
            if (error.code == 401 ||error.code == 400001) {
                //登录异常
                [FToolManager tokenAbnormal];
            }else if(error.code == 401147){
                //4x1147 您尚未绑定药店或者绑定状态已变更
                [FToolManager userStateAbnormal];
            }else if(error.code == 9999){
                //后端抛出异常 同归 9999
                [FHUDManager showErrorWithHint:@"😢出错啦，稍后重试" detail:error.userInfo[NSLocalizedDescriptionKey]];
//                [[FNetworkingManager sharedInstance].notification displayNotificationWithMessage:error.userInfo[NSLocalizedDescriptionKey] forDuration:1.5];
            }else{
                // 其他异常错误
//                CWStatusBarNotification *notification = [FNetworkingManager sharedInstance].notification;
//                notification.notificationLabelBackgroundColor = FConfig.FColorDangerousRed;
//                [notification displayNotificationWithMessage:@"请求异常，稍后重试" forDuration:1];
                if (error.code == -1005) {
                    //定时任务接口，因屏幕锁定断网抛出的错误
                    NSLog(@"定时任务接口，因屏幕锁定断网抛出的错误-->网络连接已中断");
                }else
                    [FHUDManager showHint:@"请求异常，稍后重试"];
#ifdef DEBUG
                printf("---------------------其他异常错误-------------------\n");
                printf("URL -> %s\n", urlStr.UTF8String);
                printf("%s\n", [error.userInfo.description UTF8String]);
                printf("----------------------------------------------------\n");
#endif
            }
            [subscriber sendError:error];
            [subscriber sendCompleted]; 
        }];
        
        //信号销毁
        return [RACDisposable disposableWithBlock:^{
            
//            NSLog(@"信号取消订阅");
        }];
        
    }];
    return [signal replayLazily];
}

+ (RACSignal*)requestDataWithUrl:(NSString *)urlStr
                          params:(NSDictionary*)params
                       fileDatas:(NSArray<NSData *> *)fileDatas
                        mimeType:(LFileMimeType)mimeType
                            name:(NSString *)name;
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        RACSignal *originalSignal = [[LRACNetworking sharedInstance] uploadUrl:urlStr parameters:params fileDatas:fileDatas mimeType:mimeType name:name];
        [originalSignal subscribeNext:^(id  _Nullable x) {
            [subscriber sendNext:x];
        } error:^(NSError * _Nullable error) {
            NSLog(@"---->%@<----",error.userInfo[NSLocalizedDescriptionKey]);
            if (error.code == 401 ||error.code == 400001) {
                //登录异常
                [FToolManager tokenAbnormal];
                
            }else if(error.code == 9999){
                //后端抛出异常 同归 9999
                [FHUDManager showErrorWithHint:@"😢出错啦，稍后重试" detail:error.userInfo[NSLocalizedDescriptionKey]];
//                [[FNetworkingManager sharedInstance].notification displayNotificationWithMessage:error.userInfo[NSLocalizedDescriptionKey] forDuration:1.5];
            }else{
                // 其他异常错误
                [FHUDManager showErrorWithHint:@"😢出错啦，稍后重试" detail:error.userInfo[NSLocalizedDescriptionKey]];
//                [[FNetworkingManager sharedInstance].notification displayNotificationWithMessage:error.userInfo[NSLocalizedDescriptionKey] forDuration:1];
#ifdef DEBUG
                printf("---------------------其他异常错误-------------------\n");
                printf("URL -> %s\n", urlStr.UTF8String);
                printf("%s\n", [error.userInfo[NSLocalizedDescriptionKey] UTF8String]);
                printf("----------------------------------------------------\n");
#endif
            }
        }];
        //信号销毁
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号取消订阅");
        }];
    }];
    return signal;
}
@end
