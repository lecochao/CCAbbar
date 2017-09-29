//
//  NSFileManager+CCFilePath.h
//  CCAbbar
//
//  Created by lecochao on 2017/9/29.
//  Copyright © 2017年 lecochao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (CCFilePath)

+ (NSURL *)documentsURL;

+ (NSString *)documentsPath;

+ (NSURL *)libraryURL;

+ (NSString *)libraryPath;

+ (NSURL *)cachesURL;

+ (NSString *)cachesPath;

@end
