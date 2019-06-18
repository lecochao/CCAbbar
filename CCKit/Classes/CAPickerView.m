//
//  CAPickerView.m
//  newruishihui
//
//  Created by Chaos on 16/4/11.
//  Copyright © 2016年 iUXLabs. All rights reserved.
//

#import "CAPickerView.h"

@interface CAPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic ,strong) UIToolbar *toolbar;
@property(nonatomic ,strong) UIPickerView *pickerView;
@property(nonatomic ,strong) UIDatePicker *datePicker;
@property(nonatomic ,strong) NSMutableArray *blockStrs;
@property(nonatomic ,strong) NSString *blockStr;
@property(nonatomic ,strong) NSIndexPath *blockIndexPath;
@property(nonatomic ,strong) NSDate *minDate;
@property(nonatomic ,strong) NSDate *maxDate;
@property(nonatomic ,strong) NSString *outDateFormat;
@property(nonatomic ,strong) NSArray *data;
@property(nonatomic ,copy) pickerViewBlock block;
@property(nonatomic ,assign) UIDatePickerMode datePickerMode;
@end
@implementation CAPickerView

+(instancetype)instantiationStyleDefaultWith:(NSArray*)data
{
    CAPickerView *_self = [[CAPickerView alloc]initWithDefaultPickerView];
    _self.data = data;
    return _self;
}

+(instancetype)instantiationStyleDate
{
    return [self instantiationStyleDateWithMinDate:nil maxDate:nil outDateFormat:nil pickerMode:UIDatePickerModeDate];
}

+(instancetype)instantiationStyleDateWithMinDate:(NSDate *)minDate
                                         maxDate:(NSDate *)maxDate
                                   outDateFormat:(NSString*)outDateFormat
                                      pickerMode:(UIDatePickerMode)datePickerMode
{
    CAPickerView *_self = [[CAPickerView alloc]initWithDatePickerView];
    _self.minDate = minDate;
    _self.maxDate = maxDate;
    _self.outDateFormat = outDateFormat;
    _self.datePickerMode = datePickerMode;
    return _self;
}


-(void)inputView:(nonnull UITextField *)textField block:(nonnull pickerViewBlock)block
{
    if (_pickerView) {
        textField.inputView = _pickerView;
    }
    if (_datePicker) {
        textField.inputView = _datePicker;
    }
    textField.inputAccessoryView = self.toolbar;
    self.block = ^(id  _Nullable data, NSIndexPath * _Nonnull path) {
        [textField resignFirstResponder];
        block(data,path);
    };
    [self setDate:[NSDate date] animated:NO];
}

-(instancetype)initWithDefaultPickerView
{
    self = [super init];
    if (self) {
        [self pickerView];
    }
    return self;
}

-(instancetype)initWithDatePickerView
{
    self = [super init];
    if (self) {
        [self datePicker];
    }
    return self;
}

-(UIToolbar *)toolbar
{
    if (!_toolbar) {
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
        _toolbar.barStyle   = UIBarStyleDefault;
        NSMutableArray *array = [NSMutableArray array];
        UIBarButtonItem *itemTitle = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(leftBtnAction)];
        itemTitle.tintColor = [UIColor darkGrayColor];
        [array addObject:itemTitle];
        
        UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [array addObject:itemSpace];
        
        [array addObject:itemSpace];
        UIBarButtonItem *itemDone = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnAction)];
        itemDone.tintColor = [UIColor darkGrayColor];
        [array addObject:itemDone];
        _toolbar.items = array;
    }
    return _toolbar;
}



-(void)rightBtnAction
{
    if (_block) {
        _block(_blockStr,_blockIndexPath);
    }
}

-(void)leftBtnAction
{
    if (_block) {
        _block(nil,_blockIndexPath);
    }
}

#pragma mark - DatePickerView -

-(UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [UIDatePicker new];
        _datePicker.backgroundColor = [UIColor whiteColor];
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }
    return _datePicker;
}

-(NSDate *)maxDateInitialize
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    //设置时间
    [offsetComponents setYear:1];
    [offsetComponents setMonth:0];
    [offsetComponents setDay:0];
    [offsetComponents setHour:0];
    [offsetComponents setMinute:0];
    [offsetComponents setSecond:0];
    //设置最大值时间
    return [gregorian dateByAddingComponents:offsetComponents toDate:[NSDate date] options:0];
}

-(void)setMinDate:(NSDate *)minDate
{
    _minDate = minDate;
    self.datePicker.minimumDate = _minDate;
}

-(void)setMaxDate:(NSDate *)maxDate
{
    _maxDate = maxDate;
    self.datePicker.maximumDate = _maxDate;
}

-(void)setDatePickerMode:(UIDatePickerMode)datePickerMode
{
    self.datePicker.datePickerMode = datePickerMode;
}


-(NSString *)outDateFormat
{
    if (!_outDateFormat) {
        _outDateFormat = @"yyyy年MM月dd日";
    }
    return _outDateFormat;
}

-(void)dateChanged:(id)picker
{
    if ([picker isKindOfClass:[UIDatePicker class]]) {
        UIDatePicker *dataPicker = (UIDatePicker *)picker;
        NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];
        [pickerFormatter setDateFormat:self.outDateFormat];
        _blockStr = [pickerFormatter stringFromDate:dataPicker.date];
        _blockIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
}

-(void)setDate:(NSDate *)date animated:(BOOL)animated
{
    [self.datePicker setDate:date animated:animated];
    [self dateChanged:_datePicker];
}

#pragma mark - DefaultPickerView -

-(void)setData:(NSArray *)data
{
    _data = data;
    
    if ([[_data firstObject] isKindOfClass:[NSArray class]]) {
        _blockStrs = [NSMutableArray array];
        for (NSArray *rows in data) {
            [_blockStrs addObject:[rows firstObject]];
        }
        _blockStr = @"";
        for (NSString *itme in _blockStrs) {
            _blockStr = [NSString stringWithFormat:@"%@%@",_blockStr,itme];
        }
        _blockIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }else{
        _blockStr = [_data firstObject];
        _blockIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    [_pickerView reloadAllComponents];
}
-(UIPickerView *)pickerView
{
    if (!_pickerView) {
        _pickerView = [UIPickerView new];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [_pickerView selectRow:0 inComponent:0 animated:YES];
    }
    return _pickerView;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if ([[_data firstObject] isKindOfClass:[NSArray class]]) {
        return _data.count;
    }else return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([[_data firstObject] isKindOfClass:[NSArray class]]) {
        NSArray *rows = _data[component];
        
        return rows.count;
    }else return _data.count;
}

- ( NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([[_data firstObject] isKindOfClass:[NSArray class]]) {
        NSArray *rows = _data[component];
        return rows[row];
    }else return _data[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([[_data firstObject] isKindOfClass:[NSArray class]]) {
        NSArray *rows = _data[component];
        [_blockStrs removeObjectAtIndex:component];
        [_blockStrs insertObject:rows[row] atIndex:component];
        _blockStr = @"";
        for (NSString *itme in _blockStrs) {
            _blockStr = [NSString stringWithFormat:@"%@%@",_blockStr,itme];
            _blockIndexPath = [NSIndexPath indexPathForRow:row inSection:component];
        }
    }else {
        _blockIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
        _blockStr = _data[row];
    }
}

@end
