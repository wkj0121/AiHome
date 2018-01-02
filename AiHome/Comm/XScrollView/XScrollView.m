//
//  XScrollView.m
//  AiHome
//
//  Created by wkj on 2018/1/2.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "XScrollView.h"
#import "DVoiceTouchView.h"

@implementation XScrollView

- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event inContentView:(UIView *)view;
{
//    NSLog(@"用户点击了scroll上的视图%@,是否开始滚动scroll",view);
    //返回yes 是不滚动 scroll 返回no 是滚动scroll
    if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[DVoiceTouchView class]])  {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
//    NSLog(@"用户点击的视图 %@",view);
    //NO scroll不可以滚动 YES scroll可以滚动
    if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[DVoiceTouchView class]])  {
        return YES;
    }else{
        return NO;
    }
}

@end
