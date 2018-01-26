//
//  AppDelegate.m
//  ConnectedHome
//
//  Created by wkj on 2017/12/12.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import "AppDelegate.h"

#import <WebKit/WebKit.h>
#import <YTKNetwork/YTKNetwork.h>
#import "iflyMSC/IFlyMSC.h"

//引导页
#import "NViewController.h"
#import "OnlineDataTool.h"
//广告页
#import "PromotionItem.h"
#import "PromotionPageViewController.h"
#import "OnlineDataTool.h"
//#import "PushImageManager.h"

//主页和登录页
#import "ViewController.h"
#import "IndexViewController.h"
#import "FKLoginViewController.h"

NSString *const FKLoginStateChangedNotificationKey = @"FKLoginStateChangedNotificationKey";

@interface AppDelegate ()
- (void)configIFlySetting;
- (void)configSVProgressHUD;
- (void)configScrollViewAdapt4IOS11;
- (void)configNetworkApiEnv;
- (void)registerNavgationRouter;
- (void)registerSchemaRouter;

/**
 tabbar控制器
 */
@property (nonatomic, strong) UITabBarController *tabbarController;

///**
// 主视图控制器
// */
//@property (nonatomic, strong) ViewController *viewController;

/**
 登录控制器
 */
@property (nonatomic, strong) FKLoginViewController *loginController;

@end

@implementation AppDelegate


//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    // Override point for customization after application launch.
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    //设置窗口的根控制器
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
//    //设置启动页方式1
////    [PushImageManager loadPushImageViewWithWindow:self.window];
//    //设置启动页方式2
//    [ControllerTool chooseRootViewController];
//    [[[OnlineDataTool alloc] init] loadPromotionPageData];
//
////    IndexViewController *indexView=[[IndexViewController alloc]init];
////    [self.window addSubview:indexView.view];
////    [self.window addSubview:viewController.view];
//
//    return YES;
//}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //讯飞配置注册
    [self configIFlySetting];
    
    // 普通注册
    [self configSVProgressHUD];
    [self configScrollViewAdapt4IOS11];
    [self configNetworkApiEnv];

    // 路由注册
    [self registerNavgationRouter];
    [self registerSchemaRouter];
    
    //加载广告图片
    [[[OnlineDataTool alloc] init] loadPromotionPageData];
    // 配置根视图控制器
    [self setupRootController];

    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    
    // 默认的路由 跳转等等
    if ([[url scheme] isEqualToString:FKDefaultRouteSchema]) {
        
        return [[JLRoutes globalRoutes] routeURL:url];
    }
    // http
    else if ([[url scheme] isEqualToString:FKHTTPRouteSchema])
    {
        return [[JLRoutes routesForScheme:FKHTTPRouteSchema] routeURL:url];
    }
    // https
    else if ([[url scheme] isEqualToString:FKHTTPsRouteSchema])
    {
        return [[JLRoutes routesForScheme:FKHTTPsRouteSchema] routeURL:url];
    }
    // Web交互请求
    else if ([[url scheme] isEqualToString:FKWebHandlerRouteSchema])
    {
        return [[JLRoutes routesForScheme:FKWebHandlerRouteSchema] routeURL:url];
    }
    // 请求回调
    else if ([[url scheme] isEqualToString:FKComponentsCallBackHandlerRouteSchema])
    {
        return [[JLRoutes routesForScheme:FKComponentsCallBackHandlerRouteSchema] routeURL:url];
    }
    // 未知请求
    else if ([[url scheme] isEqualToString:FKUnknownHandlerRouteSchema])
    {
        return [[JLRoutes routesForScheme:FKUnknownHandlerRouteSchema] routeURL:url];
    }
    return NO;
}

#pragma mark - Engine
/// 初始化根页面
- (void)setupRootController
{
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self regLoginStateChangedNotification];
    //根据版本判断是否需要引导页
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
    BOOL showNewFeature = !lastVersion || ([self compareVersion:lastVersion oldVersion:@"1.0.0" ] < 0);
    showNewFeature = NO;
    if (showNewFeature) {//显示引导页flash
        NSLog(@"显示引导页");
        NViewController *vc = [[NViewController alloc] init];
        [self.window setRootViewController:vc];//设置引导页
    }else{//显示广告页多图滚动
        NSLog(@"显示广告页");
        PromotionItem *item = [[[OnlineDataTool alloc] init] getPromotionItem];
        if (item) {//判断是否加载广告
            PromotionPageViewController *vc = [[PromotionPageViewController alloc] init];
            vc.item = item;
            [self.window setRootViewController:vc];//加载广告页面
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:FKLoginStateChangedNotificationKey object:nil];
        }
    }
//    // 发送一次登录状态变化通知设置根视图
//    [[NSNotificationCenter defaultCenter] postNotificationName:FKLoginStateChangedNotificationKey object:nil];
    
}

-(void)regLoginStateChangedNotification
{
    //注册登录状态通知，根据登录状态设置根视图进入登录页还是直接进主页
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:FKLoginStateChangedNotificationKey object:nil] subscribeNext:^(NSNotification * _Nullable noti) {
        
        NSNumber * number = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"];
        BOOL isLogin = NO;
        if (number) {
            isLogin = number.boolValue;
        }
        isLogin = NO;
        if (isLogin) {//已登录
            
            [self.window setRootViewController:self.tabbarController];
            
        }else//未登录
        {
            [self.window setRootViewController:self.loginController];
        }
        CATransition *anim = [CATransition animation];
        anim.duration = 0.5;
        anim.type = @"fade";
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:anim forKey:nil];
    }];
}

- (NSInteger)compareVersion:(NSString *)lastVersion oldVersion:(NSString *)oldVersion {
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

#pragma mark - Getter
- (UITabBarController *)tabbarController
{
    if (!_tabbarController) {

        _tabbarController = [[IndexViewController alloc] init];

//        ViewController *viewController = [[ViewController alloc] init];
//        viewController.title = @"首页";
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
//        _tabbarController.viewControllers = @[
//                                              navController
//                                              ];
    }
    return _tabbarController;
}

#pragma mark - Getter
- (FKLoginViewController *)loginController
{
    if (!_loginController) {
        _loginController = [[FKLoginViewController alloc] init];
    }
    return _loginController;
}

@end

#pragma mark - 初始化 讯飞 配置
@implementation AppDelegate(IFlySetting)

-(void)configIFlySetting{
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:NO];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
}
@end

#pragma mark - 初始化 SVProgressHUD 配置
@implementation AppDelegate(SVProgressHUD)

- (void)configSVProgressHUD
{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setRingThickness:4];
    [SVProgressHUD setMinimumSize:CGSizeMake(80, 80)];
}
@end

#pragma mark - IOS11适配
@implementation AppDelegate(Adapt4IOS11)

- (void)configScrollViewAdapt4IOS11
{
    if (IOS11_OR_LATER) {
//        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        [UITableView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [UIWebView appearance].scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        [WKWebView appearance].scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
    }
}
@end

#pragma mark - YTKNetworking 接口地址配置
@implementation AppDelegate(NetworkApiEnv)

- (void)configNetworkApiEnv
{
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    if (DEBUG) {
        config.debugLogEnabled = YES;
    }else
    {
        config.debugLogEnabled = NO;
    }
    config.baseUrl = @"http://58.210.203.38:8086";
    config.cdnUrl = @"http://58.210.203.38:8086";
    
}
@end

#pragma mark - 路由注册
@implementation AppDelegate(RouterRegister)

#pragma mark - 普通的跳转路由注册
- (void)registerNavgationRouter
{
    // push
    // 路由 /com_seekco_navPush/:viewController
    [[JLRoutes globalRoutes] addRoute:FKNavPushRoute handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _handlerSceneWithPresent:NO parameters:parameters];
            
        });
        return YES;
    }];
    
    // present
    // 路由 /com_seekco_navPresent/:viewController
    [[JLRoutes globalRoutes] addRoute:FKNavPresentRoute handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _handlerSceneWithPresent:YES parameters:parameters];
            
        });
        return YES;
    }];
    
    // sb push
    // 路由 /com_seekco_navStoryboardPush/:viewController
    [[JLRoutes globalRoutes] addRoute:FKNavStoryBoardPushRoute handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        
        return YES;
    }];
    
}

#pragma mark - Schema 匹配
- (void)registerSchemaRouter
{
    // HTTP注册
    [[JLRoutes routesForScheme:FKHTTPRouteSchema] addRoute:@"/somethingHTTP" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        
        return NO;
    }];
    
    // HTTPS注册
    [[JLRoutes routesForScheme:FKHTTPsRouteSchema] addRoute:@"/somethingHTTPs" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        return NO;
        
    }];
    
    // 自定义 Schema注册
    [[JLRoutes routesForScheme:FKWebHandlerRouteSchema] addRoute:@"/somethingCustom" handler:^BOOL(NSDictionary<NSString *,id> * _Nonnull parameters) {
        return NO;
        
    }];
}

#pragma mark - Private
/// 处理跳转事件
- (void)_handlerSceneWithPresent:(BOOL)isPresent parameters:(NSDictionary *)parameters
{
    // 当前控制器
    NSString *controllerName = [parameters objectForKey:FKControllerNameRouteParam];
    UIViewController *currentVC = [self _currentViewController];
    UIViewController *toVC = [[NSClassFromString(controllerName) alloc] init];
    toVC.params = parameters;
    if (currentVC && currentVC.navigationController) {
        if (isPresent) {
            [currentVC.navigationController presentViewController:toVC animated:YES completion:nil];
        }else{
//            if([toVC isKindOfClass:NSClassFromString(@"WebViewController")]){
//                [currentVC setHidesBottomBarWhenPushed:YES];//加上这句就可以把推出的ViewController隐藏Tabbar
//            }
            [currentVC.navigationController pushViewController:toVC animated:YES];
        }
    }else if (currentVC){
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:toVC];
        [self.window setRootViewController:nav];
    }
}
/// 获取当前控制器
- (UIViewController *)_currentViewController{
    
    UIViewController * currVC = nil;
    UIViewController * Rootvc = self.window.rootViewController ;
    do {
        if ([Rootvc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)Rootvc;
            UIViewController * v = [nav.viewControllers lastObject];
            currVC = v;
            Rootvc = v.presentedViewController;
            continue;
        }else if([Rootvc isKindOfClass:[UITabBarController class]]){
            UITabBarController * tabVC = (UITabBarController *)Rootvc;
            currVC = tabVC;
            Rootvc = [tabVC.viewControllers objectAtIndex:tabVC.selectedIndex];
            continue;
        }else if([Rootvc isKindOfClass:[UIViewController class]]){
            UIViewController * vc = (UIViewController *)Rootvc;
            currVC = vc;
            Rootvc = vc.presentedViewController;
            continue;
        }
    } while (Rootvc!=nil);
    
    return currVC;
}

@end
