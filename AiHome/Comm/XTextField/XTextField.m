//
//  XTextField.m
//  AiHome
//
//  Created by wkj on 2018/1/24.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "XTextField.h"

@implementation XTextField

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    if (self.leftView) {
        return CGRectInset(bounds, 40, 0);
    }
    return CGRectInset(bounds, 10, 0);
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds{
    if (self.leftView) {
        return CGRectInset(bounds, 40, 0);
    }
    return CGRectInset(bounds, 10, 0);
}
//控制编辑文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    if (self.leftView) {
        return CGRectInset(bounds, 40, 0);
    }
    return CGRectInset(bounds, 10, 0);
}

//- (CGRect)leftViewRectForBounds:(CGRect)bounds{
//    return CGRectInset(bounds, 0, 0);
//}
//- (CGRect)rightViewRectForBounds:(CGRect)bounds{
//    return CGRectInset(bounds, -10, 0);
//}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, COLOR_RGB(239, 239, 239).CGColor);
    CGContextFillRect(context, CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1));
//    CALayer *layer = [CALayer layer];
//    layer.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
//    layer.backgroundColor = COLOR_RGB(239, 239, 239).CGColor;
//    [self.layer addSublayer:layer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
