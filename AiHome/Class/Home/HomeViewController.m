//
//  HomeViewController.m
//  AiHome
//
//  Created by wkj on 2017/12/31.
//  Copyright © 2017年 华通晟云. All rights reserved.
//
#import "HomeViewController.h"
#import "MainViewController.h"
#import "FXPageControl.h"
#import "AiViewController.h"
#import "UIScrollView+UITouch.h"
#import "XScrollView.h"
#import "InteractionViewController.h"
#import "RegionTableViewController.h"
#import "HomeListRequest.h"

@interface HomeViewController()<UIScrollViewDelegate> //实现滚动视图协议

    @property (nonatomic,strong) NSArray *subViewArr;
    @property (strong,nonatomic) XScrollView *scrollView; //滚动视图控件对象
    @property (strong,nonatomic) FXPageControl *pageControl;//分页控制控件对象

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化视图数据
    [self initViewData];
    //设置导航
    [self customNavItem];
    // 1.添加UIScrollView
    [self setupScrollView];
    // 设置默认Region
    [self configRegion:^void (NSArray *array){
        if(array.count > 0){
            NSDictionary * dic = array[0];
            [[NSUserDefaults standardUserDefaults] setValue:[dic valueForKey:@"id"] forKey:@"regionid"];
//            [[NSUserDefaults standardUserDefaults] setValue:[[NSNumber alloc] initWithInt:[dic valueForKey:@"id"]] forKey:@"regionid"];
        }
    }];
}

/**
 *  初始化数据
 */
- (void)initViewData {
    AiViewController *leftView = [[AiViewController alloc] init];
    MainViewController *mainView = [[MainViewController alloc] init];
    InteractionViewController *rightView = [[InteractionViewController alloc] init];
    
    self.subViewArr = @[leftView, mainView,rightView];
}

#pragma mark - 定制导航条内容
- (void)customNavItem {
    self.navigationItem.title = @"Wellcome";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    //    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    //    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIButton *leftBtn = [[UIButton alloc] init];
    //    [leftBtn setTitle:@"添加好友" forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"regionSwtich"]] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"regionSwtich_selected"]] forState:UIControlStateSelected];
//    [leftBtn addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //        NSLog(@" leftBtn clicked :)");
//        RegionTableViewController *regionVC = [[RegionTableViewController alloc] init];
        // 加载Region数据
        [self configRegion:^void (NSArray *array){
            [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"regions"];
            [[UIApplication sharedApplication]  openURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@", NavPushRouteURL,@"RegionTableViewController"]] options:nil completionHandler:nil];
        }];
        
//        __block NSMutableArray *array = [NSMutableArray array];
//        UserInfoManager *info = [UserInfoManager shareUser];
//        HomeListRequest *api = [[HomeListRequest alloc] initWithUserID:[info.uuid stringValue]];
//        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
//            NSInteger status = request.responseStatusCode;
//            if (200 == status && [request statusCodeValidator]) {
//                array = [request responseJSONObject];
//            } else {
//                [SVProgressHUD fk_displayErrorWithStatus:@"加载数据失败"];
//            }
//            [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"regions"];
//            [[UIApplication sharedApplication]  openURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@", NavPushRouteURL,@"RegionTableViewController"]] options:nil completionHandler:nil];
//        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//            [SVProgressHUD fk_displayErrorWithStatus:@"加载数据失败"];
//            [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"regions"];
//            [[UIApplication sharedApplication]  openURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@", NavPushRouteURL,@"RegionTableViewController"]] options:nil completionHandler:nil];
//        }];
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    UIButton *rightBtn = [[UIButton alloc] init];
    //    [rightBtn setTitle:@"aa" forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"deviceSetting"]] forState:UIControlStateNormal];
    //    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //    [rightBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
//    [rightBtn addTarget:self action:@selector(rightAction:) forControlEvents:UIControlEventTouchUpInside];
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSString *urlString = [WEBAiHomeURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *url = [NSString stringWithFormat:@"%@%@?urlString=%@", NavPushRouteURL,@"WebViewController",urlString];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:nil completionHandler:nil];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    self.navigationItem.leftMargin = 10;
    self.navigationItem.rightMargin = 10;
}

/**
 *  添加UIScrollView
 */
- (void)setupScrollView {
    // 1.添加scrollView
    self.scrollView = [[XScrollView alloc] init];
    self.scrollView.frame = self.view.bounds;
    //将滚动视图添加到视图控制器控制的视图View容器中
    [self.view addSubview:self.scrollView];
    
    // 2.添加viewArr
    CGFloat viewW = self.scrollView.frame.size.width;
    CGFloat viewH = self.scrollView.frame.size.height;
    for (int i = 0; i < self.subViewArr.count; i++) {
        UIViewController *viewControl = [self.subViewArr objectAtIndex:i];
        // 设置frame
        CGFloat viewX = i * viewW;
        viewControl.view.frame = CGRectMake(viewX, 0, viewW, viewH);
        [self.scrollView addSubview:viewControl.view];
    }
    //3.设置scrollView
    //有多少图片,那么滚动视图的滚动宽度就等于图片数量乘以你所设置的单个滚动视图矩形区域的宽度,高度设置为0 配合alwaysBounceVertical，禁止上下拖动
    self.scrollView.contentSize = CGSizeMake(self.subViewArr.count*self.view.frame.size.width, 0);
//    self.scrollView.contentSize = CGSizeMake(imageW * FBNewfeatureImageCount, imageH);
    self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width,0);//默认滚动视图的初始原点位置都为Main
    self.scrollView.tag = 101;
    self.scrollView.showsHorizontalScrollIndicator = NO;//是否显示水平滚动条
    self.scrollView.pagingEnabled = YES;//设置滚动视图可以进行分页
    self.scrollView.alwaysBounceVertical = NO;//禁止scrollview上下拖动
    self.scrollView.bounces = NO;//取消回弹效果
    self.scrollView.delegate = self;//设置滚动视图的代理
    //NO - 设置scrollView不能取消传递touch事件，此时就算手指若在subView上滑动，scrollView不滚动; YES - 设置scrollView可取消传递touch事件
    [self.scrollView setCanCancelContentTouches:NO];
    //NO - 立即通知touchesShouldBegin:withEvent:inContentView
    [self.scrollView setDelaysContentTouches:NO];
    
    //4.创建初始化并设置CustomPageControl
    self.pageControl = [[FXPageControl alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 320)/2, self.view.frame.size.height-110, 320, 60)];
    self.pageControl.backgroundColor = [UIColor clearColor];  //设置背景颜色 不设置默认是黑色
//    self.pageControl.center = self.view.center;
//    [self.pageControl.layer setCornerRadius:8];//设置圆角
    //设置颜色
    self.pageControl.dotColor = [UIColor whiteColor];    //设置非选中页的圆点颜色
    self.pageControl.selectedDotColor = [UIColor colorWithRed:37/255.0f green:132/255.0f blue:130/255.0f alpha:1.0f];  //设置选中页的圆点颜色
    //设着边框
    UIColor *boderColor = [UIColor colorWithRed:96/255.0f green:88/255.0f blue:86/255.0f alpha:1.0f];
    self.pageControl.dotBorderWidth = 0.5;
    self.pageControl.dotBorderColor = boderColor;
    self.pageControl.selectedDotBorderWidth = 0.5;
    self.pageControl.selectedDotBorderColor = boderColor;
    self.pageControl.dotSize = 16;  //点的大小
    self.pageControl.dotSpacing = 30;  //点的间距
    self.pageControl.selectedDotShape = FXPageControlDotShapeCircle;//设置形状
    self.pageControl.wrapEnabled = YES;
    
//        self.pageControl.backgroundColor=[UIColor blueColor];//背景
    
    self.pageControl.numberOfPages = self.subViewArr.count; //因为有4张图片，所以设置分页数为4
    self.pageControl.currentPage  = 1; //默认第一页页数为0
    self.pageControl.defersCurrentPageDisplay = YES;
    self.pageControl.tag = 201;
    
    //    //设置分页控制点颜色
    //    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];//未选中的颜色
    //    self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];//选中时的颜色
    //将分页控制视图添加到视图控制器视图中
    [self.view addSubview:self.pageControl];
    //添加分页控制事件用来分页
    //    [self.pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)configRegion:(RegionArrayBlock)block {
    // 加载Region数据
    __block NSMutableArray *array = [NSMutableArray array];
    UserInfoManager *info = [UserInfoManager shareUser];
    HomeListRequest *api = [[HomeListRequest alloc] initWithUserID:[info.uuid stringValue]];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSInteger status = request.responseStatusCode;
        if (200 == status && [request statusCodeValidator]) {
            array = [request responseJSONObject];
        }
        block(array);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        block(array);
    }];
}

// 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return NO;//YES则隐藏状态栏
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    int current = self.scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    
    //根据scrollView 的位置对page 的当前页赋值
    UIPageControl *page = (UIPageControl *)[self.view viewWithTag:201];
    page.currentPage = current;
    
//    //当显示到最后一页时，让滑动图消失
//    if (page.currentPage == FBNewfeatureImageCount-1) {
//        
//        //调用方法，使滑动图消失
//        [self scrollViewDisappear];
//        [self removeTimer];
//    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

@end
