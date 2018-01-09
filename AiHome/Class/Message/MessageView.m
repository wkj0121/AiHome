//
//  VideoMessageView.m
//  AiHome
//
//  Created by wkj on 2018/1/9.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageView.h"

@interface MessageView()

@end

@implementation MessageView

//自定义初始化方法
- (id)initWithImgName:(NSString *)imgName msgNum:(NSInteger *)msgNum
{
    self = [super init];
    if (self) {
        self.imgName = imgName;
        self.msgNum = msgNum;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        /* 添加子控件的代码*/
//        self.imageView = [[UIImageView alloc]init];
//        [self addSubview:self.imageView];
    }
    return self;
}

//- (instancetype)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName {
//    if (self = [super initWithFrame:frame]) {
//        /* 添加子控件的代码*/
//        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
//        [self addSubview:self.imageView];
//    }
//    return self;
//}

- (void)layoutSubviews {
    // 一定要调用super的方法
    [super layoutSubviews];
    
    // 确定子控件的frame（这里得到的self的frame/bounds才是准确的）
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    self.imageView.frame = CGRectMake(0, 0, width, height);
    self.msgLabelBtn.frame = CGRectMake(width-45, 5, 40, 20);
}

//-(UIImageView *)imageView{
//    if (!_imageView) {
//        UIImageView *imageview = [[UIImageView alloc]init];
//        [self addSubview:imageview];
//        self.imageView = imageview;
//    }
//    return _imageView;
//}

-(UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imgName]];
        imageview.contentMode =  UIViewContentModeCenter;
        [self addSubview:imageview];
        self.imageView = imageview;
    }
    return _imageView;
}

-(UIButton *)msgLabelBtn{
    if (!_msgLabelBtn) {
        UIButton *botton = [[UIButton alloc]init];
        botton.titleLabel.textAlignment = NSTextAlignmentCenter;
        botton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        botton.titleLabel.textColor = [UIColor whiteColor];
        botton.layer.backgroundColor =  COLOR_RGB(229, 1, 20).CGColor;
        botton.layer.cornerRadius = 10;
        botton.hidden = YES;
        [self addSubview:botton];
        self.msgLabelBtn = botton;
    }
    return _msgLabelBtn;
}

- (void)setMsgNum: (NSInteger *)msgNum
{
    _msgNum = msgNum; // 注意在这个方法中，不写这句也是没有问题的，因为在下面的语句使用的是book而非self.book或_book，但是如果在其他的方法中也想要访问book这个属性，那么就需要写上，否则self.book或_book会一直是nil（因为出了这个方法的作用域，book就销毁了，如果再想访问需要有其他的引用指向它）。所以建议，要写上这句。
    if(msgNum>0){
        [self.msgLabelBtn setTitle:[NSString stringWithFormat:@"%ld",(long)msgNum] forState:UIControlStateNormal];
        self.msgLabelBtn.hidden = NO;
    }
}

@end
