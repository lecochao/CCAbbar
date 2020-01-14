//
//  FBaseResponseModel.h
//  Fast
//
//  Created by lecochao on 2017/12/6.
//  Copyright © 2017年 lecochao. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FBaseResponseModel : JSONModel
@property(nonatomic, assign) BOOL success;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, copy) NSString *subMessage;
@property(nonatomic, copy) NSObject *result;
@property(nonatomic, copy) NSString *code;
@end

/*
 {
 "code": "string",
 "message": "string",
 "result": {},
 "subMessage": "string",
 "success": true
 }
 */
