//
//  PasswordTextField.m
//  AiHome
//
//  Created by macbook on 2018/2/9.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "PasswordTextField.h"

@implementation PasswordTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.secureTextEntry = YES;
        self.borderStyle = UITextBorderStyleLine;
        self.leftViewMode = UITextFieldViewModeAlways;
        UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        leftView.backgroundColor = [UIColor clearColor];
        self.leftView = leftView;
        self.clearButtonMode = UITextFieldViewModeAlways;
        self.returnKeyType = UIReturnKeyDone;
    }
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(paste:))//粘贴
    {
        return NO;
    }
    else if (action == @selector(copy:))//赋值
    {
        return NO;
    }
    else if (action == @selector(select:))//选择
    {
        return NO;
    }
    else if (action == @selector(selectAll:))//选择全部
    {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

@end
