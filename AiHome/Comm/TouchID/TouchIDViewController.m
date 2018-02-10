//
//  TouchIDViewController.m
//  ConnectedHome
//
//  Created by wkj on 2017/12/16.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import "TouchIDViewController.h"

@interface TouchIDViewController ()

@end

@implementation TouchIDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景图标
    [self setupIcon];
    [self commonInitialization];
//    //评估指纹验证
//    [self.touchIDAuthenticate.evaluateAuthenticate];
    //指纹验证
//    [self.touchIDAuthenticate touchIDAuthenticate];
    //注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vaildTouchID:) name:@"eventTouchID" object:self.touchIDAuthenticate];
    // Do any additional setup after loading the view, typically from a nib.
}

- (TouchIDAuthenticate *)touchIDAuthenticate {
    if(_touchIDAuthenticate == nil){
        _touchIDAuthenticate = [[TouchIDAuthenticate alloc] init];
    }
    return _touchIDAuthenticate;
}

- (void)commonInitialization
{
//    self.touchIDAuthenticate = [[TouchIDAuthenticate alloc] init];
//    TouchIDAuthenticate *touchIDAuthenticate = [TouchIDAuthenticate new];
}

-(void)vaildTouchID:(NSNotification *)msg{
    NSLog(@"%@ === %@ === %@", msg.object,msg.userInfo, msg.name);
    NSNumber *num = [NSNumber numberWithBool:[msg.userInfo objectForKey:@"isVaild"]];
    BOOL isVaild = [num boolValue];
    if(isVaild){
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }
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
    imageView.clipsToBounds  = YES;
    [self.view addSubview:imageView];
    //设置布局Masonry
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(100);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"eventTouchID" object:self.touchIDAuthenticate];
    NSLog(@"移除通知完成！");
}
@end
