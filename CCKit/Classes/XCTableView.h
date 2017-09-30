//
//  XCTableView.h
//  XCCategory
//
//  Created by Chaos on 15/8/14.
//  Copyright (c) 2015年 Chaos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XCTableViewDataSource;
@protocol XCTableViewDelegate;

@interface XCTableView : UITableView
/** The XCTableView data source. */
@property (nonatomic, weak) id <XCTableViewDataSource> XCDataSource;
/** The XCTableView delegate. */
@property (nonatomic, weak) id <XCTableViewDelegate> XCDataDelegate;

//Asks the data source for the background color of the dataset. Default is clear color
@property(nonatomic ,strong) UIColor *XCBackgroundColor;/**< 背景颜色 clearcolor*/

// Asks the data source for the image of the dataset.
@property(nonatomic ,strong) UIImage *XCImage;/**< 提示图*/

//Asks the data source for the title of the dataset.
//The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
@property(nonatomic ,strong) NSAttributedString *XCTitle;/**< title 其中可包含 font、text、color*/

//Asks the data source for the description of the dataset.
//The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
@property(nonatomic ,strong) NSAttributedString *XCDescription;/**< 内容 其中可包含 font、text、color*/

//Asks the data source for a offset for vertical and horizontal alignment of the content. Default is CGPointZero.
@property(nonatomic ,assign) CGFloat XCVerticalOff;/**< 垂直偏移量 +向下 -向上 默认 0 垂直居中 */

//Asks the data source for a vertical space between elements. Default is 11 pts.
@property(nonatomic ,assign) CGFloat XCSpaceHeight;/**< 整体的高度 +增 -缩 默认 11px 小于0 影响显示*/

//Asks the delegate to know if the empty dataset should be rendered and displayed. Default is YES.
//YES if the empty dataset should show.
@property (nonatomic,assign) BOOL XCShouldDisplay;/**< 无数据 是否显示 默认 yes*/

// Asks the delegate for touch permission. Default is YES.
//YES if the empty dataset receives touch gestures.
@property (nonatomic,assign) BOOL XCShouldAllowTouch;/**< 无数据 是否响应点击 默认yes*/

//Asks the delegate for scroll permission. Default is NO.
//YES if the empty dataset is allowed to be scrollable.
@property (nonatomic,assign) BOOL XCShouldAllowScroll;/**< 无数据 是否可滑动 默认no*/

-(void) setDelegate;
@end

@protocol XCTableViewDataSource <NSObject>

@optional

/**
 Asks the data source for the title to be used for the specified button state.
 The dataset uses a fixed font style by default, if no attributes are set. If you want a different font style, return a attributed string.
 
 @param scrollView A scrollView subclass object informing the data source.
 @param state The state that uses the specified title. The possible values are described in UIControlState.
 @return An attributed string for the dataset button title, combining font, text color, text pararaph style, etc.
 */
- (NSAttributedString *)buttonTitleForXCDataSetTableForState:(UIControlState)state;

/**
 Asks the data source for the image to be used for the specified button state.
 This method will override buttonTitleForEmptyDataSet:forState: and present the image only without any text.
 
 @param scrollView A scrollView subclass object informing the data source.
 @param state The state that uses the specified title. The possible values are described in UIControlState.
 @return An image for the dataset button imageview.
 */
- (UIImage *)buttonImageForXCDataSetTableForState:(UIControlState)state;

/**
 Asks the data source for a background image to be used for the specified button state.
 There is no default style for this call.
 
 @param scrollView A scrollView subclass informing the data source.
 @param state The state that uses the specified image. The values are described in UIControlState.
 @return An attributed string for the dataset button title, combining font, text color, text pararaph style, etc.
 */
- (UIImage *)buttonBackgroundImageForXCDataSetTableForState:(UIControlState)state;

@end

@protocol XCTableViewDelegate <NSObject>

/**
 Tells the delegate that the table dataset view was tapped.
 Use this method either to resignFirstResponder of a textfield or searchBar.
 
 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)XCDataSetDidTapView:(UIScrollView *)scrollView;

/**
 Tells the delegate that the action button was tapped.
 
 @param scrollView A scrollView subclass informing the delegate.
 */
- (void)XCDataSetDidTapButton:(UIScrollView *)scrollView;

@end
