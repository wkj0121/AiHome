//
//  IndexViewController.m
//  AiHome
//
//  Created by wkj on 2017/12/19.
//  Copyright © 2017年 华通晟云. All rights reserved.
//
#import "IndexViewController.h"
#import "HomeViewController.h"
#import "MsgViewController.h"
#import "MySettingViewController.h"
#import "WebViewController.h"

@interface IndexViewController ()

@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTabBar];
}

-(void)setupTabBar{
//    //a.初始化一个tabBar控制器
//    UITabBarController *tb=[[UITabBarController alloc]init];
//    //设置控制器为Window的根控制器
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
////    UIViewController *rootViewController = window.rootViewController;
//    window.rootViewController=tb;
    
    //b.创建子控制器
//    MsgViewController *msgvc=[[MsgViewController alloc]init];
//    [self setTabBarItem:msgvc.tabBarItem
//          selectedImage:@"message_selected"
//            normalImage:@"message_normal"
//    ];
    WebViewController *msgvc = [[WebViewController alloc]init];
    msgvc.urlString = WEBMessageURL;
    [self setTabBarItem:msgvc.tabBarItem
          selectedImage:@"message_selected"
            normalImage:@"message_normal"
    ];
    
    HomeViewController *homevc=[[HomeViewController alloc]init];
    [self setTabBarItem:homevc.tabBarItem
          selectedImage:@"AiHome_selected"
            normalImage:@"AiHome"
    ];
    
    MySettingViewController *uservc=[[MySettingViewController alloc]init];
    [self setTabBarItem:uservc.tabBarItem
          selectedImage:@"user_selected"
            normalImage:@"user_normal"
     ];
    
//    UIViewController *c3=[[UIViewController alloc]init];
//    c3.view.backgroundColor=[UIColor blueColor];
//    c3.tabBarItem.title=@"动态";
//    c3.tabBarItem.image=[UIImage imageNamed:@"tab_qworld_nor"];
    
    
    //c.添加子控制器到ITabBarController中
    //c.1第一种方式
    //    [tb addChildViewController:c1];
    //    [tb addChildViewController:c2];
    
    //c.2第二种方式
    //self.viewControllers=@[c1,c2,c3];
    
//    self.tabBar.tintColor = [UIColor colorWithRed:(128 / 255.0) green:(177 / 255.0) blue:(34 / 255.0) alpha:1];
//    self.tabBar.unselectedItemTintColor = [UIColor whiteColor];
    
    UINavigationController *homeNV = [[UINavigationController alloc] initWithRootViewController:homevc];
    UINavigationController *msgNV = [[UINavigationController alloc] initWithRootViewController:msgvc];
    UINavigationController *userNV = [[UINavigationController alloc] initWithRootViewController:uservc];
    self.viewControllers = @[msgNV,homeNV,userNV];
    self.selectedIndex=1;
    
//    homeNV.title = @"Wellcome";
//    homeNV.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
//    homeNV.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"🛒" style:UIBarButtonItemStylePlain target:nil action:nil];
    
//    homeNV.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
//    homeNV.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_bar_back_icon_white"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
}

- (void)setTabBarItem:(UITabBarItem *)tabbarItem
        selectedImage:(NSString *)selectedImage
          normalImage:(NSString *)unselectedImage
{
    //设置图片
    tabbarItem = [tabbarItem initWithTitle:nil image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    tabbarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
}

- (void)setTabBarItem:(UITabBarItem *)tabbarItem
                title:(NSString *)title
            titleSize:(CGFloat)size
        titleFontName:(NSString *)fontName
        selectedImage:(NSString *)selectedImage
   selectedTitleColor:(UIColor *)selectColor
          normalImage:(NSString *)unselectedImage
     normalTitleColor:(UIColor *)unselectColor
{
    //设置图片
    tabbarItem = [tabbarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    // S未选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateNormal];
    
    // 选中字体颜色
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont fontWithName:fontName size:size]} forState:UIControlStateSelected];
}

@end
