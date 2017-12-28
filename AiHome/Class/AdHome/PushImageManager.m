//
//  PushImageManager.m
//  ConnectedHome
//
//  Created by wkj on 2017/12/13.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import "PushImageManager.h"
#import "ReactiveObjC.h"
#import "LxDBAnything.h"

@implementation PushImageManager
+ (void)loadPushImageViewWithWindow:(UIWindow *)window {
    
    // 0.创建要显示的图片
    __block UIView *fullView = [[UIView alloc] initWithFrame:window.bounds];
    fullView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *showImageView = [[UIImageView alloc] initWithFrame:fullView.bounds];
    // 这个下载操作非常耗时，纯演示作用，看你的app启动需求策略
    [showImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://oh95fyv3r.bkt.clouddn.com/3.jpg"]]]];
    [fullView addSubview:showImageView];
    showImageView.userInteractionEnabled = YES;
    
    // 0.创建"跳过"按钮
    __block UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-20-60, 30, 60, 20)];
    btn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [btn setTitle:@"3 跳过" forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [fullView addSubview:btn];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        fullView.hidden = YES;
        [fullView removeFromSuperview];
    }];
    
    [window addSubview:fullView];
    
    // 定时器
    __block NSInteger index = 2;
    [[[RACSignal interval:1 onScheduler:[RACScheduler mainThreadScheduler]] take:index] subscribeNext:^(id x) {
        NSLog(@"调用定时器");
        [btn setTitle:[NSString stringWithFormat:@"%ld 跳过",index] forState:UIControlStateNormal];
        index --;
        LxDBAnyVar(index);
        if (index <= 0) {
            [fullView removeFromSuperview];
        }
    }];
    
//    [[RACScheduler mainThreadScheduler] afterDelay:1.f schedule:^{
//        NSLog(@"5秒后执行");
//    }];
//    
//    [[[RACSignal interval:2.f onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal ] subscribeNext:^(id x) {
//        NSLog(@"每两秒执行一次");
//    }];
    
}

@end

