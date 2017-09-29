//
//  NSObject+toString.m
//  toString&withString
//
//  Created by lecochao on 2017/6/30.
//  Copyright © 2017年 lecochao. All rights reserved.
//

#import "NSObject+toString.h"

@implementation NSObject (toString)

- (void)testName {
}

- (NSString *)toString;
{

    if ([self isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)self stringValue];
    }
    if ([self isKindOfClass:[NSValue class]]) {
        return [NSString stringWithFormat:@"%@", self];
    }
    if ([self isKindOfClass:[NSArray class]]) {
        return [(NSArray *)self componentsJoinedByString:@","];
    }
    if ([self isKindOfClass:[NSDictionary class]]) {
        return [self convertToJSONData:self];
    }
    return (NSString *)self;
}

- (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
