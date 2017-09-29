//
//  NSTimer+CCTimer.m
//  CCAbbar
//
//  Created by lecochao on 2017/9/29.
//  Copyright © 2017年 lecochao. All rights reserved.
//

#import "NSTimer+CCTimer.h"

@implementation NSTimer (CCTimer)
+ (NSTimer *)initWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo{
    
    //    {
    //        NSTimer *timer = [NSTimer timerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:YES];
    //        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
    //    }
    
    //与上面两句等效
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:ti target:aTarget selector:aSelector userInfo:userInfo repeats:yesOrNo];
    //默认初始化后为停止计时状态 需要手动resume
    [timer pause];
    
    return timer;
}
- (void)pause{
    if (!self.isValid) {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];
}
- (void)resume{
    if (!self.isValid) {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];
}
- (void)stop{
    [self invalidate];
}
@end
