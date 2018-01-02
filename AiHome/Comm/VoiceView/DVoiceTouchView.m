//
//  DVoiceTouchView.m
//  DVoiceSend
//
//  Created by DUCHENGWEN on 2016/10/26.
//  Copyright © 2016年 DCW. All rights reserved.
//

#import "DVoiceTouchView.h"



@interface DVoiceTouchView ()

@property (nonatomic, assign) BOOL     isBegan;
@property (nonatomic, strong) NSTimer  *timer;

@end

@implementation DVoiceTouchView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.isBegan = NO;
        self.areaY=-40;
        self.clickTime=0.5;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIButton *voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:voiceButton];
    voiceButton.titleLabel.font = [UIFont systemFontOfSize:14];
    voiceButton.userInteractionEnabled = NO;
    self.voiceButton = voiceButton;
    [voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    //        [voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
    //            //make.edges.equalTo(self);
    //            make.centerX.equalTo(self.mas_centerX);
    //            make.centerY.equalTo(self.mas_centerY);
    //        }];
}

//#############################################

- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event{
//    NSLog(@"++++++++++++++++++在范围内事件");
    if (self.voiceButton.selected) {
        return YES;
    }else{
        return  [super pointInside:point withEvent:event];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.clickTime target:self selector:@selector(timeAction) userInfo:nil repeats:NO];
//    NSLog(@"++++++++++++++++++开始");
    
    self.timer = timer;
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_voiceButton.isSelected) {
        UITouch *anchTouch = [touches anyObject];
        CGPoint point =  [anchTouch locationInView:self];
        if (point.y > self.areaY) {
            if (self.down) {
                self.down();
            }
//            NSLog(@"下滑");
        }else{
            if (self.upglide) {
                self.upglide();
            }
//            NSLog(@"上滑");
        }
//        NSLog(@"%@",NSStringFromCGPoint([anchTouch locationInView:self]));
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event{
    if (self.voiceButton.selected) {
        if (self.touchEnd) {
            self.touchEnd();
        }
    }
    self.voiceButton.selected = NO;
    [self.timer invalidate];
    self.timer = nil;
//    NSLog(@"+++++++++++++++++取消");
}

-(void)timeAction{
    if (self.touchBegan) {
        self.touchBegan();
    }
//    NSLog(@"++++++++++++执行");
    self.voiceButton.selected = YES;
    [self.timer invalidate];
//    NSLog(@"++++++++++++执行");
    
}

-(UIButton *)buttonWithImagename:(NSString *)imageName  forControlEvents:(UIControlEvents)controlEvents  title:(NSString *)title{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:button];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

@end
