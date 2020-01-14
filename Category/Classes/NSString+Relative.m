//
//  NSString+Relative.m
//  fast-drugstore
//
//  Created by lecochao on 2019/9/11.
//  Copyright © 2019 lecochao. All rights reserved.
//

#import "NSString+Relative.h"

@implementation NSString (Relative)

- (NSString *)emptyRelative:(NSString *)firstArg, ... NS_REQUIRES_NIL_TERMINATION
{
    if (self.length>0) return self;
    NSString *val;
    if (firstArg) {
        if(firstArg.length!=0){
            return firstArg;
        }
        // 定义一个指向个数可变的参数列表指针；
        va_list args;
        // 用于存放取出的参数
        NSString *arg;
        // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
        va_start(args, firstArg);
        // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
        while ((arg = va_arg(args, NSString *))) {
            NSLog(@"%@", arg);
            if(!arg&&arg.length!=0){
                val = arg;
                break;
            }
            
        }
        // 清空参数列表，并置参数指针args无效
        va_end(args);
    }
    return val;
}

+ (NSString *)emptyRelative:(NSString *)firstArg, ... NS_REQUIRES_NIL_TERMINATION
{
    NSString *val;
    if (firstArg) {
        if(firstArg.length!=0){
            return firstArg;
        }
        // 定义一个指向个数可变的参数列表指针；
        va_list args;
        // 用于存放取出的参数
        NSString *arg;
        // 初始化变量刚定义的va_list变量，这个宏的第二个参数是第一个可变参数的前一个参数，是一个固定的参数
        va_start(args, firstArg);
        // 遍历全部参数 va_arg返回可变的参数(a_arg的第二个参数是你要返回的参数的类型)
        while ((arg = va_arg(args, NSString *))) {
            NSLog(@"%@", arg);
            if(arg&&arg.length!=0){
                val = arg;
                break;
            }
            
        }
        // 清空参数列表，并置参数指针args无效
        va_end(args);
    }
    return val;
}

@end
