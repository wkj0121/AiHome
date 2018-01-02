//
//  AiViewController.m
//  AiHome
//
//  Created by wkj on 2018/1/1.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "AiViewController2.h"
#import "JMCircleAnimationView.h"
#import "VoiceView.h"
#import "MBProgressHUD.h"

#import <AVFoundation/AVSpeechSynthesis.h>
#import <AVFoundation/AVAudioSession.h>

@interface AiViewController2()<UITextFieldDelegate,VoiceViewDelegate,UITableViewDelegate
,UITableViewDataSource,AVSpeechSynthesizerDelegate>{
    MBProgressHUD *hub;
    NSArray *resultArry;
    AVSpeechSynthesizer*av;
    AVSpeechUtterance *utterance;
}
    @property (nonatomic, strong) UITextView *textView;
    @property (nonatomic, strong) VoiceView *voiceView;//语音区域
    @property (nonatomic, strong) JMCircleAnimationView* circleView;//语音识别的动画
    @property (nonatomic,strong) UIButton *aiStartBtn;
    @property (nonatomic, strong)  UIButton *voiceButton;//语音按钮
//    @property (nonatomic, strong)  UIView *voiceBackView;//语音动画区域

@end

@implementation AiViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupImageViewUI];
    [self setupStartBtnUI];
    [self setupVoiceBtnUI];
    [self setupVoiceViewUI];
    //初始化语音合成
    av= [[AVSpeechSynthesizer alloc]init];
    av.delegate=self;//挂上代理
}

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
        NSLog(@" _aiStartBtn clicked :)");
        [self btnHiddenAnimation:_aiStartBtn];
        _aiStartBtn.hidden = YES;
        _voiceButton.hidden = NO;
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

-(void)setupVoiceBtnUI{
    //设置AiPhone按钮
    _voiceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,40, 40)];
    [_voiceButton setImage:[UIImage imageNamed:@"microphone"] forState:UIControlStateNormal];
    [_voiceButton setTitle:@"按住 说话" forState:UIControlStateNormal];
    _voiceButton.hidden = YES;
    [[_voiceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@" _aiPhoneBtn clicked :)");
        [self btnHiddenAnimation:_voiceButton];
        _voiceButton.hidden = YES;
        _voiceView.hidden = YES;
        _aiStartBtn.hidden = NO;
        if (self.voiceView.isRecording) {//结束语音
            [self.voiceView stop];
            
        }
    }];
    //button长按事件
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] init];
    [[longPress rac_gestureSignal] subscribeNext:^(id x) {
        NSLog(@"长按事件");
        //    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        //        NSLog(@"长按事件");
        if (self.voiceView.isRecording) {
            [self.voiceView stop];
            
        }else{
            [self.voiceView start];
            
        }
    }];
    longPress.minimumPressDuration = 0.5; //设置响应时间,定义按的时间
    [_voiceButton addGestureRecognizer:longPress];
    
    [self.view addSubview:_voiceButton];
    
    [_voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-210);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
}

//设置VoiceView区域
- (void)setupVoiceViewUI {
    //初始化VoiceView
    //    NSLog(@"高度==》%f",128*NSCREEN_HEIGHT);
    _voiceView = [[VoiceView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 128*NSCREEN_HEIGHT)];
    _voiceView.backgroundColor = COLOR(24, 49, 69, 1);
    _voiceView.delegate = self;
    _voiceView.hidden = YES;
    [self.view addSubview:_voiceView];
    [_voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_aiStartBtn.mas_top).offset(-20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(@(128*NSCREEN_HEIGHT));
    }];
    
    //初始化TextView
    _textView = [[UITextView alloc] init];
    [self.view addSubview:_textView];
    _textView.backgroundColor = [UIColor orangeColor];
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(_voiceView.mas_top).offset(-20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.equalTo(@50);
        //        make.width.equalTo(self.view.mas_width).multipliedBy(0.2);//设置高度为self.view宽度的1/3
        //        make.height.equalTo(self.view.mas_height).multipliedBy(0.2);//设置高度为self.view高度的1/3
    }];
}

#pragma mark--语音设置
- (void)speakText:(NSString*)text {
    BOOL ret = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    if (!ret) {
        NSLog(@"设置声音环境失败");
        return;
    }
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:text];//需要转换的文字
    utterance.rate=0.5;// 设置语速，范围0-1，注意0最慢，1最快；AVSpeechUtteranceMinimumSpeechRate最慢，AVSpeechUtteranceMaximumSpeechRate最快
    AVSpeechSynthesisVoice*voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-TW"];//设置发音，这是中文普通话
    utterance.voice= voice;
    [av speakUtterance:utterance];//开始
}

- (void)speakAttributeText:(NSAttributedString*) text {
    BOOL ret = [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    if (!ret) {
        NSLog(@"设置声音环境失败");
        return;
    }
    //启用audio session
    ret = [[AVAudioSession sharedInstance] setActive:YES error:nil];
    if (!ret)
    {
        NSLog(@"启动失败");
        return;
    }
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithAttributedString:text];//需要转换的文字
    utterance.rate=0.5;// 设置语速，范围0-1，注意0最慢，1最快；AVSpeechUtteranceMinimumSpeechRate最慢，AVSpeechUtteranceMaximumSpeechRate最快
    AVSpeechSynthesisVoice*voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-TW"];//设置发音，这是中文普通话
    utterance.voice= voice;
    [av speakUtterance:utterance];//开始
}

#pragma mark--懒加载
- (JMCircleAnimationView *)circleView
{
    if (!_circleView) {
        _circleView = [JMCircleAnimationView viewWithButton:self.voiceButton];
        [self.voiceButton addSubview:_circleView];
    }
    return _circleView;
}

#pragma mark --Voice delegate
- (void)onUpdateVolume:(float)volume {
    
}



- (void)queryResult:(NSArray *)arry{
//    _tableView.hidden = NO;
    resultArry = arry;
//    [_tableView reloadData];
}

- (void)onResult:(NSDictionary *)result{
//    _tableView.hidden = YES;
    if (result) {
        NSDictionary *resultDictionary = result;
        NSString *title = [resultDictionary objectForKey:@"title"];
        NSString *content = [resultDictionary objectForKey:@"content"];
        NSString *explanation = [resultDictionary objectForKey:@"explanation"];
        NSString *appreciation = [resultDictionary objectForKey:@"appreciation"];
        NSString *author = [resultDictionary objectForKey:@"author"];
        NSString *allString = [NSString stringWithFormat:@"<p align=\"center\">%@<br/>%@</p>%@%@%@",title,author,content,explanation,appreciation];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[allString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            _textView.attributedText = attributedString;
            
            NSAttributedString *contentAttribute = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            [self speakAttributeText:contentAttribute];
            
        });
    }else{
        NSLog(@"can't find poem");
    }
}



- (void)onEndOfSpeech {
    //录音结束的时候，让button按钮为空
    [_voiceButton setEnabled:NO];
    [self.circleView startAnimation];
    
}

- (void)onBeginningOfSpeech {
    
}

- (void)onCancel {
    
}

//识别失败
- (void)voiceFailure {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_voiceButton setEnabled:YES];
        [self.circleView removeFromSuperview];
        self.circleView = nil;
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"识别失败！"
                                              message:nil
                                              preferredStyle:UIAlertControllerStyleActionSheet];
        if ([self.navigationController.topViewController isMemberOfClass:[self class]]) {//判断导航控制器的栈顶控制器是否为当前控制器
            [self presentViewController:alertController animated:YES completion:^{
                dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
                dispatch_after(time, dispatch_get_main_queue(), ^{
                    [alertController dismissViewControllerAnimated:YES completion:nil];
                });
            }];
        };
        
    });
    
    
}

//识别成功
- (void)voiceSuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.circleView removeFromSuperview];
        self.circleView = nil;
        [_voiceButton setEnabled:YES];
    });
}

- (void)onError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        hub.label.text = @"网络出错，请稍后再试";
        hub.mode = MBProgressHUDModeText;
        [hub showAnimated:YES];
        [self.circleView removeFromSuperview];
        self.circleView = nil;
        [_voiceButton setEnabled:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hub hideAnimated:YES];
        });
        
    });
    if (error) {
        NSSLog(@"%@",error.localizedDescription);
    }
}

//弹出对话框，警告用户
- (void)openAlertView {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"没有数据，请重试！"
                                          message:nil
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alertController animated:YES completion:^{
        dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:nil];
        });
        
    }];
}

//按钮隐藏动画
-(void)btnHiddenAnimation:(UIButton *)btnView
{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [btnView.layer addAnimation:animation forKey:nil];
}

////按钮长按事件
//-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
//    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
//        NSLog(@"长按事件");
//        [_voiceButton setBackgroundImage:[UIImage imageNamed:@"microphone_Highlighted"] forState:UIControlStateHighlighted];
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"消息" message:@"确定删除该模式吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
//        [alert show];
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didStartSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---开始播放");
    
}

- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---完成播放");
    
}

- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didPauseSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---播放中止");
    
}

- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didContinueSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---恢复播放");
    
}

- (void)speechSynthesizer:(AVSpeechSynthesizer*)synthesizer didCancelSpeechUtterance:(AVSpeechUtterance*)utterance{
    
    NSLog(@"---播放取消");
    
}

@end
