//
//  UIScrollView+UITouch.h
//  AiHome
//
//  Created by wkj on 2018/1/2.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (UITouch)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
