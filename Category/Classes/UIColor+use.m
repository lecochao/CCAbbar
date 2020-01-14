//
//  UIColor+use.m
//  CCAbbar
//
//  Created by lecochao on 2020/1/14.
//  Copyright © 2020 lecochao. All rights reserved.
//

#import "UIColor+use.h"
@implementation UIColor (use)

+(UIColor* )themeBlue
{
    return [self use_colorWithHexString:@"#0074E4"];
}

+(UIColor* )redDangerous
{
    return [self use_colorWithHexString:@"#FF3B30"];
}

+(UIColor* )colorLineCCCCCC
{
    return [self use_colorWithHexString:@"#CCCCCC"];
}

+(UIColor* )colorLineF4F4F4
{

    return [self use_colorWithHexString:@"#F4F4F4"];
}

+(UIColor* )colorText333333
{
    return [self use_colorWithHexString:@"#333333"];
}

+(UIColor* )colorText666666
{
    return [self use_colorWithHexString:@"#666666"];
}

+(UIColor* )colorText999999
{
    return [self use_colorWithHexString:@"#999999"];
}

+(UIColor* )colorTextBlack45
{
    return [UIColor colorWithWhite:0 alpha:.45f];
}

+(UIColor* )colorTextBlack65
{
    return [UIColor colorWithWhite:0 alpha:.65f];
}

+(UIColor* )colorTextBlack85
{
    return [UIColor colorWithWhite:0 alpha:.85f];
}

+ (UIColor *)use_colorWithHexString:(NSString *)hexString {
    if (hexString.length <= 0) return nil;
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default: {
            NSAssert(NO, @"Color value %@ is invalid. It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString);
            return nil;
        }
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}
@end
