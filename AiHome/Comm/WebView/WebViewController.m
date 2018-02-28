//
//  WebViewController.m
//  ConnectedHome
//
//  Created by wkj on 2017/12/13.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "WKProcessPool+SharedProcessPool.h"

@interface WebViewController () <WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate,WKScriptMessageHandler,UINavigationControllerDelegate>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.webView];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    self.webView.scrollView.delegate = self;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    // 开始右滑返回手势
    self.webView.allowsBackForwardNavigationGestures = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    // 加载页面
    if (self.urlString.length) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlString]];
        [self.webView loadRequest:request];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark LazyLoad
- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];  //WKWebview配置对象
        WKPreferences *preference = [[WKPreferences alloc]init];
        config.preferences = preference;
        //是否允许与js进行交互，默认是YES的，如果设置为NO，js的代码就不起作用了
        preference.javaScriptEnabled = YES;
        //使用单例 解决locastorge 储存问题
        config.processPool = [WKProcessPool sharedProcessPool];
        //交互的重要之点
        WKUserContentController *userContentController = [[WKUserContentController alloc]init];
        //切记Share方法名一定要和H5开发人员协商定好self指当前控制器，切记这个代理要添加 WKScriptMessageHandler  不然会报警告
        [userContentController addScriptMessageHandler:self name:@"Back"];
        [userContentController addScriptMessageHandler:self name:@"openURL"];
        [userContentController addScriptMessageHandler:self name:@"SetItem"];
        [userContentController addScriptMessageHandler:self name:@"GetItem"];
        config.userContentController = userContentController;
        // 用户信息
        NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        // 获取区域id
        NSNumber *regionid = [[NSUserDefaults standardUserDefaults] valueForKey:@"regionid"];
        if (jsonString) {
            NSString *jsString = [NSString stringWithFormat:@"localStorage.setItem('%@','%@');localStorage.setItem('%@',%@);",@"userjson", jsonString,@"homeid",[regionid stringValue]];
            jsString = [self removeWhiteSpaceString:jsString];
            WKUserScript *userScript = [[WKUserScript alloc] initWithSource:jsString injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
            [config.userContentController addUserScript:userScript];
        }
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) configuration:config];
    }
    return _webView;
}

- (void)addScriptMessageHandler:(id <WKScriptMessageHandler>)scriptMessageHandler name:(NSString *)name
{
    NSLog(@"%@",name);
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
//    NSLog(@"------------------");
//    NSLog(@"方法名:%@", message.name);
//    NSLog(@"参数:%@", message.body);
    if ([message.name isEqualToString:@"Back"]) {
//        NSLog(@"点击调用了Back。。");
        [self.navigationController popViewControllerAnimated:YES];
    }else if([message.name isEqualToString:@"openURL"]){
        NSString *url = [message.body objectForKey:@"url"];
        NSString *urlString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *toUrl = [NSString stringWithFormat:@"%@%@?urlString=%@", NavPushRouteURL,@"WebViewController",urlString];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:toUrl] options:nil completionHandler:nil];
    }else if ([message.name isEqualToString:@"SetItem"]){
        // 设置localStorage
        NSString *jsString = [NSString stringWithFormat:@"localStorage.setItem('%@', '%@')",[message.body objectForKey:@"key"], [message.body objectForKey:@"value"]];
        [self.webView evaluateJavaScript:jsString completionHandler:nil];
    }else if ([message.name isEqualToString:@"GetItem"]){
        NSLog(@"%@",message.body);
        NSString *jsString = [NSString stringWithFormat:@"localStorage.getItem('%@')",message.body];
        [self.webView evaluateJavaScript:jsString completionHandler:^(id _Nullable info, NSError * _Nullable error) {
            NSLog(@"-----%@-----",info);
        }];
    }
}

#pragma mark
#pragma mark - WKUIDelegate

/*
 *响应JS里的alert提醒
 */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark
#pragma mark - Show Message

- (void)showMessageWithParams:(NSDictionary *)dict {
    
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *messageStr = [dict objectForKey:@"message"];
    NSString *titleStr = [dict objectForKey:@"title"];
    NSLog(@"title:%@", titleStr);
    NSLog(@"messageStr:%@", messageStr);
    
    // do it
    
    // 将结果返回给js
    NSString *returnJSStr = [NSString stringWithFormat:@"showMessageFromWKWebViewResult('%@')", @"message传到OC成功，message传到OC成功，message传到OC成功，message传到OC成功，message传到OC成功，message传到OC成功"];
    [self.webView evaluateJavaScript:returnJSStr completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        NSLog(@"%@,%@", result, error);
    }];
}

//// 页面加载完成之后调用
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
//{
//
//}

- (void)fk_initialDefaultsForController
{
    if(!self.urlString){
        self.urlString = [self.params objectForKey:@"urlString"];
    }
}

-(void)fk_bindViewModelForController
{
    
}

- (void)fk_configNavigationForController
{
    
}

- (void)fk_createViewForConctroller
{
    
}

#pragma mark - UINavigationControllerDelegate 隐藏导航栏
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];

    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)dealloc {
    self.navigationController.delegate = nil;
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"Back"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"openURL"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"SetItem"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"GetItem"];
}

- (NSString *)removeWhiteSpaceString:(NSString *)newString {
    //去除掉首尾的空白字符和换行字符
    newString = [newString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    newString = [newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符使用
    newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newString;
}

@end
