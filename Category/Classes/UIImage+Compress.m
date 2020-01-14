//
//  UIImage+Compress.m
//  fast-drugstore
//
//  Created by lecochao on 2019/9/9.
//  Copyright © 2019 lecochao. All rights reserved.
//

#import "UIImage+Compress.h"

@implementation UIImage (Compress)

- (UIImage *)iCompressMaxLength:(NSUInteger)maxLength
{
    NSData *data = [self compressSizeMaxLength:maxLength];
//    NSLog(@"iCompressMaxLength = %u KB",data.length/1024);
    return [UIImage imageWithData:data];
}

- (NSData *)compressQualityMaxLength:(NSUInteger)maxLength
{
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
//    NSLog(@"image data length = %u KB",data.length);
//    NSLog(@"Before compressing quality, image size = %u KB",data.length/1024);
    if (data.length < maxLength) return data;

    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        NSLog(@"Compression = %.1f", compression);
//        NSLog(@"In compressing quality loop, image size = %u KB", data.length / 1024);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
//    NSLog(@"After compressing quality, image size = %u KB", data.length / 1024);
    return data;
}

- (NSData*)compressSizeMaxLength:(NSUInteger)maxLength
{
    NSData *data = UIImageJPEGRepresentation(self, 1);
    UIImage *resultImage = [UIImage imageWithData:data];
       // Compress by size
       NSUInteger lastDataLength = 0;
       while (data.length > maxLength && data.length != lastDataLength) {
           lastDataLength = data.length;
           CGFloat ratio = (CGFloat)maxLength / data.length;
           //NSLog(@"Ratio = %.1f", ratio);
           CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                    (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
           UIGraphicsBeginImageContext(size);
           [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
           resultImage = UIGraphicsGetImageFromCurrentImageContext();
           UIGraphicsEndImageContext();
           data = UIImageJPEGRepresentation(resultImage, 1);
//           NSLog(@"In compressing size loop, image size = %u KB", data.length / 1024);
       }
//           NSLog(@"After compressing size loop, image size = %u KB", data.length / 1024);
       return data;
}

- (NSData *)compressMaxLength:(NSUInteger)maxLength
{
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
//    NSLog(@"Before compressing quality, image size = %lu KB",data.length/1024);
    //先压缩大小
    UIImage *resultImage;
    if (data.length > maxLength) {
        resultImage = [UIImage imageWithData:data];
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, 1);
    }
    
    //循环压质量
    if (data.length > maxLength){
        CGFloat max = 1;
        CGFloat min = 0;
        for (int i = 0; i < 6; ++i) {
            compression = (max + min) / 2;
            data = UIImageJPEGRepresentation(resultImage, compression);
//            NSLog(@"Compression = %.1f", compression);
//            NSLog(@"In compressing quality loop, image size = %u KB", data.length / 1024);
            if (data.length < maxLength) {
                break;
            } else if (data.length < maxLength * 0.9) {
                min = compression;
            } else if (data.length > maxLength) {
                max = compression;
            } else {
                break;
            }
        }
    }
    
//    NSLog(@"After compressing quality, image size = %u KB", data.length / 1024);
    
    return data;
}

//+ (void)imageWithAsset:(QMUIAsset *)asset block:(void (^)(UIImage *image))completion
//{
//    [asset assetSize:^(long long size) {
//        NSLog(@"img size %lu",(unsigned long)size);
//        if (size>FConfig.imageSizeMaxInvoiceLength) {
////            CGFloat ratio = (CGFloat)FConfig.imageSizeMaxInvoiceLength / size;
////            CGSize sizea = CGSizeMake((NSUInteger)(asset.phAsset.pixelWidth * ratio),
////            (NSUInteger)(asset.phAsset.pixelHeight * ratio));
////            UIImage *image = [asset thumbnailWithSize:sizea];
////            completion(image);
//            [FHUDManager showHUDWithHint:@"正在压缩"];
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                NSData *imgData = [asset.originImage compressMaxLength:FConfig.imageSizeMaxInvoiceLength];
//                UIImage *image = [UIImage imageWithData:imgData];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    completion(image);
//                    [FHUDManager hideHud];
//                });
//            });
//        }else
//            completion(asset.originImage);
//
//    }];
//}
@end
