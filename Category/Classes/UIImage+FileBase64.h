//
//  UIImage+FileBase64.h
//  fast-drugstore
//
//  Created by lecochao on 2019/8/27.
//  Copyright © 2019 lecochao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (FileBase64)

- (NSString *)base64StringPNG;
- (NSString *)base64StringJPEG;
- (NSString *)base64StringPrefixPNG;
- (NSString *)base64StringPrefixJPEG;
+ (UIImage*)imageBase64:(NSString*)base64String;
@end

NS_ASSUME_NONNULL_END
