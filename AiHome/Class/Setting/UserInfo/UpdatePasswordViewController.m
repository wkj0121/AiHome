//
//  UpdatePasswordViewController.m
//  AiHome
//
//  Created by macbook on 2018/2/24.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "UpdatePasswordViewController.h"
#import "FKPwdInputView.h"
#import "UpdatePasswordRequest.h"

@interface UpdatePasswordViewController ()

@property(nonatomic, strong)FKPwdInputView *pwdCell;
@property(nonatomic, strong)FKPwdInputView *updatePasswordCell;
@property(nonatomic, strong)FKPwdInputView *updatePassword2Cell;
@property(nonatomic, strong)UIButton *updateButton;

@end

@implementation UpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置导航栏
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];
    // 布局
    [self didLayout];
    // 验证
    RAC(self.updateButton, enabled) = [[RACSignal combineLatest:@[RACObserve(self.pwdCell.inputTextFiled, text),RACObserve(self.updatePasswordCell.inputTextFiled,text),RACObserve(self.updatePassword2Cell.inputTextFiled,text)]] map:^id _Nullable(RACTuple * _Nullable value) {
           RACTupleUnpack(NSString *pwd, NSString *updatePwd, NSString *updatePwd2) = value;
           return @(pwd && updatePwd && updatePwd2 && pwd.length && updatePwd.length && updatePwd2.length);
    }];
    // 修改
    @weakify(self);
    [[self.updateButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        // 获取用户信息
        UserInfoManager *userInfo = [UserInfoManager shareUser];
        NSString *sPwd = self.pwdCell.inputTextFiled.text;
        NSString *sNewPwd = self.updatePasswordCell.inputTextFiled.text;
        // 密码校验
        if (![sPwd isEqualToString:userInfo.userPassword]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            //背景半透明的效果
            hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
            hud.bezelView.backgroundColor = COLOR_RGB(245, 245, 245);
            hud.label.textColor = COLOR_RGB(226, 21, 20);
            hud.label.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightHeavy];
            hud.label.textAlignment = NSTextAlignmentCenter;
            hud.label.text = @"输入的密码不正确！";
            hud.dimBackground = YES;// YES代表需要蒙版效果
            [hud hideAnimated:YES afterDelay:1.f];
            [self.pwdCell.inputTextFiled becomeFirstResponder];
            [self shake:self.pwdCell];//左右震动效果
            return;
        }
        if (![sNewPwd isEqualToString:self.updatePassword2Cell.inputTextFiled.text]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            //背景半透明的效果
            hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
            hud.bezelView.backgroundColor = COLOR_RGB(245, 245, 245);
            hud.label.textColor = COLOR_RGB(226, 21, 20);
            hud.label.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightHeavy];
            hud.label.textAlignment = NSTextAlignmentCenter;
            hud.label.text = @"两次密码输入不一致，请重新输入！";
            hud.dimBackground = YES;// YES代表需要蒙版效果
            [hud hideAnimated:YES afterDelay:1.f];
            [self.updatePassword2Cell.inputTextFiled becomeFirstResponder];
            [self shake:self.updatePassword2Cell];//左右震动效果
            return;
        }
        // 修改请求
        NSDictionary *dic = @{@"telNum": userInfo.telNum, @"newPwd": self.updatePasswordCell.inputTextFiled.text};
        UpdatePasswordRequest *api = [[UpdatePasswordRequest alloc] initWithParams:dic];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            NSInteger status = request.responseStatusCode;
            if (200 == status && [request statusCodeValidator]) {
                [SVProgressHUD fk_displaySuccessWithStatus:@"修改成功"];
                // 保存修改信息
                userInfo.userPassword = self.updatePasswordCell.inputTextFiled.text;
                // 修改缓存数据
                NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"];
                NSMutableDictionary *mUserDic = [[NSMutableDictionary alloc] initWithDictionary:userDic];
                [mUserDic setValue:self.updatePasswordCell.inputTextFiled.text forKey:@"userPassword"];
                [[NSUserDefaults standardUserDefaults] setObject:mUserDic forKey:@"UserInfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [SVProgressHUD fk_displayErrorWithStatus:@"修改失败"];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [SVProgressHUD fk_displayErrorWithStatus:@"修改失败"];
        }];
    }];
}

- (FKPwdInputView *)pwdCell {
    if(_pwdCell == nil) {
        FKPwdInputView *cell = [[FKPwdInputView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width - 80, 40)];
        cell.inputTextFiled.placeholder = @"请输入原始密码";
        [self.view addSubview:cell];
        _pwdCell = cell;
    }
    return _pwdCell;
}

- (FKPwdInputView *)updatePasswordCell {
    if(_updatePasswordCell == nil) {
        FKPwdInputView *cell = [[FKPwdInputView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width - 80, 40)];
        cell.inputTextFiled.placeholder = @"请输入新密码";
        [self.view addSubview:cell];
        _updatePasswordCell = cell;
    }
    return _updatePasswordCell;
}

- (FKPwdInputView *)updatePassword2Cell {
    if(_updatePassword2Cell == nil) {
        FKPwdInputView *cell = [[FKPwdInputView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width - 80, 40)];
        cell.inputTextFiled.placeholder = @"请重复新密码";
        [self.view addSubview:cell];
        _updatePassword2Cell = cell;
    }
    return _updatePassword2Cell;
}

- (UIButton *)updateButton {
    if(!_updateButton) {
        UIButton *regBtn = [[UIButton alloc] init];
        regBtn.layer.masksToBounds = YES;
        regBtn.layer.cornerRadius = 6.0f;
        [regBtn setBackgroundImage:[UIImage imageWithColor:THEMECOLOR] forState:UIControlStateNormal];
        [regBtn setBackgroundImage:[UIImage imageWithColor:[THEMECOLOR colorWithAlphaComponent:0.3] ] forState:UIControlStateDisabled];
        [regBtn setTitle:@"修改" forState:UIControlStateNormal];
        [regBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        regBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        regBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        [self.view addSubview:regBtn];
        _updateButton = regBtn;
    }
    return _updateButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didLayout {
    // 屏幕宽度
    CGFloat pWidth = self.view.frame.size.width;
    // 原始密码
    [self.pwdCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-40);
        make.top.mas_equalTo(self.view.mas_top).offset(100);
        make.height.mas_equalTo(@40);
    }];
    // 新密码
    [self.updatePasswordCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-40);
        make.top.mas_equalTo(self.pwdCell.mas_bottom).offset(25);
        make.height.mas_equalTo(@40);
    }];
    // 重复密码
    [self.updatePassword2Cell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(40);
        make.right.mas_equalTo(self.view.mas_right).offset(-40);
        make.top.mas_equalTo(self.updatePasswordCell.mas_bottom).offset(25);
        make.height.mas_equalTo(@40);
    }];
    // 修改按钮
    [self.updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.updatePassword2Cell.mas_bottom).offset(25);
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.5);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(@40);
    }];
}

//左右震动效果
- (void)shake:(UIView *)view {
    CGRect frame = view.frame;
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef shakePath = CGPathCreateMutable();
    CGPathMoveToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
    int index;
    for (index = 3; index >=0; --index) {
        CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2 - frame.size.width * 0.02f * index, frame.origin.y+frame.size.height/2);
        CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2 + frame.size.width * 0.02f * index, frame.origin.y+frame.size.height/2);
    }
    CGPathCloseSubpath(shakePath);
    
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = 0.5f;
    shakeAnimation.removedOnCompletion = YES;
    
    [view.layer addAnimation:shakeAnimation forKey:nil];
    CFRelease(shakePath);
}

@end
