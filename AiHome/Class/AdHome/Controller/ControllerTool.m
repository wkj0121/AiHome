//
//  ControllerTool.m
//  ConnectedHome
//
//  Created by wkj on 2017/12/13.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import "ControllerTool.h"
#import "NViewController.h"
#import "MJExtension.h"
#import "ViewController.h"
#import "OnlineDataTool.h"
#import "PromotionItem.h"
#import "PromotionPageViewController.h"

@implementation ControllerTool

+ (void)chooseRootViewController {
    NSString *versionkey = (__bridge NSString *)kCFBundleVersionKey;
    
    // 从沙盒中取出上次存储的软件版本号（取出上次的使用记录）
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults objectForKey:versionkey];
    
    // 获得当前打开软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[versionkey];
    
    BOOL isNewVersion = ![currentVersion isEqualToString:lastVersion];
    
    if (isNewVersion) {
        // 存储这次使用的软件版本
        [defaults setObject:currentVersion forKey:versionkey];
        [defaults synchronize];
    }
    
    // 是否显示引导页
    BOOL showNewFeature = !lastVersion || ([ControllerTool compareVersion:lastVersion oldVersion:@"1.0.0" ] < 0);
    showNewFeature = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!showNewFeature) {
        NSLog(@"不显示引导页");
        PromotionItem *item = [[[OnlineDataTool alloc] init] getPromotionItem];
        // 判断是否加载广告
        if (item) {
            PromotionPageViewController *vc = [[PromotionPageViewController alloc] init];
            vc.item = item;
            window.rootViewController = vc;
        } else {
            ViewController *homeVC = [[ViewController alloc] init];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:homeVC];
            window.rootViewController = navi;
        }
    } else {
        NSLog(@"显示引导页");
        NViewController *vc = [[NViewController alloc] init];
        window.rootViewController = vc;
    }
}

+ (NSInteger)compareVersion:(NSString *)lastVersion oldVersion:(NSString *)oldVersion {
    NSArray *leftPartitions = [lastVersion componentsSeparatedByString:@"."];
    NSArray *rightPartitions = [oldVersion componentsSeparatedByString:@"."];
    for (int i = 0; i < leftPartitions.count && i < rightPartitions.count; i++) {
        NSString *leftPartition = [leftPartitions objectAtIndex:i];
        NSString *rightPartition = [rightPartitions objectAtIndex:i];
        if (leftPartition.integerValue != rightPartition.integerValue) {
            return leftPartition.integerValue - rightPartition.integerValue;
        }
    }
    return 0;
}

@end
