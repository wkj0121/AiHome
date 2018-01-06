//
//  InteractionView.m
//  AiHome
//
//  Created by wkj on 2018/1/3.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "InteractionView.h"

@implementation InteractionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        [self awakeFromNib];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    [[NSBundle mainBundle] loadNibNamed:@"Interaction" owner:self options:nil];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self setViewsBorder];
//    [self.tipTextView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];//也可以监听contentSize属性
}

-(void)setViewsBorder{
    self.tipTextView.layer.borderWidth = 0.5f;
    self.tipTextView.layer.borderColor = [COLOR_GRAY CGColor];
    
    //    self.topContentView.layer.borderWidth = 1.0f;
    //    self.topContentView.layer.borderColor = [COLOR_GRAY CGColor];
    [self setBorderWithView:self.topContentView top:YES left:YES bottom:NO right:YES borderColor:COLOR_GRAY borderWidth:0.5f];
    
    self.contentTextView.layer.borderWidth = 0.5f;
    self.contentTextView.layer.borderColor = [COLOR_GRAY CGColor];
}

- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}

////接收处理
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    UITextView *mTrasView = object;
//
//    CGFloat topCorrect = (mTrasView.frame.size.height - mTrasView.contentSize.height);
//
//    topCorrect = (topCorrect <0.0 ?0.0 : topCorrect);
//
//    mTrasView.contentOffset = (CGPoint){.x =0, .y = -topCorrect/2};
    
//}

//- (void)contentSizeToFit:(UITextView *)textView
//{
//    //先判断一下有没有文字（没文字就没必要设置居中了）
//    if([textView.text length]>0)
//    {
//        //textView的contentSize属性
//        CGSize contentSize = textView.contentSize;
//        //textView的内边距属性
//        UIEdgeInsets offset;
//        CGSize newSize = contentSize;
//
//        //如果文字内容高度没有超过textView的高度
//        if(contentSize.height <= textView.frame.size.height)
//        {
//            //textView的高度减去文字高度除以2就是Y方向的偏移量，也就是textView的上内边距
//            CGFloat offsetY = (textView.frame.size.height - contentSize.height)/2;
//            offset = UIEdgeInsetsMake(offsetY, 0, 0, 0);
//        }
//        else          //如果文字高度超出textView的高度
//        {
//            newSize = textView.frame.size;
//            offset = UIEdgeInsetsZero;
//            CGFloat fontSize = 18;
//
//            //通过一个while循环，设置textView的文字大小，使内容不超过整个textView的高度（这个根据需要可以自己设置）
//            while (contentSize.height > textView.frame.size.height)
//            {
//                [textView setFont:[UIFont fontWithName:@"Helvetica Neue" size:fontSize--]];
//                contentSize = textView.contentSize;
//            }
//            newSize = contentSize;
//        }
//
//        //根据前面计算设置textView的ContentSize和Y方向偏移量
//        [textView setContentSize:newSize];
//        [textView setContentInset:offset];
//
//    }
//}

//事件向下传递
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    if(hitView == self){
        return nil;
    }
    return hitView;
}

@end
