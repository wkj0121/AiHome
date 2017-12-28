//
//  NViewController.m
//  ConnectedHome
//
//  Created by wkj on 2017/12/13.
//  Copyright © 2017年 华通晟云. All rights reserved.
//



#import "NViewController.h"

#import "ViewController.h"

#define FBNewfeatureImageCount 4

@interface NViewController ()<UIScrollViewDelegate> //实现滚动视图协议
    @property (strong,nonatomic)UIScrollView *scrollView; //滚动视图控件对象
    @property (strong,nonatomic)UIPageControl *pageControl;//分页控制控件对象
@end



@implementation NViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.添加UIScrollView
    [self setupScrollView];
}

/**
 *  添加UIScrollView
 */
- (void)setupScrollView {
    // 1.添加scrollView
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.frame = self.view.bounds;
    //将滚动视图添加到视图控制器控制的视图View容器中
    [self.view addSubview:self.scrollView];
    
    // 2.添加图片
    CGFloat imageW = self.scrollView.frame.size.width;
    CGFloat imageH = self.scrollView.frame.size.height;
    for (int i = 0; i < FBNewfeatureImageCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor grayColor];
        // 设置图片
        NSString *name = [NSString stringWithFormat:@"Screen_%d", i + 1];
        imageView.image = [UIImage imageNamed:name];
        //NSLog(@"%@", name);
        // 设置frame
        CGFloat imageX = i * imageW;
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        
        [self.scrollView addSubview:imageView];
        
//        // 在最后一个图片上面添加按钮
//        if (i == FBNewfeatureImageCount - 1) {
//            [self setupLastImageView:imageView];
//        }

    }
    //3.设置scrollView
    
    //self.scrollView.contentSize = CGSizeMake(5*self.view.frame.size.width, self.view.frame.size.height);//有多少图片,那么滚动视图的滚动宽度就等于图片数量乘以你所设置的单个滚动视图矩形区域的宽度
    self.scrollView.contentSize = CGSizeMake(imageW * FBNewfeatureImageCount, imageH);
    self.scrollView.contentOffset = CGPointZero;//默认滚动视图的初始原点位置都为0
    self.scrollView.tag = 101;
    self.scrollView.showsHorizontalScrollIndicator = NO;//是否显示水平滚动条
    self.scrollView.pagingEnabled = YES;//设置滚动视图可以进行分页
    self.scrollView.bounces = NO;//取消回弹效果
    self.scrollView.delegate = self;//设置滚动视图的代理
    
    //4.创建初始化并设置PageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    self.pageControl.center = self.view.center;
    [self.pageControl setBounds:CGRectMake(0, 0, 16*FBNewfeatureImageCount-1, 16)];//设置pageControl中点的间距为16
    [self.pageControl.layer setCornerRadius:8];//设置圆角
//    self.pageControl.backgroundColor=[UIColor blueColor];//背景
    
    self.pageControl.numberOfPages = FBNewfeatureImageCount; //因为有4张图片，所以设置分页数为4
    self.pageControl.currentPage  = 0; //默认第一页页数为0
    self.pageControl.tag = 201;

//    //设置分页控制点颜色
//    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];//未选中的颜色
//    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];//选中时的颜色
    //将分页控制视图添加到视图控制器视图中
    [self.view addSubview:self.pageControl];
    //添加分页控制事件用来分页
//    [self.pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];

}

// 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    int current = self.scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    
    //根据scrollView 的位置对page 的当前页赋值
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:201];
    page.currentPage = current;
    
    //当显示到最后一页时，让滑动图消失
    if (page.currentPage == FBNewfeatureImageCount-1) {
        
        //调用方法，使滑动图消失
        [self scrollViewDisappear];
    }
}

-(void)scrollViewDisappear{
    
    //拿到 view 中的 UIScrollView 和 UIPageControl
    UIScrollView *scrollView = (UIScrollView *)[self.view viewWithTag:101];
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:201];
    //设置滑动图消失的动画效果图
    [UIView animateWithDuration:1.0f animations:^{
        scrollView.alpha = 0.0;
        page.alpha = 0.0;
        self.scrollView.center = CGPointMake(self.view.frame.size.width/2, 1.5 * self.view.frame.size.height);
       
    } completion:^(BOOL finished) {
        [scrollView removeFromSuperview];
        [page removeFromSuperview];
    }];
    [self returnHome];//返回主页
    
//    //将滑动图启动过的信息保存到 NSUserDefaults 中，使得第二次不运行滑动图
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:@"YES" forKey:@"isScrollViewAppear"];
}

-(void)returnHome{
    ViewController *homeVC = [[ViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:homeVC];
    [UIApplication sharedApplication].keyWindow.rootViewController = navi;
    CATransition *anim = [CATransition animation];
    anim.duration = 1.0f;
    anim.type = @"fade";
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:anim forKey:nil];
}

/**
 *  设置最后一页的图片
 */
- (void)setupLastImageView:(UIImageView *)imageView {
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
    [startButton setTitle:@"开  始" forState:UIControlStateNormal];
    [startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [imageView addSubview:startButton];
    
    // 2.设置按钮属性
    CGFloat startButtonY = self.view.bounds.size.height - 20 - 50;
    CGFloat startButtonW = 145 ;
    CGFloat startButtonH = 50;
    CGFloat startButtonX = (self.view.bounds.size.width - startButtonW) / 2;
    startButton.frame = CGRectMake(startButtonX, startButtonY, startButtonW, startButtonH);
    startButton.layer.cornerRadius = 3;
    startButton.backgroundColor = [UIColor redColor];
    [startButton addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchUpInside];
}

- (void)start {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 创建首页
    ViewController *homeVC = [[ViewController alloc] init];
    // 包装一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    window.rootViewController = nav;
}

@end
