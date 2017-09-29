//
//  NSString+CCString.m
//  CCAbbar
//
//  Created by lecochao on 2017/9/29.
//  Copyright © 2017年 lecochao. All rights reserved.
//

#import "NSString+CCString.h"

@implementation NSString (CCString)
#pragma mark ----------------------------
#pragma mark 检测服务器返回数据是否为null，返回WGNull或者对象为NSNumber转为NSString返回
+ (NSString *)handleNetString:(NSString *)string{
    
    if ([string isKindOfClass:[NSString class]]) {
        if (string.length==0) {//为空字符，按需求返回WGNull
            return @"";
        }
        return string;
    }
    else if ([string isKindOfClass:[NSNumber class]]) {//为纯数字，格式化
        return [NSString stringWithFormat:@"%@",string];
    }
    else if([string isKindOfClass:[NSNull class]] || !string){//为null，返回WGNull
        return @"";
    }
    else{//其他，比如NSArray。。。原类型返回
        return string;
    }
}

#pragma mark ----------------------------
#pragma mark 正则表达式
- (BOOL)isMatchingRegularEpressionByPattern:(NSString *)pattern{
    if (self.length<1) return NO;
    //nil 调用此方法，不执行，返回NO
    NSLog(@"匹配字符串：%@\n正则表达式：%@",self,pattern);
    NSError *error;
    //检测正则表达式
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    
    if (nil != regex) {
        NSRange firstMatch = [regex rangeOfFirstMatchInString:self options:0 range:NSMakeRange(0, self.length)];
        if (firstMatch.length&& firstMatch.location!=NSNotFound) {
            NSMutableString *ss = [NSMutableString stringWithString:self];
            NSLog(@"正则匹配结果：%@",[ss substringWithRange:firstMatch]);
        }
        NSLog(@"正则匹配度：%lu:%lu",(unsigned long)firstMatch.length,(unsigned long)self.length);
        if (firstMatch.length==self.length) {
            return YES;
        }
    }
    return NO;
}
- (NSArray *)stringFromRegularEpression:(NSString *)pattern{
    
    NSError *error;
    //检测正则表达式
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
    if (regex) {
        NSArray *results = [regex matchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, self.length)];
        NSMutableArray *texts = @[].mutableCopy;
        
        for (NSTextCheckingResult *result in results) {
            [texts addObject:[self substringWithRange:result.range]];
        }
        
        
        return [NSArray arrayWithArray:texts];
        
    }
    else{
        NSLog(@"regex初始化错误：%@",error.description);
    }
    
    return nil;
    
}

#pragma mark - NSObject 无差别地 转化为 NSString lv从0开始

const static NSString *_blank = @"\t";
+ (NSString *)changeObjToString:(id )obj CurLV:(int )lv{
    NSMutableString *string = [NSMutableString string];
    NSMutableString *blank = [NSMutableString string];
    for (int i = 0; i < lv; i++) {
        [blank appendString:(NSString *)_blank];
    }
    
    if ([obj isKindOfClass:[NSString class]]) {
        [string appendString:blank];
        
        [string appendString:obj];
        
        //        [string appendString:@","];
        
    }
    else if ([obj isKindOfClass:[NSArray class]]){
        [string appendString:blank];
        [string appendString:@"("];
        
        for (int i = 0; i < [obj count]; i++) {
            id sub = obj[i];
            [string appendString:@"\n"];
            [string appendString:[self changeObjToString:sub CurLV:lv+1]];
            
            if (i!=[obj count]-1) {
                [string appendString:@","];
            }
            
        }
        
        
        [string appendString:@"\n"];
        [string appendString:blank];
        [string appendString:@")"];
        
    }
    else if ([obj isKindOfClass:[NSDictionary class]]){
        [string appendString:blank];
        [string appendString:@"{"];
        for (NSString *key in [obj allKeys]) {
            [string appendString:@"\n"];
            [string appendString:blank];
            [string appendString:(NSString *)_blank];
            [string appendFormat:@"%@=%@;",key,[self changeObjToString:obj[key] CurLV:lv+1]];
        }
        [string appendString:@"\n"];
        [string appendString:blank];
        [string appendString:@"}"];
    }else{//NSObject
        [string appendString:blank];
        [string appendString:[obj description]];
        //        [string appendString:@","];
    }
    return string;
    
}

-(BOOL)isErrorIsNull
{
    if ([self isKindOfClass:[NSString class]]) {
        if ([self isEqualToString:@"0"]) {
            return YES;
        }else return NO;
        
    }
    else if ([self isKindOfClass:[NSNumber class]]) {
        if ([self isEqual:@0]) {
            return YES;
        }else return NO;
    }
    return NO;
}

+(NSString *)stringDateFromString:(NSString *)str
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

-(NSString *)stringDateWithFormat:(NSString *)format
{
    if (self) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:format];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        return destDateString;
    }else return @"";
    
}

#pragma mark - 身份证识别 -

+(BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}
@end
