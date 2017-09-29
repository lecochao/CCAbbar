//
//  NSString+Hashes.h
//  wechatAuth
//
//  Created by lecochao on 2017/8/17.
//  Copyright © 2017年 lecochao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Hashes)
@property (nonatomic, readonly) NSString *md5;
@property (nonatomic, readonly) NSString *sha1;
@property (nonatomic, readonly) NSString *sha224;
@property (nonatomic, readonly) NSString *sha256;
@property (nonatomic, readonly) NSString *sha384;
@property (nonatomic, readonly) NSString *sha512;

@end
