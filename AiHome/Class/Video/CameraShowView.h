//
//  CameraShowView.h
//  AiHome
//
//  Created by wkj on 2018/1/11.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraShowView : UIView

    @property (nonatomic, strong) UIView *realPlayView;
    @property (nonatomic, strong) UILabel *frameRate;
    @property (nonatomic, strong) UIView *ptzView;
    @property (nonatomic, strong) UIButton *topBtn;
    @property (nonatomic, strong) UIButton *leftBtn;
    @property (nonatomic, strong) UIButton *rightBtn;
    @property (nonatomic, strong) UIButton *bottomBtn;
    @property (nonatomic, strong) UIButton *lockBtn;
    @property (nonatomic, strong) UIButton *closeVideoBtn;
    @property (nonatomic, strong) UIButton *securityBtn;

@end
