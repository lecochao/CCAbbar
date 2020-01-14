//
//  UIColor+use.h
//  CCAbbar
//
//  Created by lecochao on 2020/1/14.
//  Copyright © 2020 lecochao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (use)
//常用主题色
+(UIColor *)themeBlue;

//其他颜色
+(UIColor *)redDangerous;

//常用线条颜色
+(UIColor *)colorLineCCCCCC;
+(UIColor *)colorLineF4F4F4;

//常用字体颜色
+(UIColor *)colorText333333;
+(UIColor *)colorText666666;
+(UIColor *)colorText999999;

+(UIColor *)colorTextBlack45;
+(UIColor *)colorTextBlack65;
+(UIColor *)colorTextBlack85;

/**
*  使用HEX命名方式的颜色字符串生成一个UIColor对象
*
*  @param hexString 支持以 # 开头和不以 # 开头的 hex 字符串
*      #RGB        例如#f0f，等同于#ffff00ff，RGBA(255, 0, 255, 1)
*      #ARGB       例如#0f0f，等同于#00ff00ff，RGBA(255, 0, 255, 0)
*      #RRGGBB     例如#ff00ff，等同于#ffff00ff，RGBA(255, 0, 255, 1)
*      #AARRGGBB   例如#00ff00ff，等同于RGBA(255, 0, 255, 0)
*
* @return UIColor对象
*/
+ (UIColor *)use_colorWithHexString:(NSString *)hexString;
@end

NS_ASSUME_NONNULL_END
