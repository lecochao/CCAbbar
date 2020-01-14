//
//  LNetworkingResponse.h
//  RACNetworkingDemo001
//
//  Created by lecochao on 2018/12/5.
//  Copyright © 2018 lecochao. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface LNetworkingResponse : JSONModel
@property(nonatomic, assign) BOOL success;
@property(nonatomic, copy,nullable) NSString *code;
@property(nonatomic, copy,nullable) NSString *message;
@property(nonatomic, copy,nullable) NSString *subMessage;
@property(nonatomic, copy,nullable) NSObject *result;
@end

NS_ASSUME_NONNULL_END
