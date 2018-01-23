//
//  RegUserView.h
//  AiHome
//
//  Created by wkj on 2018/1/24.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTextField.h"

@interface RegUserView : UIView

@property (nonatomic, strong) XTextField *telPhone;
@property (nonatomic, strong) XTextField *regPwd;
@property (nonatomic, strong) XTextField *regConfirmPwd;
@property (nonatomic, strong) XTextField *regcode;
@property (nonatomic, strong) UIButton *regBtn;
@property (nonatomic, strong) UIButton *getCodeBtn;

@end
