//
//  RegUserView.m
//  AiHome
//
//  Created by wkj on 2018/1/24.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "RegUserView.h"

@implementation RegUserView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        /* 添加子控件的代码*/
        //        self.imageView = [[UIImageView alloc]init];
        //        [self addSubview:self.imageView];
        self.backgroundColor = COLOR_WHITE;
        [self addSubview:self.telPhone];
        [self addSubview:self.regcode];
        [self addSubview:self.getCodeBtn];
        [self addSubview:self.regPwd];
        [self addSubview:self.regConfirmPwd];
        [self addSubview:self.regBtn];
    }
    return self;
}


- (void)layoutSubviews {
    // 一定要调用super的方法
    [super layoutSubviews];
    // 确定子控件的frame（这里得到的self的frame/bounds才是准确的）
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
//    self.telPhone.frame = CGRectMake(0, 0, width*0.8, 50);
    [self.telPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left).offset(30);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.8);
        make.height.mas_equalTo(@50);
    }];
    [self.regcode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.telPhone.mas_bottom).offset(10);
        make.left.mas_equalTo(self.telPhone.mas_left);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.52);
        make.height.mas_equalTo(self.telPhone.mas_height);
    }];
    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.telPhone.mas_right);
        make.bottom.mas_equalTo(self.regcode.mas_bottom);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.25);
        make.height.mas_equalTo(@40);
    }];
    [self.regPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.regcode.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.telPhone.mas_centerX);
        make.width.mas_equalTo(self.telPhone.mas_width);
        make.height.mas_equalTo(self.telPhone.mas_height);
    }];
    [self.regConfirmPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.regPwd.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.telPhone.mas_centerX);
        make.width.mas_equalTo(self.telPhone.mas_width);
        make.height.mas_equalTo(self.telPhone.mas_height);
    }];
    [self.regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.regConfirmPwd.mas_bottom).offset(25);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(self.telPhone.mas_width).multipliedBy(0.6);
        make.height.mas_equalTo(@35);
    }];
}


-(XTextField *)telPhone{
    if (!_telPhone) {
        XTextField *telPhone = [[XTextField alloc]init];
        telPhone.placeholder = @"请输入手机号码";
        telPhone.font = [UIFont systemFontOfSize:15.0f];
        telPhone.keyboardType = UIKeyboardTypeNumberPad;
        UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone"]];
        telPhone.leftView=image;
        telPhone.leftViewMode = UITextFieldViewModeAlways;
//        UIView *rightVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 134, 24)];
//        UIImageView* xImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_x"]];
//        xImageView.frame = CGRectMake(10, 5,14,14);
//        [rightVeiw addSubview:xImageView];
//        [rightVeiw addSubview:self.getCodeBtn];
//        telPhone.rightView=rightVeiw;
//        xImageView.userInteractionEnabled = YES;
//        UITapGestureRecognizer *xImageViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(xImageViewClick:)];
//        [xImageView addGestureRecognizer:xImageViewTap];
//        telPhone.rightViewMode = UITextFieldViewModeWhileEditing;
        telPhone.clearButtonMode = UITextFieldViewModeWhileEditing;
        telPhone.returnKeyType =UIReturnKeyDone;
        self.telPhone = telPhone;
    }
    return _telPhone;
}

-(XTextField *)regPwd{
    if (!_regPwd) {
        XTextField *regPwd = [[XTextField alloc]init];
        regPwd.placeholder = @"设置密码";
        regPwd.font = [UIFont systemFontOfSize:16.0f];
        regPwd.secureTextEntry = YES;
        UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwd"]];
        regPwd.leftView=image;
        regPwd.leftViewMode = UITextFieldViewModeAlways;
        regPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
        regPwd.returnKeyType =UIReturnKeyDone;
        self.regPwd = regPwd;
    }
    return _regPwd;
}

-(XTextField *)regConfirmPwd{
    if (!_regConfirmPwd) {
        XTextField *regComfirmPwd = [[XTextField alloc]init];
        regComfirmPwd.placeholder = @"确认密码";
        regComfirmPwd.font = [UIFont systemFontOfSize:16.0f];
        regComfirmPwd.secureTextEntry = YES;
        UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwd"]];
        regComfirmPwd.leftView=image;
        regComfirmPwd.leftViewMode = UITextFieldViewModeAlways;
        regComfirmPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
        regComfirmPwd.returnKeyType =UIReturnKeyDone;
        self.regConfirmPwd = regComfirmPwd;
    }
    return _regConfirmPwd;
}

-(XTextField *)regcode{
    if (!_regcode) {
        XTextField *regcode = [[XTextField alloc]init];
        regcode.placeholder = @"请输入验证码";
        regcode.font = [UIFont systemFontOfSize:16.0f];
        UIImageView *image=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pwd"]];
        regcode.leftView=image;
        regcode.leftViewMode = UITextFieldViewModeAlways;
        regcode.clearButtonMode = UITextFieldViewModeWhileEditing;
        regcode.returnKeyType =UIReturnKeyDone;
        //设置下边线
//        CALayer *layer = [CALayer layer];
//        layer.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
//        layer.backgroundColor = COLOR_RGB(239, 239, 239).CGColor;
//        [regcode.layer addSublayer:layer];
        self.regcode = regcode;
    }
    return _regcode;
}

-(UIButton *)getCodeBtn{
    if (!_getCodeBtn) {
//        UIButton *getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(34, 0, 100, 24)];
        UIButton *getCodeBtn = [[UIButton alloc] init];
        getCodeBtn.layer.masksToBounds = YES;
//        getCodeBtn.layer.cornerRadius = 5.0f;
        [getCodeBtn setBackgroundImage:[UIImage imageWithColor:THEMECOLOR] forState:UIControlStateNormal];
        [getCodeBtn setBackgroundImage:[UIImage imageWithColor:[THEMECOLOR colorWithAlphaComponent:0.3] ] forState:UIControlStateDisabled];
        [getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [getCodeBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        getCodeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        self.getCodeBtn = getCodeBtn;
    }
    return _getCodeBtn;
}

-(UIButton *)regBtn{
    if (!_regBtn) {
        UIButton *regBtn = [[UIButton alloc]init];
        regBtn.layer.masksToBounds = YES;
        regBtn.layer.cornerRadius = 10.0f;
        [regBtn setBackgroundImage:[UIImage imageWithColor:THEMECOLOR] forState:UIControlStateNormal];
        [regBtn setBackgroundImage:[UIImage imageWithColor:[THEMECOLOR colorWithAlphaComponent:0.3] ] forState:UIControlStateDisabled];
        [regBtn setTitle:@"注册" forState:UIControlStateNormal];
        [regBtn setTitleColor:COLOR_WHITE forState:UIControlStateNormal];
        regBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        regBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
        self.regBtn = regBtn;
    }
    return _regBtn;
}

- (void)xImageViewClick:(UITextField*) textField
{
    if(self.telPhone.editing)
    {
        [self.telPhone setText:@""];
    }
}

@end
