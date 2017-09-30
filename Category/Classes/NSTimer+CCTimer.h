//
//  NSTimer+CCTimer.h
//  CCAbbar
//
//  Created by lecochao on 2017/9/29.
//  Copyright © 2017年 lecochao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (CCTimer)
/**
 *  计时器初始化方法
 *
 *  @param ti        计时器间隔
 *  @param aTarget   receiver
 *  @param aSelector selector
 *  @param userInfo  userInfo
 *  @param yesOrNo   是否重复
 *
 *  @return NSTimer instance Obj
 */
+ (NSTimer *)initWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;

/**
 *@brief    暂停计时器调用
 *
 */
- (void)pause;

/**
 *@brief    恢复计时器调用
 *
 */
- (void)resume;

/**
 *@brief    停止计时器并移除，之后再次使用需要重新初始化
 *
 */
- (void)stop;
@end
