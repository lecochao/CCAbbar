//
//  UIColor+Random.h
//  teshuLEI
//
//  Created by MacOS on 15/4/2.
//  Copyright (c) 2015年 MacOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Random)


+(UIColor *)random_Color;
/*
 *随机渐变颜色...
 */
+(CAGradientLayer *)colorLayer:(CGSize)size;


/**
 渐变颜色
 layer 坐标原点在左下角
 @param fromColor fromColor description
 @param toColor toColor description
 @param size size description
 @return gradientLayer ... [view.layer addSublayer:GradientLayer]
 */
+(CAGradientLayer *)gradientLayerFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor size:(CGSize)size;
@end
