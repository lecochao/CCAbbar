//
//  UIColor+Random.m
//  teshuLEI
//
//  Created by MacOS on 15/4/2.
//  Copyright (c) 2015年 MacOS. All rights reserved.
//

#import "UIColor+Random.h"

@implementation UIColor (Random)

+(UIColor *)random_Color
{
    static BOOL seed = NO;
    if (!seed) {
        seed = YES;
        srandom(time(NULL));
    }
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];//alpha为1.0,颜色完全不透明
}

+(CAGradientLayer *)gradientLayerFromColor:(UIColor *)fromColor toColor:(UIColor *)toColor size:(CGSize)size
{
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.frame    = (CGRect){CGPointZero, size};
    // 颜色分配
    colorLayer.colors = @[(__bridge id)fromColor.CGColor,
                          (__bridge id)toColor.CGColor];
    
    // 颜色分割线
    colorLayer.locations  = @[@(0.20)];
    
    // 起始点
    colorLayer.startPoint = CGPointMake(0, 0);
    
    // 结束点
    colorLayer.endPoint   = CGPointMake(1, 0);
    
    return colorLayer;
}

+(CAGradientLayer *)colorLayer:(CGSize)size
{
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.frame    = (CGRect){CGPointZero, size};
    // 颜色分配
    colorLayer.colors = @[(__bridge id)[self random_Color].CGColor,
                          (__bridge id)[UIColor clearColor].CGColor];
    
    // 颜色分割线
    colorLayer.locations  = @[@(0.20)];
    
    // 起始点
    colorLayer.startPoint = CGPointMake(0, 0);
    
    // 结束点
    colorLayer.endPoint   = CGPointMake(1, 0);
    
    return colorLayer;
}
@end
