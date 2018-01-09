//
//  VideoMessageView.h
//  AiHome
//
//  Created by wkj on 2018/1/9.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageView : UIView

    @property (nonatomic, strong) UIImageView *imageView;
    @property (nonatomic, strong) UIButton *msgLabelBtn;
    @property (nonatomic, assign) NSInteger *msgNum;
    @property (nonatomic, strong) NSString *imgName;

- (id)initWithImgName:(NSString *)imgName msgNum:(NSInteger *)msgNum;
//- (instancetype)initWithFrame:(CGRect)frame withImageName:(NSString *)imageName;

@end
