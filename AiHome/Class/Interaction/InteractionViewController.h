//
//  InteractionViewController.h
//  AiHome
//
//  Created by wkj on 2018/1/3.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMCheckBox.h"
#import "STTextView.h"
#import "InteractionView.h"

@interface InteractionViewController : UIViewController<UITextViewDelegate>
//@interface InteractionViewController : UIViewController

//@property (strong, nonatomic) InteractionView *interactionView;

@property (strong, nonatomic)  InteractionView *interactionView;

@property (strong, nonatomic)  UIImageView *leftSwitchView;

@property (strong, nonatomic)  UIImageView *rightSwitchView;

@property (strong, nonatomic)  BEMCheckBox *leftCheckbox;

@property (strong, nonatomic)  BEMCheckBox *rightCheckbox;

@property (strong, nonatomic)  UITextView *tipTextView;

@property (strong, nonatomic)  UIView     *topContentView;
@property (strong, nonatomic)  UIButton   *photoBtn;
@property (strong, nonatomic)  UIButton   *emotionBtn;
@property (strong, nonatomic)  UIButton   *leftAlignBtn;
@property (strong, nonatomic)  UIButton   *centerAlignBtn;
@property (strong, nonatomic)  UIButton   *rightAlignBtn;

@property (strong, nonatomic)  STTextView *contentTextView;

@property (strong, nonatomic)  UIButton   *sendBtn;

@end
