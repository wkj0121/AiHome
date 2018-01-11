//
//  CameraShowView.m
//  AiHome
//
//  Created by wkj on 2018/1/11.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "HCWSNetSDK.h"
#import "CameraShowView.h"

#pragma mark CameraShowView
@interface CameraShowView ()
    
@end

@implementation CameraShowView

CGFloat ptzRadius = 80.f;//ptz view的半径值

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        /* 添加子控件的代码*/
        self.backgroundColor = COLOR_WHITE;
        [self addSubview:self.realPlayView];
        self.realPlayView.backgroundColor = COLOR_RGB(35, 25, 22);
        self.realPlayView.userInteractionEnabled = YES;
        [self addSubview:self.frameRate];
        [self addSubview:self.ptzView];
        [self.ptzView addSubview:self.leftBtn];
        [self.ptzView addSubview:self.rightBtn];
        [self.ptzView addSubview:self.topBtn];
        [self.ptzView addSubview:self.bottomBtn];
        [self.ptzView addSubview:self.lockBtn];
        [self addSubview:self.closeVideoBtn];
        [self addSubview:self.securityBtn];
//        self.frameRate.backgroundColor = COLOR_GREEN;
//        self.ptzView.backgroundColor = COLOR_BLACK;
    }
    return self;
}

- (void)layoutSubviews {
    // 一定要调用super的方法
    [super layoutSubviews];
    // 确定子控件的frame（这里得到的self的frame/bounds才是准确的）
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    self.frameRate.frame = CGRectMake(0, 0, 100, 50);
    self.realPlayView.frame = CGRectMake(0, 50, width, width*0.618);
    self.ptzView.frame = CGRectMake(width/2-ptzRadius, 50+width*0.618+((height-50-width*0.618-ptzRadius*2)/2), ptzRadius*2, ptzRadius*2);
    //设置ptzView四个方向按钮frame
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.ptzView.mas_left).offset(2);
        make.centerY.mas_equalTo(self.ptzView.mas_centerY);
        make.width.equalTo(@40);
        make.height.mas_equalTo(@40);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.ptzView.mas_right).offset(-2);
        make.centerY.mas_equalTo(self.ptzView.mas_centerY);
        make.width.equalTo(@40);
        make.height.mas_equalTo(@40);
    }];
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.ptzView.mas_top).offset(2);
        make.centerX.mas_equalTo(self.ptzView.mas_centerX);
        make.width.equalTo(@40);
        make.height.mas_equalTo(@40);
    }];
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.ptzView.mas_bottom).offset(-2);
        make.centerX.mas_equalTo(self.ptzView.mas_centerX);
        make.width.equalTo(@40);
        make.height.mas_equalTo(@40);
    }];
    [self.lockBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.ptzView.mas_centerX);
        make.centerY.mas_equalTo(self.ptzView.mas_centerY);
        make.width.equalTo(@60);
        make.height.mas_equalTo(@60);
    }];
    [self.closeVideoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.ptzView.mas_left).offset(-(self.ptzView.frame.origin.x/2));
        make.centerY.mas_equalTo(self.ptzView.mas_centerY).offset(15);
        make.width.equalTo(@60);
        make.height.mas_equalTo(@100);
    }];
    [self.securityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.ptzView.mas_right).offset((width-self.ptzView.frame.size.width)/4);
        make.centerY.mas_equalTo(self.ptzView.mas_centerY).offset(15);
        make.width.equalTo(@60);
        make.height.mas_equalTo(@100);
    }];
    // button标题的偏移量
    self.closeVideoBtn.titleEdgeInsets = UIEdgeInsetsMake(self.closeVideoBtn.imageView.frame.size.height+15, -self.closeVideoBtn.imageView.bounds.size.width, 0,0);
    // button图片的偏移量
    self.closeVideoBtn.imageEdgeInsets = UIEdgeInsetsMake(0, self.closeVideoBtn.titleLabel.frame.size.width/2, self.closeVideoBtn.titleLabel.frame.size.height+15, -self.closeVideoBtn.titleLabel.frame.size.width/2);
    // button标题的偏移量
    self.securityBtn.titleEdgeInsets = UIEdgeInsetsMake(self.securityBtn.imageView.frame.size.height+15, -self.securityBtn.imageView.bounds.size.width, 0,0);
    // button图片的偏移量
    self.securityBtn.imageEdgeInsets = UIEdgeInsetsMake(0, self.securityBtn.titleLabel.frame.size.width/2, self.securityBtn.titleLabel.frame.size.height+15, -self.securityBtn.titleLabel.frame.size.width/2);
}

-(UIView *)realPlayView{
    if (!_realPlayView) {
        UIView *realPlayView = [[UIView alloc] init];
        self.realPlayView = realPlayView;
    }
    return _realPlayView;
}

-(UILabel *)frameRate{
    if (!_frameRate) {
        UILabel *frameRate = [[UILabel alloc] init];
        frameRate.textColor = COLOR_BLACK;
        frameRate.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightThin];
        frameRate.textAlignment = NSTextAlignmentCenter;
        [frameRate setText:@"码率：0 KB/s"];
        self.frameRate = frameRate;
    }
    return _frameRate;
}
-(UIButton *)topBtn{
    if (!_topBtn) {
        UIButton *topBtn = [[UIButton alloc] init];
        [topBtn setImage:[UIImage imageNamed:@"arrow-up_selected"] forState:UIControlStateNormal];
        [topBtn setImage:[UIImage imageNamed:@"arrow-up_selected"] forState:UIControlStateSelected];
        [topBtn setImage:[UIImage imageNamed:@"arrow-up_locked"] forState:UIControlStateDisabled];
        [topBtn setEnabled:NO];
        self.topBtn = topBtn;
    }
    return _topBtn;
}
-(UIButton *)leftBtn{
    if (!_leftBtn) {
        UIButton *leftBtn = [[UIButton alloc] init];
        [leftBtn setImage:[UIImage imageNamed:@"arrow-left_selected"] forState:UIControlStateNormal];
        [leftBtn setImage:[UIImage imageNamed:@"arrow-left_selected"] forState:UIControlStateSelected];
        [leftBtn setImage:[UIImage imageNamed:@"arrow-left_locked"] forState:UIControlStateDisabled];
        [leftBtn setEnabled:NO];
        //        historyBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.leftBtn = leftBtn;
    }
    return _leftBtn;
}
-(UIButton *)rightBtn{
    if (!_rightBtn) {
        UIButton *rightBtn = [[UIButton alloc] init];
        [rightBtn setImage:[UIImage imageNamed:@"arrow-right_selected"] forState:UIControlStateNormal];
        [rightBtn setImage:[UIImage imageNamed:@"arrow-right_selected"] forState:UIControlStateSelected];
        [rightBtn setImage:[UIImage imageNamed:@"arrow-right_locked"] forState:UIControlStateDisabled];
        [rightBtn setEnabled:NO];
        self.rightBtn = rightBtn;
    }
    return _rightBtn;
}
-(UIButton *)bottomBtn{
    if (!_bottomBtn) {
        UIButton *bottomBtn = [[UIButton alloc] init];
        [bottomBtn setImage:[UIImage imageNamed:@"arrow-down_selected"] forState:UIControlStateNormal];
        [bottomBtn setImage:[UIImage imageNamed:@"arrow-down_selected"] forState:UIControlStateSelected];
        [bottomBtn setImage:[UIImage imageNamed:@"arrow-down_locked"] forState:UIControlStateDisabled];
        [bottomBtn setEnabled:NO];
        self.bottomBtn = bottomBtn;
    }
    return _bottomBtn;
}
-(UIButton *)lockBtn{
    if (!_lockBtn) {
        UIButton *lockBtn = [[UIButton alloc] init];
        [lockBtn setImage:[UIImage imageNamed:@"lockPTZ_normal"] forState:UIControlStateNormal];
        [lockBtn setImage:[UIImage imageNamed:@"lockPTZ_selected"] forState:UIControlStateSelected];
        lockBtn.selected = YES;//初始selected应设为NO，为normal状态即是锁定状态.
        self.lockBtn = lockBtn;
    }
    return _lockBtn;
}
-(UIButton *)closeVideoBtn{
    if (!_closeVideoBtn) {
        UIButton *closeVideoBtn = [[UIButton alloc] init];
        [closeVideoBtn setImage:[UIImage imageNamed:@"closeVideo_normal"] forState:UIControlStateNormal];
        [closeVideoBtn setImage:[UIImage imageNamed:@"closeVideo_selected"] forState:UIControlStateSelected];
        [closeVideoBtn setTitle:@"关闭" forState:UIControlStateNormal];
        [closeVideoBtn setTitleColor:COLOR_GRAY forState:UIControlStateNormal];
        closeVideoBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightBlack];
        [closeVideoBtn setEnabled:NO];
        self.closeVideoBtn = closeVideoBtn;
    }
    return _closeVideoBtn;
}
-(UIButton *)securityBtn{
    if (!_securityBtn) {
        UIButton *securityBtn = [[UIButton alloc] init];
        [securityBtn setImage:[UIImage imageNamed:@"security_normal"] forState:UIControlStateNormal];
        [securityBtn setImage:[UIImage imageNamed:@"security_selected"] forState:UIControlStateSelected];
        [securityBtn setTitle:@"设防" forState:UIControlStateNormal];
        [securityBtn setTitleColor:COLOR_GRAY forState:UIControlStateNormal];
        securityBtn.titleLabel.font = [UIFont systemFontOfSize:16.0f weight:UIFontWeightBlack];
        [securityBtn setEnabled:NO];
        self.securityBtn = securityBtn;
    }
    return _securityBtn;
}

-(UIView *)ptzView{
    if (!_ptzView) {
        UIView *ptzView = [[UIView alloc] init];
        self.ptzView = ptzView;
    }
    return _ptzView;
}

-(void) drawRect:(CGRect)rect{
    CGFloat X = rect.size.width/2;//圆心X坐标
    CGFloat Y = 50+rect.size.width*0.618+(rect.size.height-50-rect.size.width*0.618)/2;
    [self drawCircle:X Y:Y radius:ptzRadius];
    [self drawCircle:X Y:Y radius:ptzRadius/2];
}
-(void) drawCircle:(CGFloat) X Y:(CGFloat)Y radius:(CGFloat) radius {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context,THEMECOLOR.CGColor);//画笔线的颜色
    CGContextSetLineWidth(context, 2.0);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, X, Y, radius, 0, 2*PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
}

@end
