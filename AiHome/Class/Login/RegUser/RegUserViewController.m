//
//  RegUserViewController.m
//  AiHome
//
//  Created by wkj on 2018/1/24.
//  Copyright © 2018年 华通晟云. All rights reserved.
//
#import "AppDelegate.h"
#import "RegUserViewController.h"
#import "RegUserView.h"
#import "RegGetCodeRequest.h"
#import "RegUserRequest.h"

@interface RegUserViewController ()

    @property (nonatomic, strong) RegUserView *regUserView;
//    @property (nonatomic, strong) TextFieldLimitManager *manager;

@end

@implementation RegUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavItem];
    //设置背景图标
    [self setupIcon];
    //添加视频导航功能视图
    [self.view addSubview:self.regUserView];
    [self.regUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(220);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.mas_equalTo(@350);
    }];
    // 是否可以获取验证码
    RAC(self.regUserView.getCodeBtn, enabled) = [ [RACObserve(self.regUserView.telPhone, text)  merge:self.regUserView.telPhone.rac_textSignal ] map:^id(NSString *value) {
        return @(value.length==11);
    }];
//    [self.regUserView.telPhone.rac_textSignal map:^id(NSString *value){
//        return @(value.length==11);
//    }];
    //是否可以注册
    RAC(self.regUserView.regBtn, enabled) =  [[RACSignal combineLatest:@[
                                                            RACObserve(self.regUserView.telPhone, text),
                                                            RACObserve(self.regUserView.regcode,text),
                                                            RACObserve(self.regUserView.regPwd,text)]
                                  ]
                                 map:^id _Nullable(RACTuple * _Nullable value) {
                                     RACTupleUnpack(NSString *telNum, NSString *code, NSString *pwd) = value;
                                     return @(telNum && code && pwd && telNum.length && code.length && pwd.length && self.regUserView.getCodeBtn.enabled);
                                 }];
    [[self.regUserView.getCodeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self openCountdown];
        RegGetCodeRequest *api = [[RegGetCodeRequest alloc] initWithTelNum:self.regUserView.telPhone.text];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
//            NSDictionary *responseDictionary = [request responseJSONObject];
            NSInteger status = request.responseStatusCode;
            if (200 == status) {
                NSLog(@"请求成功,返回数据:%@",request.responseString);
            } else {
                // 返回的status非法
               NSLog(@"请求出错,返回内容:%@",request.responseString);
            }
        } failure:^(YTKBaseRequest *request) {
            NSLog(@"请求失败");
        }];
//        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(openCountdown) userInfo:nil repeats:YES];
//        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }];
    [[self.regUserView.regBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"点击了注册");
        RegUserRequest *api = [[RegUserRequest alloc] initWithTelNum:self.regUserView.telPhone.text password:self.regUserView.regPwd.text code:self.regUserView.regcode.text];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            //            NSDictionary *responseDictionary = [request responseJSONObject];
            NSInteger status = request.responseStatusCode;
            if (200 == status) {
                NSLog(@"请求成功,返回数据:%@",request.responseString);
//                //本地存储账户密码
//                NSUserDefaults *defaut=[NSUserDefaults standardUserDefaults];
//                [defaut setObject:self.regUserView.telPhone.text forKey:@"account"];
//                [defaut setObject:self.regUserView.regPwd.text forKey:@"password"];
//                [defaut synchronize];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                // 返回的status非法
                NSLog(@"请求出错,返回内容:%@",request.responseString);
            }
        } failure:^(YTKBaseRequest *request) {
            NSLog(@"请求失败");
        }];
    }];
}

-(void)setupIcon{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor clearColor];
    // 设置图片
    imageView.image = [UIImage imageNamed:@"seekco.png"];
    //  retina屏幕图片显示问题
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    //  不规则图片显示
    imageView.contentMode =  UIViewContentModeScaleAspectFill;
    imageView.autoresizesSubviews = YES;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //  图片大于或小于显示区域
//    imageView.clipsToBounds  = YES;
    [self.view addSubview:imageView];
    //设置布局Masonry
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(90);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(88, 88));
    }];
}

#pragma mark - 定制导航条内容
- (void)customNavItem {
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"back"]] forState:UIControlStateNormal];
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:FKLoginStateChangedNotificationKey object:nil];
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    self.navigationItem.leftMargin = 5;
}

#pragma mark - 初始化用户注册视图
-(RegUserView *)regUserView
{
    if (!_regUserView) {
        RegUserView *tempRegUserView = [[RegUserView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        self.regUserView = tempRegUserView;
    }
    return _regUserView;
}

#pragma mark - 开启倒计时获取验证码效果
-(void)openCountdown{
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.regUserView.getCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.regUserView.getCodeBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
                self.regUserView.getCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.regUserView.getCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.regUserView.getCodeBtn setTitleColor:COLOR_RGB(151, 151, 151) forState:UIControlStateNormal];
                self.regUserView.getCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

@end
