//
//  OrderPickerView.m
//  newruishihui
//
//  Created by Chaos on 16/4/11.
//  Copyright © 2016年 iUXLabs. All rights reserved.
//

#import "CCDefine.h"
#import "CCPickerView.h"

@interface CCPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic ,copy) pickerViewBlock block;

@property(nonatomic ,strong) NSDate *minDate;
@property(nonatomic ,strong) NSDate *maxDate;

@property(nonatomic ,strong) NSArray *data;

@property(nonatomic ,strong) UIView *backView;

@property(nonatomic ,strong) NSMutableArray *blockStrs;
@property(nonatomic ,strong) NSString *blockStr;
@property(nonatomic ,strong
          ) NSIndexPath *blockIndexPath;

@property(nonatomic ,strong) UIPickerView *pickerView;
@end
@implementation CCPickerView


- (void)drawRect:(CGRect)rect {
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [self moveAnimate:CGRectGetHeight(KBounds) - 195/2];
    }];
}

- (void)moveAnimate:(CGFloat)y
{
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    moveAnimation.fromValue = @(_backView.center.y);
    moveAnimation.toValue = @(y);
    moveAnimation.autoreverses = NO;
    moveAnimation.fillMode = kCAFillModeForwards;
    moveAnimation.repeatCount = 0;
    moveAnimation.duration = 0.3;
    [_backView.layer addAnimation:moveAnimation forKey:@"moveAnimation"];
    [_backView.layer setPosition:CGPointMake(CGRectGetWidth(KBounds)/2,y)];
}

-(instancetype)initWithDefaultPickerView
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, CGRectGetWidth(KBounds), CGRectGetHeight(KBounds));
        [self setUIKit];
        [self setDefaultPickerView];
    }
    return self;
}

-(instancetype)initWithDatePickerView
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, CGRectGetWidth(KBounds), CGRectGetHeight(KBounds));
        self.alpha = 0.1;
        [self setUIKit];
        [self setDatePickerView];
    }
    return self;
}

-(instancetype)initWithDateView
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, CGRectGetWidth(KBounds), CGRectGetHeight(KBounds));
        self.alpha = 0.1;
        [self setUIKit];
        if (_backView) {
            UIDatePicker *datePicker = [UIDatePicker new];
            datePicker.frame = CGRectMake(0, 35, CGRectGetWidth(_backView.bounds), 160);
            datePicker.backgroundColor = [UIColor whiteColor];
            datePicker.datePickerMode = UIDatePickerModeDate;
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
            datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            [_backView addSubview:datePicker];
            [datePicker setDate:[self getMinDate] animated:YES];
            [self dateChanged:datePicker];
        }
    }
    return self;
}

-(void)setUIKit
{
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    _backView = [UIView new];
    _backView.backgroundColor = kRGBColor(241, 241, 241);
    _backView.frame = CGRectMake(0, CGRectGetHeight(KBounds)-195, CGRectGetWidth(KBounds), 195);
    [self addSubview:_backView];
    
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.frame = CGRectMake(CGRectGetWidth(KBounds)-60, 0, 45, 30);
    [rightBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:rightBtn];

    
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.frame = CGRectMake(15, 0, 45, 30);
    [leftBtn setTitle:@"确定" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:leftBtn];

}

-(void)rightBtnAction
{
    [self moveAnimate:CGRectGetHeight(KBounds) + 200/2];
    [self performSelector:@selector(alphaAnimate) withObject:nil afterDelay:0.3];
    if (_block) {
        _block(nil,_blockIndexPath);
    }
}

-(void)leftBtnAction
{
    [self moveAnimate:CGRectGetHeight(KBounds) + 200/2];
    [self performSelector:@selector(alphaAnimate) withObject:nil afterDelay:0.3];
    if (_block) {
        _block(_blockStr,_blockIndexPath);
    }
}

-(void)alphaAnimate
{
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
#pragma mark - DatePickerView -

-(void)setDatePickerView
{
    if (_backView) {
        UIDatePicker *datePicker = [UIDatePicker new];
        datePicker.frame = CGRectMake(0, 35, CGRectGetWidth(_backView.bounds), 160);
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        datePicker.minimumDate = [self getMinDate];
        datePicker.maximumDate = [self getMaxDate];
        [_backView addSubview:datePicker];
        [datePicker setDate:_minDate animated:YES];
        [self dateChanged:datePicker];
    }
}

-(NSDate *)getMaxDate
{
    if (!_maxDate) {
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
        _maxDate = [gregorian dateByAddingComponents:offsetComponents toDate:_minDate options:0];
    }
    return _maxDate;
}

-(NSDate *)getMinDate
{
    if (!_minDate) {
        _minDate = [NSDate date];
    }
    return _minDate;
}

-(void)dateChanged:(id)picker
{
    if ([picker isKindOfClass:[UIDatePicker class]]) {
        UIDatePicker *dataPicker = (UIDatePicker *)picker;
        NSDateFormatter *pickerFormatter = [[NSDateFormatter alloc] init];
        [pickerFormatter setDateFormat:@"yyyy年MM月dd日"];
        _blockStr = [pickerFormatter stringFromDate:dataPicker.date];
        _blockIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//        if (_block) {
//            _block(_blockStr);
//        }
    }
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
-(void)setDefaultPickerView
{
    if (_backView) {
        _pickerView = [UIPickerView new];
        _pickerView.frame = CGRectMake(0, 35, CGRectGetWidth(_backView.bounds), 160);
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        [_backView addSubview:_pickerView];
        [_pickerView selectRow:0 inComponent:0 animated:YES];
        
    }
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
//    if (_block) {
//        _block(_data.count>0?_blockStr:nil);
//    }
}
#pragma mark - showView -

+(void)showViewStyleDefaultWithData:(NSArray *)data Block:(pickerViewBlock)block
{
    CCPickerView *_self = [[CCPickerView alloc]initWithDefaultPickerView];
    _self.block = block;
    _self.data = data;
    [kKeyWindow addSubview:_self];
   
}

+(void)showViewStyleDateWithMinDate:(NSDate *)minDate MaxDate:(NSDate *)maxDate Block:(pickerViewBlock)block
{
    CCPickerView *_self = [[CCPickerView alloc]initWithDatePickerView];
    _self.block = block;
    _self.minDate = minDate;
    _self.maxDate = maxDate;
    [kKeyWindow addSubview:_self];

}

+(void)showViewStyleDateBlock:(pickerViewBlock)block
{
    CCPickerView *_self = [[CCPickerView alloc]initWithDateView];
    _self.block = block;
    [kKeyWindow addSubview:_self];
    
}
@end
