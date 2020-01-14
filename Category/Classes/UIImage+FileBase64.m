//
//  UIImage+FileBase64.m
//  fast-drugstore
//
//  Created by lecochao on 2019/8/27.
//  Copyright © 2019 lecochao. All rights reserved.
//

#import "UIImage+FileBase64.h"

@implementation UIImage (FileBase64)

- (NSString *)base64StringPNG
{
    NSData *imgData = UIImagePNGRepresentation(self);
    return [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString *)base64StringJPEG
{
    NSData *imgData = UIImageJPEGRepresentation(self, 1);
    return [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (NSString *)base64StringPrefixPNG
{
    return [@"data:image/png;base64," stringByAppendingString:self.base64StringPNG];
}

- (NSString *)base64StringPrefixJPEG
{
    return [@"data:image/jpeg;base64," stringByAppendingString:self.base64StringJPEG];
}

+ (UIImage*)imageBase64:(NSString*)base64String
{
    if (!base64String) {
        return [UIImage new];
    }
    NSData *data   = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    UIImage *image = [UIImage imageWithData: data];
    return image;
}

@end
