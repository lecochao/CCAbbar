//
//  XCTableView.m
//  XCCategory
//
//  Created by Chaos on 15/8/14.
//  Copyright (c) 2015年 Chaos. All rights reserved.
//

#import "XCTableView.h"
#import "UIScrollView+EmptyDataSet.h"

@interface XCTableView ()
<DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate>

@end
@implementation XCTableView



-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        _XCShouldDisplay = YES;
        _XCShouldAllowTouch = YES;
        _XCShouldAllowScroll = NO;
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        _XCShouldDisplay = YES;
        _XCShouldAllowTouch = YES;
        _XCShouldAllowScroll = NO;
    }
    return self;
}
-(void) setDelegate
{
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    _XCShouldDisplay = YES;
    _XCShouldAllowTouch = YES;
    _XCShouldAllowScroll = NO;
}

#pragma mark - DZNEmptyDataSetSource Methods -

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
//    NSString *text = nil;
//    UIFont *font = nil;
//    UIColor *textColor = nil;
//    
//    NSMutableDictionary *attributes = [NSMutableDictionary new];
//    
//    text = @"这里是标题";
//    font = [UIFont boldSystemFontOfSize:17.0];
//    textColor = [UIColor colorWithHex:@"545454"];
//    if (font) [attributes setObject:font forKey:NSFontAttributeName];
//    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
//    [[NSAttributedString alloc] initWithString:text attributes:attributes];
    return _XCTitle;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
//    NSString *text = nil;
//    UIFont *font = nil;
//    UIColor *textColor = nil;
//    
//    NSMutableDictionary *attributes = [NSMutableDictionary new];
//    
//    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
//    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
//    paragraph.alignment = NSTextAlignmentCenter;
//    
//    text = @"这里是内容啊";
//    font = [UIFont boldSystemFontOfSize:15.0];
//    textColor = [UIColor colorWithHex:@"545454"];
//    if (font) [attributes setObject:font forKey:NSFontAttributeName];
//    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
//    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
//    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    return _XCDescription;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    return _XCImage;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
//    NSString *text = nil;
//    UIFont *font = nil;
//    UIColor *textColor = nil;
//    
//    text = @"这里是按钮";
//    font = [UIFont boldSystemFontOfSize:16.0];
//    textColor = [UIColor colorWithHex:(state == UIControlStateNormal) ? @"05adff" : @"6bceff"];
//    NSMutableDictionary *attributes = [NSMutableDictionary new];
//    if (font) [attributes setObject:font forKey:NSFontAttributeName];
//    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
//    
//    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    if (self.XCDataSource && [self.XCDataSource respondsToSelector:@selector(buttonTitleForXCDataSetTableForState:)]) {
        return [self.XCDataSource buttonTitleForXCDataSetTableForState:state];
    }
    return nil;
}

-(UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    if (self.XCDataSource && [self.XCDataSource respondsToSelector:@selector(buttonImageForXCDataSetTableForState:)]) {
        return [self.XCDataSource buttonImageForXCDataSetTableForState:state];
    }
    return nil;
}
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
//    NSString *imageName = @"withe_base";
//    
//    if (state == UIControlStateNormal) imageName = @"blue_base";
//    if (state == UIControlStateHighlighted) imageName = @"red_base";
//    
//    UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
//    UIEdgeInsets rectInsets = UIEdgeInsetsZero;
//    
//    return [[[UIImage imageNamed:imageName] resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
    
    if (self.XCDataSource && [self.XCDataSource respondsToSelector:@selector(buttonBackgroundImageForXCDataSetTableForState:)]) {
        return [self.XCDataSource buttonBackgroundImageForXCDataSetTableForState:state];
    }
    return nil;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return _XCBackgroundColor;
}
//垂直偏移量 +向下 -向上 0 垂直居中 去heardView
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return _XCVerticalOff;
}
//高度 包括 图、标题、内容、按钮 所在View的高度
//默认 0 +增加 -缩小（缩小到一定值反响缩小，导致显示不正常
- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return _XCSpaceHeight;
}


#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return _XCShouldDisplay;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return _XCShouldAllowTouch;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return _XCShouldAllowScroll;
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    NSLog(@"TapView %s",__FUNCTION__);
    if (self.XCDataDelegate && [self.XCDataDelegate respondsToSelector:@selector(XCDataSetDidTapView:)]) {
        return [self.XCDataDelegate XCDataSetDidTapView:scrollView];
    }
}

- (void)emptyDataSetDidTapButton:(UIScrollView *)scrollView
{
    NSLog(@"TapButton %s",__FUNCTION__);
    if (self.XCDataDelegate && [self.XCDataDelegate respondsToSelector:@selector(XCDataSetDidTapButton:)]) {
        return [self.XCDataDelegate XCDataSetDidTapButton:scrollView];
    }
}


@end
