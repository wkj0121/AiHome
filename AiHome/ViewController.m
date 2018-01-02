//
//  ViewController2.m
//  ConnectedHome
//
//  Created by wkj on 2017/12/12.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import "ViewController.h"
#import "TouchID/TouchIDViewController.h"
#import "IndexViewController.h"
//#import "ReactiveObjC.h"
//#import "LxDBAnything.h"

@interface ViewController ()

//@property (weak, nonatomic) IBOutlet UIButton *btn;
//@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //navigationController不显示
//    self.navigationController.navigationBarHidden=YES;
//    [self setupHomeImage];
    [self start];
}

-(void)setupHomeImage{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor grayColor];
    // 设置图片
    imageView.image = [UIImage imageNamed:@"SeekcoHome.png"];
    imageView.frame = self.view.bounds;
    //  retina屏幕图片显示问题
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    //  不规则图片显示
    imageView.contentMode =  UIViewContentModeScaleAspectFill;
    imageView.autoresizesSubviews = YES;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //  图片大于或小于显示区域
    imageView.clipsToBounds  = YES;
    
    [self.view addSubview:imageView];
    
    // 让UIImageView可以跟用户交互
    imageView.userInteractionEnabled = YES;
    // 1. 添加开始按钮
    [self setupStartButton:imageView];
}

/**
 *  添加开始按钮
 */
- (void)setupStartButton:(UIImageView *)imageView {
    
    // 1.添加开始按钮
    UIButton *startButton = [[UIButton alloc] init];
    [startButton setTitle:@"ENTER" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    startButton.titleLabel.font = [UIFont systemFontOfSize: 18.0];
    [imageView addSubview:startButton];
    
    //2.设置按钮布局Masonry
//    UIEdgeInsets padding = UIEdgeInsetsMake(480, 70, 50, 70);
    [startButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(imageView.mas_top).offset(padding.top);
//        make.left.equalTo(imageView.mas_left).offset(70);
        make.bottom.equalTo(imageView.mas_bottom).offset(-70);
//        make.right.equalTo(imageView.mas_right).offset(70);
        make.centerX.equalTo(imageView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(220, 45));
    }];
    
    startButton.layer.cornerRadius = 10;
//    [startButton setTitleEdgeInsets:UIEdgeInsetsMake(30.0,0.0,0.0,0.0)];
    startButton.backgroundColor = [UIColor colorWithRed:116.0/255.0 green:116.0/255.0 blue:116.0/255.0 alpha:1.0];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
}

- (void)start {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 创建首页
//    ViewController *homeVC = [[ViewController alloc] init];
     //包装一个导航控制器
//    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
//    window.rootViewController = nav;
//    [UIApplication sharedApplication].keyWindow.rootViewController = nav;
  
//    TouchIDViewController *vc = [[TouchIDViewController alloc] init];
//    window.rootViewController = vc;
    
    IndexViewController *indexView=[[IndexViewController alloc]init];
    window.rootViewController=indexView;
    
//    [self.navigationController pushViewController:vc animated:NO];
//    [self presentViewController:vc animated:NO completion:nil];
//    [self presentModalViewController:vc animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
