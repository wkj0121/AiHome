//
//  TQViewController2.m
//  TQGestureLockViewDemo_Example
//
//  Created by TQTeam on 2017/11/3.
//  Copyright © 2017年 TQTeam. All rights reserved.
//

#import "TQViewController2.h"
#import "TQGestureLockView.h"
#import "TQGesturesPasswordManager.h"
#import "TQGestureLockHintLabel.h"
#import "TQSucceedViewController.h"
#import "TQGestureLockToast.h"
#import "TouchIDViewController.h"

@interface TQViewController2 () <TQGestureLockViewDelegate>

@property (nonatomic, strong) TouchIDViewController *touchIDViewControl;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIButton *btnSwitch;
@property (nonatomic, strong) TQGestureLockView *lockView;
@property (nonatomic, strong) TQGestureLockHintLabel *hintLabel;
@property (nonatomic, strong) TQGesturesPasswordManager *passwordManager;
@property (nonatomic, assign) NSInteger restVerifyNumber;
@property (nonatomic, strong) UIViewController *rootVC;

@end

@implementation TQViewController2

- (instancetype)initWithVC:(UIViewController *)vc
{
    self = [super init];
    _rootVC = vc;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self commonInitialization];
    
    [self subviewsInitialization];
}

- (void)commonInitialization
{
    self.passwordManager = [TQGesturesPasswordManager manager];
    [self verifyInitialRestNumber];
}

- (TouchIDViewController *)touchIDViewControl {
    if(_touchIDViewControl == nil) {
        _touchIDViewControl = [[TouchIDViewController alloc] init];
    }
    return _touchIDViewControl;
}

- (UIImageView *)headerImageView {
    if(_headerImageView == nil) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.backgroundColor = [UIColor clearColor];
        // 设置图片
        _headerImageView.image = [UIImage imageNamed:@"seekco.png"];
        //  retina屏幕图片显示问题
        [_headerImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        //  不规则图片显示
        _headerImageView.contentMode =  UIViewContentModeScaleAspectFill;
        _headerImageView.autoresizesSubviews = YES;
        _headerImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    return _headerImageView;
}

- (UIButton *)btnSwitch {
    if(_btnSwitch == nil) {
        _btnSwitch = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
        [_btnSwitch setTitle:@"其它登录方式" forState:UIControlStateNormal];
        _btnSwitch.backgroundColor = [UIColor clearColor];
        [_btnSwitch setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        [_btnSwitch setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateHighlighted];
        _btnSwitch.titleLabel.textAlignment = NSTextAlignmentRight;
        [[_btnSwitch rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            [alertController addAction:[UIAlertAction actionWithTitle:@"使用指纹登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"指纹登录");
                [self.touchIDViewControl.touchIDAuthenticate touchIDAuthenticate];
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"使用密码登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"使用密码登录");
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击取消");
                return;
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }
    return _btnSwitch;
}

- (void)subviewsInitialization
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat spacing = TQSizeFitW(40);
    CGFloat diameter = (screenSize.width - spacing * 4) / 3;
    CGFloat bottom1 = TQSizeFitH(55);
    CGFloat width1 = screenSize.width;
    CGFloat top1 = screenSize.height - width1 - bottom1;
    CGRect rect1 = CGRectMake(0, top1, width1, width1);
    
    CGFloat width2 = screenSize.width, height2 = 30;
    CGFloat top2 = top1 - height2 -17;
    CGRect rect2 = CGRectMake(0, top2, width2, height2);
    
    TQGestureLockDrawManager *drawManager = [TQGestureLockDrawManager defaultManager];
    drawManager.circleDiameter = diameter;
    drawManager.edgeSpacingInsets = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    drawManager.bridgingLineWidth = 0.5;
    drawManager.hollowCircleBorderWidth = 0.5;
    
    _lockView = [[TQGestureLockView alloc] initWithFrame:rect1 drawManager:drawManager];
    _lockView.delegate = self;
    [self.view addSubview:_lockView];
    
    _hintLabel = [[TQGestureLockHintLabel alloc] initWithFrame:rect2];
    [self.view addSubview:_hintLabel];
    
    // 顶部图标
    [self.view addSubview:self.headerImageView];
    //设置布局Masonry
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(90);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(88, 88));
    }];
    
    // 底部其它方式登录
    [self.view addSubview:self.btnSwitch];
    [self.btnSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
}

#pragma mark - TQGestureLockViewDelegate

- (void)gestureLockView:(TQGestureLockView *)gestureLockView lessErrorSecurityCodeSting:(NSString *)securityCodeSting
{
    [gestureLockView setNeedsDisplayGestureLockErrorState:YES];
    [self verifyRestNumbers];
}

- (void)gestureLockView:(TQGestureLockView *)gestureLockView finalRightSecurityCodeSting:(NSString *)securityCodeSting
{
    if ([self.passwordManager verifyPassword:securityCodeSting]) {
        [gestureLockView setNeedsDisplayGestureLockErrorState:NO];
        [SVProgressHUD fk_displaySuccessWithStatus:@"验证成功"];
        // 2s后进入首页
        [SVProgressHUD dismissWithDelay:2.0f completion:^{
            if(_rootVC == nil){
                [self.navigationController popViewControllerAnimated:NO];
                [[UIApplication sharedApplication]  openURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@", NavPushRouteURL,@"TQViewController1"]] options:nil completionHandler:nil];
            }else{
                [[UIApplication sharedApplication].keyWindow setRootViewController:_rootVC];
            }
        }];
        [_hintLabel clearText];
        [self verifyInitialRestNumber];
    } else {
        [gestureLockView setNeedsDisplayGestureLockErrorState:YES];
        [self verifyRestNumbers];
    }
}

- (void)verifyInitialRestNumber {
    self.restVerifyNumber = 4;
}

- (void)verifyRestNumbers {
    if (self.restVerifyNumber < 1) {
        [self.view tq_showText:@"验证失败" afterDelay:2];
        [_hintLabel clearText];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    } else {
        NSString *text = [NSString stringWithFormat:@"密码错误，还可以再输入%lu次", self.restVerifyNumber];
        [_hintLabel setWarningText:text shakeAnimated:YES];
        self.restVerifyNumber -= 1;
    }
}

@end
