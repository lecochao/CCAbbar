//
//  OrderPickerView.h
//  newruishihui
//
//  Created by Chaos on 16/4/11.
//  Copyright © 2016年 iUXLabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAPickerView : NSObject

typedef void (^pickerViewBlock)(id _Nullable data ,NSIndexPath * _Nonnull path);

/**
 实例化一个普通的选择器
 
 @param data 一位数组or二维数组
 @return return value description
 */
+(instancetype _Nonnull )instantiationStyleDefaultWith:(NSArray*_Nonnull)data;


/**
 实例化一个时间选择器
 
 @param minDate minDate default is nil
 @param maxDate maxDate default is nil
 @param outDateFormat 输入的时间格式
 @param datePickerMode UIDatePickerMode
 @return return value description
 */
+(instancetype _Nonnull )instantiationStyleDateWithMinDate:(NSDate *_Nullable)minDate
                                                   maxDate:(NSDate *_Nullable)maxDate
                                             outDateFormat:(NSString*_Nullable)outDateFormat
                                                pickerMode:(UIDatePickerMode)datePickerMode;

+(instancetype _Nonnull )instantiationStyleDate;

-(void)inputView:(nonnull UITextField *)textField block:(nonnull pickerViewBlock)block;


- (void)setDate:(NSDate *_Nonnull)date animated:(BOOL)animated;

@end
