//
//  AiViewController.h
//  AiHome
//
//  Created by wkj on 2018/1/1.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DisrIdentifyObject.h"

@interface AiViewController : UIViewController<IFlySpeechSynthesizerDelegate>
{
    IFlySpeechSynthesizer       * _iFlySpeechSynthesizer;
}
@end
