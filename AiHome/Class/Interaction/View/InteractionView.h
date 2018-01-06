//
//  InteractionView.h
//  AiHome
//
//  Created by wkj on 2018/1/3.
//  Copyright © 2018年 华通晟云. All rights reserved.
//
#import "BEMCheckBox.h"
#import "STTextView.h"

@interface InteractionView : UIView

@property (weak, nonatomic)  BEMCheckBox *leftCheckbox;

@property (weak, nonatomic)  BEMCheckBox *rightCheckbox;

@property (weak, nonatomic)  UITextView *tipTextView;

@property (weak, nonatomic)  UIView     *topContentView;
@property (weak, nonatomic)  UIButton   *photoBtn;
@property (weak, nonatomic)  UIButton   *emotionBtn;
@property (weak, nonatomic)  UIButton   *leftAlignBtn;
@property (weak, nonatomic)  UIButton   *centerAlignBtn;
@property (weak, nonatomic)  UIButton   *rightAlignBtn;

@property (weak, nonatomic)  STTextView *contentTextView;

@property (weak, nonatomic)  UIButton   *sendBtn;

@end

