//
//  AiViewController.m
//  AiHome
//
//  Created by wkj on 2018/1/2.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "AiViewController.h"
#import "DVoiceView.h"
#import "JMCircleAnimationView.h"

@interface AiViewController ()<isrIdentifyDelegate>

@property (nonatomic,strong) UILabel *voiceSendLabel;
@property (nonatomic, strong) UIImageView     *voiceIconImage;
@property (nonatomic, strong) UILabel         *voiceIocnTitleLable;
@property (nonatomic, strong) UIView          *voiceImageSuperView;
@property (nonatomic, assign) BOOL            voiceIsCancel;
@property (nonatomic, assign) BOOL            voiceRecognitionIsEnd;
@property (nonatomic, assign) BOOL            touchIsEnd;

@property (nonatomic, strong) UIImage         *normalImage;
@property (nonatomic, strong) UIImage         *selectedImage;
@property (nonatomic, copy)   NSString        *voiceString;

@property (nonatomic, strong) DVoiceView *voiceView;//语音视图
@property (nonatomic, strong) JMCircleAnimationView* circleView;//语音识别的动画
@property (nonatomic,strong) UIButton *aiStartBtn;

@end

@implementation AiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor  whiteColor];
    [[DisrIdentifyObject sharedInstance] initRecognizer];
    [DisrIdentifyObject sharedInstance].delegate = self;
    // 创建合成对象，为单例模式
    _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    _iFlySpeechSynthesizer.delegate = self;
    [self configSpeechSynthesizer];
    //faviconView->voiceTouchView->voiceTouchView.voiceButton->startButton->voiceView->VoiceSendLabel
    [self setupImageViewUI];
    [self setupVoiceTouchViewUI];
    [self setupStartBtnUI];
    [self setupVoiceSendLabel];
}

#pragma mark - 设置语音合成的参数
-(void)configSpeechSynthesizer{
    //语速,取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50" forKey:[IFlySpeechConstant SPEED]];
    //音量;取值范围 0~100
    [_iFlySpeechSynthesizer setParameter:@"50" forKey: [IFlySpeechConstant VOLUME]];
    //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表
    [_iFlySpeechSynthesizer setParameter:@" xiaoyan " forKey: [IFlySpeechConstant VOICE_NAME]];
    //音频采样率,目前支持的采样率有 16000 和 8000
    [_iFlySpeechSynthesizer setParameter:@"8000" forKey: [IFlySpeechConstant SAMPLE_RATE]];
    //asr_audio_path保存录音文件路径，如不再需要，设置value为nil表示取消，默认目录是documents
    [_iFlySpeechSynthesizer setParameter:@" tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
}
#pragma mark - 合成结束，此代理必须要实现
- (void) onCompleted:(IFlySpeechError *) error{}
#pragma mark - 合成开始
- (void) onSpeakBegin{}
#pragma mark - 合成缓冲进度
- (void) onBufferProgress:(int) progress message:(NSString *)msg{}
#pragma mark - 合成播放进度
- (void) onSpeakProgress:(int) progress{}

//设置VoiceTouchView
-(void)setupVoiceTouchViewUI{
    _voiceView = [[DVoiceView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 168*NSCREEN_HEIGHT)];
//    _voiceTouchView.backgroundColor = COLOR_BLUE;
    [self.view addSubview:_voiceView];
    _voiceView.hidden = YES;
    [_voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-210);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@(168*NSCREEN_HEIGHT));
    }];
    //设置voiceButton
    [self setNormalImage:[UIImage imageNamed:@"microphone_Highlighted"]];
//    [_voiceTouchView.voiceButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [_voiceView.voiceTouchView.voiceButton setTitleColor:COLOR_RGB(105, 105, 105) forState:UIControlStateNormal];
    [[_voiceView.voiceTouchView.voiceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@" voiceButton clicked :)");
        [self btnHiddenAnimation:_voiceView.voiceTouchView.voiceButton];
        _voiceView.hidden = YES;
        _aiStartBtn.hidden = NO;
    }];
    __block AiViewController *weakSelf = self;
    _voiceView.voiceTouchView.touchBegan = ^(){
        //开始长按
        [weakSelf touchDidBegan];
    };
    _voiceView.voiceTouchView.upglide = ^(){
        //在区域内
        [weakSelf touchupglide];
    };
    _voiceView.voiceTouchView.down = ^(){
        //不在区域内
        [weakSelf touchDown];
    };
    _voiceView.voiceTouchView.touchEnd = ^(){
        //松开
        [weakSelf touchDidEnd];
    };
}
//设置favicon ImageView
-(void)setupImageViewUI{
    //设置中部主图片视图
    UIImageView *imgView = [[UIImageView alloc] init];
    //    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,100, 100)];
    imgView.backgroundColor = [UIColor whiteColor];
    // 设置图片
    imgView.image = [UIImage imageNamed:@"seekcoAi"];
    //  不规则图片显示
    imgView.contentMode =  UIViewContentModeScaleAspectFill;
    imgView.autoresizesSubviews = YES;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //  图片大于或小于显示区域
    imgView.clipsToBounds  = NO;
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@80);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.2);//设置高度为self.view宽度的1/3
        make.height.equalTo(self.view.mas_height).multipliedBy(0.2);//设置高度为self.view高度的1/3
    }];
}

-(void)setupStartBtnUI{
    //设置开启按钮
    _aiStartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_aiStartBtn setBackgroundColor:THEMECOLOR];
    [_aiStartBtn setTitle:@"开启" forState:UIControlStateNormal];
    [_aiStartBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _aiStartBtn.titleLabel.font = [UIFont systemFontOfSize:23.0];
    //设置圆角
    _aiStartBtn.layer.cornerRadius = 12.0;//2.0是圆角的弧度，根据需求自己更改
    _aiStartBtn.layer.borderColor = THEMECOLOR.CGColor;//设置边框颜色
    _aiStartBtn.layer.borderWidth = 1.0f;//设置边框颜色
    //    [_aiStartBtn addTarget:self action:@selector(startAiPhone:) forControlEvents:UIControlEventTouchUpInside];
    [[_aiStartBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        NSLog(@" _aiStartBtn clicked :)");
        [self btnHiddenAnimation:_aiStartBtn];
        _aiStartBtn.hidden = YES;
        _voiceView.hidden = NO;
    }];
    
    [self.view addSubview:_aiStartBtn];
    
    [_aiStartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-210);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@140);
        make.height.equalTo(@40);
    }];
}

//设置语言转文字Label
-(void)setupVoiceSendLabel{
    _voiceSendLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [self.view addSubview:_voiceSendLabel];
    [_voiceSendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.voiceView.mas_top).offset(-20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
    }];
}

#pragma mark--懒加载 set circleView
- (JMCircleAnimationView *)circleView
{
    if (!_circleView) {
        _circleView = [JMCircleAnimationView viewWithButton:_voiceView.voiceTouchView.voiceButton];
        [_voiceView.voiceTouchView.voiceButton addSubview:_circleView];
    }
    return _circleView;
}

//按钮隐藏动画
-(void)btnHiddenAnimation:(UIButton *)btnView
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [btnView.layer addAnimation:animation forKey:nil];
}
//开始长按
-(void)touchDidBegan{
    if (!self.voiceIconImage) {
        UIView *voiceImageSuperView = [[UIView alloc] init];
        [self.view addSubview:voiceImageSuperView];
        voiceImageSuperView.backgroundColor = COLOR_RGBA(0, 0, 0, 0.6);
        self.voiceImageSuperView = voiceImageSuperView;
        [voiceImageSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(140, 140));
        }];
        
        
        UIImageView *voiceIconImage = [[UIImageView alloc] init];
        self.voiceIconImage = voiceIconImage;
        [voiceImageSuperView addSubview:voiceIconImage];
        [voiceIconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(voiceImageSuperView).insets(UIEdgeInsetsMake(20, 35, 0, 0));
            make.size.mas_equalTo(CGSizeMake(70, 70));
        }];
        
        UILabel *voiceIocnTitleLable = [[UILabel alloc] init];
        self.voiceIocnTitleLable = voiceIocnTitleLable;
        [voiceIconImage addSubview:voiceIocnTitleLable];
        voiceIocnTitleLable.textColor = [UIColor whiteColor];
        voiceIocnTitleLable.font = [UIFont systemFontOfSize:12];
        voiceIocnTitleLable.text = @"松开发送，上滑取消";
        [voiceIocnTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(voiceImageSuperView).offset(-15);
            make.centerX.equalTo(voiceImageSuperView);
        }];
    }
    self.voiceImageSuperView.hidden = NO;
    self.voiceIconImage.image = [UIImage imageNamed:@"语音 1"];
    self.voiceIocnTitleLable.text = @"松开发送，上滑取消";
    self.voiceIsCancel = NO;
    self.voiceString = [[NSString alloc] init];
    self.voiceRecognitionIsEnd = NO;
    self.touchIsEnd = NO;
//    [_voiceView.voiceTouchView.voiceButton setTitle:@"松开发送" forState:UIControlStateNormal];
    [[DisrIdentifyObject sharedInstance] detectionStart];
    [[DisrIdentifyObject sharedInstance] startBtnHandler];
    [self.circleView startAnimation];
}

//在区域内
-(void)touchupglide{
    self.voiceIsCancel = YES;
    self.voiceIocnTitleLable.text = @"松开手指，取消发送";
    self.voiceIconImage.image = [UIImage imageNamed:@"松开"];
}
//不在区域内
-(void)touchDown{
    self.voiceIsCancel = NO;
    self.voiceIconImage.image = [UIImage imageNamed:@"语音 1"];
    self.voiceIocnTitleLable.text = @"松开发送，上滑取消";
}
//松开
-(void)touchDidEnd{
//    NSLog(@"松开");
    self.voiceImageSuperView.hidden = YES;
    [_voiceView.voiceWaveView changeVolume:-1];//音量设置-1，清空音量队列初始化
    if (self.voiceIsCancel==YES) {
        [[DisrIdentifyObject sharedInstance] detectionStart];
    }else{
        [[DisrIdentifyObject sharedInstance] stopListening];
    }
    self.touchIsEnd = YES;
//    [_voiceView.voiceTouchView.voiceButton setTitle:@"按住说话" forState:UIControlStateNormal];
    [self.circleView removeFromSuperview];
    self.circleView = nil;
}

//语音回调
- (void) onResultsStringisrIdentifyDelegate:(NSString*) results isLast:(BOOL)isLast{
    self.voiceRecognitionIsEnd = isLast;
    [self.circleView removeFromSuperview];
    self.circleView = nil;
    if ([results length] > 0) {
        self.voiceString =  [self.voiceString stringByAppendingString:results];
    }
    if (isLast && self.touchIsEnd) {
        if (!self.voiceIsCancel && [self.voiceString length] > 0) {
            _voiceSendLabel.text=self.voiceString;
            [NSThread sleepForTimeInterval:1.0f];
            //启动合成会话
            [_iFlySpeechSynthesizer startSpeaking: @"好的主人，小Ai正在帮您处理"];
        }
    }
}
//音量变化事件 更改音量图片
- (void) onVolumeChangedImgisrIdentifyDelegate: (UIImage*)Img{
    if (!self.voiceIsCancel) {
        self.voiceIconImage.image = Img;
    }
    
}
//音量变化事件 调节波纹音量
-(void) onVolumeChangedVolumeisrIdentifyDelegate:(int)volume{
    if(!self.voiceIsCancel){
//        NSLog(@"音量==》%i",volume);
//        CGFloat normalizedValue =  (CGFloat)volume/100;
        CGFloat normalizedValue =  (CGFloat)volume/30;//30是最大值
//        NSLog(@"normalizedValue==》%f",normalizedValue);
        [_voiceView.voiceWaveView changeVolume:normalizedValue];
    }else{
        [_voiceView.voiceWaveView changeVolume:-1];
    }
}
//错误信息
- (void) onErrorStringisrIdentifyDelegate:(IFlySpeechError *)error{
//    NSLog(@"errorCode:%i,errorType:%i,errorDesc:%@",error.errorCode,error.errorType,error.errorDesc);
    if(error.errorCode!=0){//发生错误
        _voiceSendLabel.text=error.errorDesc;
        //    _voiceSendLabel.text=self.voiceString;
    }
}

-(void)setSelectedImage:(UIImage *)selectedImage{
    [_voiceView.voiceTouchView.voiceButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
}

-(void)setNormalImage:(UIImage *)normalImage{
    [_voiceView.voiceTouchView.voiceButton setBackgroundImage:normalImage forState:UIControlStateNormal];
}

@end
