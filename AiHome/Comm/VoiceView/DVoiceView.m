//
//  DVoiceView.m
//  AiHome
//
//  Created by wkj on 2017/12/31.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import "DVoiceView.h"
#import "YSCVolumeQueue.h"



@interface DVoiceView ()

@property (nonatomic,strong)  UIView *voiceWaveParentView;

@end


@implementation DVoiceView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height-60)];
    backgroundView.backgroundColor = COLOR(24, 49, 69, 1);
    [self insertSubview:backgroundView atIndex:0];//insertSubView index设置0为最底层
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = COLOR(255, 255, 255, 1);
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"主人,说说你想干嘛？";
    [self addSubview:label];
    [self insertSubview:self.voiceWaveParentView atIndex:1];//insertSubView index设置0为最底层
    [self.voiceWaveView showInParentView:self.voiceWaveParentView];
    [self.voiceWaveView startVoiceWave];
    //    self.voiceWaveParentView.backgroundColor = COLOR_BLUE;
    //    self.voiceWaveView.backgroundColor = COLOR_RED;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    _voiceTouchView = [[DVoiceTouchView alloc] initWithFrame:CGRectMake(0, 20, 100, 60)];
    [self addSubview:_voiceTouchView];
    self.voiceTouchView.areaY=-40;//设置滑动高度
    self.voiceTouchView.clickTime=0.5;//设置长按时间
    [_voiceTouchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@100);
        make.height.equalTo(@60);
    }];
}

//#############################################
- (YSCVoiceWaveView *)voiceWaveView
{
    if (!_voiceWaveView) {
        self.voiceWaveView = [[YSCVoiceWaveView alloc] init];
//        self.voiceWaveView.backgroundColor = COLOR_RED;
    }
    
    return _voiceWaveView;
}

- (UIView *)voiceWaveParentView
{
    if (!_voiceWaveParentView) {
        self.voiceWaveParentView = [[UIView alloc] init];
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _voiceWaveParentView.frame = CGRectMake(0, 0 , self.frame.size.width, self.frame.size.height-60);
//        _voiceWaveParentView.backgroundColor = COLOR_GRAY;
    }
    return _voiceWaveParentView;
}

//调节声音
- (void)onUpdateVolume:(float)volume {
    CGFloat normalizedValue = volume/100;
    [_voiceWaveView changeVolume:normalizedValue];
    
}

-(void)setSelectedImage:(UIImage *)selectedImage{
    [_voiceTouchView.voiceButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
}

-(void)setNormalImage:(UIImage *)normalImage{
    [_voiceTouchView.voiceButton setBackgroundImage:normalImage forState:UIControlStateNormal];
}

@end
