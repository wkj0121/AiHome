//
//  FKPwdInputView.m
//  AiHome
//
//  Created by macbook on 2018/2/26.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "FKPwdInputView.h"

@implementation FKPwdInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = COLOR_WHITE;
        [self addSubview:self.inputTextFiled];
        [self addSubview:self.operateButton];
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height - 1.0f, self.frame.size.width, 1.0f);
        bottomBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
        [self.layer addSublayer:bottomBorder];
    }
    return self;
}

- (void)layoutSubviews {
    // 一定要调用super的方法
    [super layoutSubviews];
    // 确定子控件的frame（这里得到的self的frame/bounds才是准确的）
    self.inputTextFiled.delegate = self;
    [self.inputTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.8);
    }];
    [self.operateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.centerY.mas_equalTo(self.inputTextFiled.mas_centerY);
    }];
    
    // 密码显示和切换
    @weakify(self);
    [[self.operateButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.operateButton.selected = !self.operateButton.selected;
        self.inputTextFiled.secureTextEntry = !self.operateButton.selected;
    }];
    
    // 绑定密码
    [self.inputTextFiled.rac_textSignal subscribeNext:^(NSString* x){
        @strongify(self);
        if (x.length > 25) {
            self.inputTextFiled.text = [x substringToIndex:25];
        }
     }];
}

-(UITextField *)inputTextFiled{
    if (!_inputTextFiled) {
        UITextField *regPwd = [[UITextField alloc]init];
        regPwd.placeholder = @"请输入密码";
        regPwd.font = [UIFont systemFontOfSize:16.0f];
        regPwd.spellCheckingType = UITextSpellCheckingTypeNo;
        regPwd.autocorrectionType = UITextAutocorrectionTypeNo;
        regPwd.autocapitalizationType = UITextAutocapitalizationTypeNone;
        regPwd.keyboardType = UIKeyboardTypeASCIICapable;
        regPwd.secureTextEntry = YES;
        regPwd.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputTextFiled = regPwd;
    }
    return _inputTextFiled;
}

-(UIButton *)operateButton{
    if (!_operateButton) {
        UIButton *regBtn = [[UIButton alloc]init];
        [regBtn setImage:[UIImage imageNamed:@"login_hide_pwd"] forState:UIControlStateNormal];
        [regBtn setImage:[UIImage imageNamed:@"login_show_pwd"] forState:UIControlStateSelected];
        _operateButton = regBtn;
    }
    return _operateButton;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *updatedString = [self.inputTextFiled.text stringByReplacingCharactersInRange:range withString:string];
    self.inputTextFiled.text = updatedString;
    return NO;
}

@end
