//
//  FKLoginInputFooterView.m
//  FXXKBaseMVVM
//
//  Created by 梁宪松 on 2017/12/10.
//  Copyright © 2017年 madao. All rights reserved.
//

#import "FKLoginInputFooterView.h"

@implementation FKLoginInputFooterView


- (void)fk_createViewForView
{
    [self addSubview:self.loginBtn];
    [self addSubview:self.queryBtn];
    [self addSubview:self.regBtn];
    [self addSubview:self.forgetPwdBtn];
}

#pragma mark - Layout
- (void)updateConstraints
{
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(20);
//        make.centerY.mas_equalTo(self.contentView.mas_centerY).multipliedBy(0.8);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.height.mas_equalTo(50);
    }];
    
    [self.queryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.loginBtn.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.loginBtn);
        make.size.mas_equalTo(self.loginBtn);
    }];
    
    [self.regBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-10);
    }];
    
    [self.forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-10);
    }];
    
    [super updateConstraints];
}

#pragma mark - Getter
- (FKLoginButton *)loginBtn
{
    if (!_loginBtn) {
        
        _loginBtn = [[FKLoginButton alloc] initWithFrame:CGRectZero];
        _loginBtn.enabled = NO;
    }
    return _loginBtn;
}

- (UIButton *)queryBtn
{
    if (!_queryBtn) {
        
        _queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_queryBtn setTitle:@"登录遇到问题？" forState:UIControlStateNormal];
        [_queryBtn setTitleColor:FKTHEMECOLOR forState:UIControlStateNormal];
        _queryBtn.titleLabel.font =  [UIFont systemFontOfSize:14];
    }
    return _queryBtn;
}


- (UIButton *)regBtn
{
    if (!_regBtn) {
        
        _regBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_regBtn setTitle:@"注册新用户" forState:UIControlStateNormal];
        [_regBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _regBtn.titleLabel.font =  [UIFont systemFontOfSize:14];
    }
    return _regBtn;
}

- (UIButton *)forgetPwdBtn
{
    if (!_forgetPwdBtn) {
        
        _forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPwdBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        [_forgetPwdBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _forgetPwdBtn.titleLabel.font =  [UIFont systemFontOfSize:14];
    }
    return _forgetPwdBtn;
}

@end
