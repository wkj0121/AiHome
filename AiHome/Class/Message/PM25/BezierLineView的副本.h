//
//  BezierLineView.h
//  AiHome
//
//  Created by wkj on 2018/1/8.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Line;
@interface BezierLineView : UIView

    @property(nonatomic, strong) NSMutableArray* lines;
    @property(nonatomic, strong) UIColor* afColor;
    @property(nonatomic, strong) UIColor* bfColor;
    @property(nonatomic, strong) NSMutableArray* points;
    @property(nonatomic, assign) NSInteger* maxXCount;
    @property(nonatomic, assign) NSInteger* maxYCount;

@end

@interface Line : NSObject

@property(nonatomic, assign)CGPoint firstPoint;
@property(nonatomic, assign)CGPoint secondPoint;
@property(nonatomic, strong)UIColor* color;

@end
