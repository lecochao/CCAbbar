//
//  NSString+Relative.h
//  fast-drugstore
//
//  Created by lecochao on 2019/9/11.
//  Copyright © 2019 lecochao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Relative)

/**
 判断不为空字符，nil...,按序优先返回self...firstArg...

 @param firstArg firstArg description
 @return return String
 */
- (NSString *)emptyRelative:(NSString *)firstArg, ... NS_REQUIRES_NIL_TERMINATION;

/**
 判断不为空字符，nil...,按序优先返回firstArg...
 
 @param firstArg firstArg description
 @return return String
 */
+ (NSString *)emptyRelative:(NSString *)firstArg, ... NS_REQUIRES_NIL_TERMINATION;
@end

NS_ASSUME_NONNULL_END
