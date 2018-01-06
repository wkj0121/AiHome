//
//  DVoiceView.h
//  AiHome
//
//  Created by wkj on 2017/12/31.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "YSCVoiceWaveView.h"
#import "DVoiceTouchView.h"


@interface DVoiceView : UIView

@property (nonatomic, strong) YSCVoiceWaveView *voiceWaveView;
@property (nonatomic, strong) DVoiceTouchView *voiceTouchView;//继承长按手势视图

@end
