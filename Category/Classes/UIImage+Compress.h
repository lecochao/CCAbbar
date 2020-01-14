//
//  UIImage+Compress.h
//  fast-drugstore
//
//  Created by lecochao on 2019/9/9.
//  Copyright © 2019 lecochao. All rights reserved.
//  图片压缩

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Compress)


/**
 压缩图片

 @param maxLength 2KB = 2*1024
 @return return image
 */
- (UIImage *)iCompressMaxLength:(NSUInteger)maxLength;

/**
 压缩图片,压缩尺寸

 @param maxLength 2KB = 2*1024
 @return return image data
 */
- (NSData *)compressSizeMaxLength:(NSUInteger)maxLength;

/**
 压缩图片,压缩质量

 @param maxLength 2KB = 2*1024
 @return return image data
 */
- (NSData *)compressQualityMaxLength:(NSUInteger)maxLength;

/**
 压缩图片,综合压缩
 @param maxLength 2KB = 2*1024
 @return return image data
 */
- (NSData *)compressMaxLength:(NSUInteger)maxLength;


/// 根据config支持最大值生成对应size的图片
/// @param asset asset description
+ (void)imageWithAsset:(QMUIAsset *)asset block:(void (^)(UIImage *image))completion;
@end

NS_ASSUME_NONNULL_END
