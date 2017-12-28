//
//  MsgViewController.h
//  AiHome
//
//  Created by wkj on 2017/12/24.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LCGridView.h"

@interface MsgViewController2 : UIViewController<LCGridViewDelegate>

{
    LCGridView *_scroll;
}
@property (nonatomic, retain) LCGridView *scroll;

@end

