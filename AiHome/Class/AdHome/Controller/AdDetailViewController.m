//
//  AdDetailViewController.m
//  ConnectedHome
//
//  Created by wkj on 2017/12/13.
//  Copyright © 2017年 华通晟云. All rights reserved.
//
#import "AppDelegate.h"
#import "AdDetailViewController.h"
#import <WebKit/WebKit.h>

@interface AdDetailViewController () <WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation AdDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.webView];
    
//    self.title = @"广告详细";
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.urlString.length) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
        [self.webView loadRequest:request];
    } else {
        
    }
}

//#pragma mark - 定制导航条内容
//- (void)customNavItem {
//    self.navigationItem.title = @"详情";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
//    UIButton *leftBtn = [[UIButton alloc] init];
//    [leftBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"back"]] forState:UIControlStateNormal];
//    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
//    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//    self.navigationItem.leftMargin = 5;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark LazyLoad
- (WKWebView *)webView {
    if (!_webView) {
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
        webView.navigationDelegate = self;
        self.webView = webView;
    }
    return _webView;
}

- (void)fk_initialDefaultsForController
{
    self.urlString = [self.params objectForKey:@"urlString"];
}

-(void)fk_bindViewModelForController
{
    
}

- (void)fk_configNavigationForController
{
    self.navigationItem.title = @"详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"back"]] forState:UIControlStateNormal];
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:FKLoginStateChangedNotificationKey object:nil];
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    self.navigationItem.leftMargin = 5;
}

- (void)fk_createViewForConctroller
{
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
