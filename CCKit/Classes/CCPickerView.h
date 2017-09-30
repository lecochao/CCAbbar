//
//  OrderPickerView.h
//  newruishihui
//
//  Created by Chaos on 16/4/11.
//  Copyright © 2016年 iUXLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CCPickerView : UIView


typedef void (^pickerViewBlock)(id data ,NSIndexPath *path);
/**
 *  普通的PickerView
 *
 *  @param data  仅支持两种数据@[@"",@"",@"",...] @[@[@"",...],@[@"",...],@[@"",...],...];
 *  @param block 拼接过的
 */
+ (void)showViewStyleDefaultWithData:(NSArray *)data Block:(pickerViewBlock)block;
/**
 *  datePickerView
 *
 *  @param minDate 默认 当前时间的Date 可为nil
 *  @param maxDate 默认 minDate + 1年 = maxDate 可为nil
 *  @param block   时间格式String
 */
+ (void)showViewStyleDateWithMinDate:(NSDate *)minDate MaxDate:(NSDate *)maxDate Block:(pickerViewBlock)block;

+ (void)showViewStyleDateBlock:(pickerViewBlock)block;
@end
