//
//  VerifyViewController.m
//  AiHome
//
//  Created by macbook on 2018/2/9.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "VerifyViewController.h"
#import "PasswordTextField.h"
#import "TQViewController1.h"

@interface VerifyViewController ()

@property (nonatomic, strong) PasswordTextField *textField;

@end

@implementation VerifyViewController

- (PasswordTextField *)textField {
    if(_textField == nil){
        _textField = [[PasswordTextField alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        [_textField becomeFirstResponder];
        _textField.delegate = self;
        _textField.enablesReturnKeyAutomatically = YES;
    }
    return _textField;
}

- (void)didLayout {
    // 主view
    self.view.backgroundColor = [UIColor whiteColor];
    // 标题栏
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
    [titleLabel setText:@"请输入密码："];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(250);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(250, 40));
    }];
    // 密码输入框
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(250, 40));
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self didLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    [self.textField becomeFirstResponder];
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *updatedString = [self.textField.text stringByReplacingCharactersInRange:range withString:string];
    self.textField.text = updatedString;
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.textField) {
        if([self.textField.text isEqualToString:[UserInfoManager shareUser].userPassword]){
            // 进入手势设置页面
            UIViewController *tqVC = [[TQViewController1 alloc] init];
            tqVC.view.backgroundColor = [UIColor whiteColor];
            tqVC.navigationItem.title = @"设置手势密码";
            [self.navigationController pushViewController:tqVC animated:YES];
            NSMutableArray *marray = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
            for (UIViewController *vc in marray) {
                if ([vc isKindOfClass:[self class]]) {
                    [marray removeObject:vc];
                    break;
                }
            }
            self.navigationController.viewControllers = marray;
        }else{
            [self shake:self.textField];
        }
        return NO;
    }
    return YES;
}

@end
