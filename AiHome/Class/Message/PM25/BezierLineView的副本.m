//
//  BezierLineView.m
//  AiHome
//
//  Created by wkj on 2018/1/8.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "BezierLineView.h"

@implementation Line

- (id)init
{
    if(self=[super init]){
        
    }
    return self;
}

@end

@implementation BezierLineView{
    CGFloat     _axisLineWidth;
    CGFloat     _axisToViewPadding;
    CGFloat     _axisPadding;
    CGFloat     _xAxisSpacing;
    CGFloat     _yAxisSpacing;
    CAShapeLayer *_bezierLineLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.lines = [[NSMutableArray alloc]init];
        self.afColor = COLOR_BLACK;
        self.bfColor = COLOR_LIGHTGRAY;
        self.points = [[NSMutableArray alloc]init];
    }
    return self;
}

/**
 *  如果View从xib中加载,就会调用initWithCoder:方法
 *  创建子控件,...
 注意: 如果子控件是从xib中创建,是处于未唤醒状态
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    NSLog(@"initWithCoder");
    if (self = [super initWithCoder:aDecoder]) {
        // Initialization code
        self.lines = [[NSMutableArray alloc]init];
        self.afColor = COLOR_BLACK;
        self.bfColor = COLOR_LIGHTGRAY;
        self.points = [[NSMutableArray alloc]init];
        self.maxXCount = 7;
        self.maxYCount = 100;
        _axisLineWidth = 1;
        _axisToViewPadding = 0;
        _axisPadding = 0;
        _xAxisSpacing = (CGRectGetWidth(self.frame) - _axisToViewPadding - _axisPadding) /((int) _maxXCount);
        _yAxisSpacing = (CGRectGetHeight(self.frame) - _axisToViewPadding) /((int) _maxYCount);
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self drawBezierPath2];
    
}

- (void)initPoint{
    //初始化一个随机y的level
    NSArray *_pointYArray = @[@(1), @(4), @(1), @(5), @(2), @(3), @(5)];
    [_pointYArray enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger objInter = 1;
        if ([obj respondsToSelector:@selector(integerValue)]) {
            objInter = [obj integerValue];
        }
        if ([obj respondsToSelector:@selector(integerValue)]) {
            objInter = [obj integerValue];
            if (objInter < 1) {
                objInter = 1;
            } else if (objInter > 5) {
                objInter = 5;
            }
        }
        CGPoint point = CGPointMake(_xAxisSpacing * idx + _axisToViewPadding, CGRectGetHeight(self.frame) - _axisToViewPadding - (objInter - 1) * _yAxisSpacing);
        NSValue *value = [NSValue valueWithCGPoint:CGPointMake(point.x, point.y)];
        [self.points addObject:value];
    }];
    NSValue *firstPointValue = [NSValue valueWithCGPoint:CGPointMake(_axisToViewPadding, (CGRectGetHeight(self.frame) - _axisToViewPadding) / 2)];
    [self.points insertObject:firstPointValue atIndex:0];
    NSValue *endPointValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetWidth(self.frame), (CGRectGetHeight(self.frame) - _axisToViewPadding) / 2)];
    [self.points addObject:endPointValue];

}
-(void)drawBezierPath{
    /** 折线路径 */
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < 6; i++) {
        CGPoint p1 = [[self.points objectAtIndex:i] CGPointValue];
        CGPoint p2 = [[self.points objectAtIndex:i+1] CGPointValue];
        CGPoint p3 = [[self.points objectAtIndex:i+2] CGPointValue];
        CGPoint p4 = [[self.points objectAtIndex:i+3] CGPointValue];
        if (i == 0) {
            [path moveToPoint:p2];
        }
        [self getControlPointx0:p1.x andy0:p1.y x1:p2.x andy1:p2.y x2:p3.x andy2:p3.y x3:p4.x andy3:p4.y path:path];
    }
    /** 将折线添加到折线图层上，并设置相关的属性 */
    _bezierLineLayer = [CAShapeLayer layer];
    _bezierLineLayer.path = path.CGPath;
    _bezierLineLayer.strokeColor = [UIColor redColor].CGColor;
    _bezierLineLayer.fillColor = [[UIColor clearColor] CGColor];
    // 默认设置路径宽度为0，使其在起始状态下不显示
    _bezierLineLayer.lineWidth = 1;
    _bezierLineLayer.lineCap = kCALineCapRound;
    _bezierLineLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:_bezierLineLayer];
}

-(void)drawBezierPath2{
//    [self initData];
    [self initPoint];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    
//    for(int i=0; i<self.lines.count; i++){
//        Line* line = [self.lines objectAtIndex:i];
//        if(i!=0 ||i!=6 || i!=7){
//            CGContextSetLineWidth(context, 1);
//        }else{
//            CGContextSetLineWidth(context, 1);
//        }
//        CGContextMoveToPoint(context, line.firstPoint.x, line.firstPoint.y);
//        CGContextAddLineToPoint(context, line.secondPoint.x, line.secondPoint.y);
//    }
    
    CGContextDrawPath(context, kCGPathStroke);
    
    if([self.points count]){
        //画线
        UIBezierPath* path = [UIBezierPath bezierPath];
        [path setLineWidth:_axisLineWidth];
//        for(int i=0; i<[[self.points objectAtIndex:0] count]-1; i++){
//            CGPoint firstPoint = [[[self.points objectAtIndex:0] objectAtIndex:i] CGPointValue];
//            CGPoint secondPoint = [[[self.points objectAtIndex:0] objectAtIndex:i+1] CGPointValue];
//            [path moveToPoint:firstPoint];
//            [path addCurveToPoint:secondPoint controlPoint1:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, firstPoint.y) controlPoint2:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, secondPoint.y)];
//            [self.bfColor set];
//        }
        for (NSInteger i = 0; i < 6; i++) {
            CGPoint p1 = [[self.points objectAtIndex:i] CGPointValue];
            CGPoint p2 = [[self.points objectAtIndex:i+1] CGPointValue];
            CGPoint p3 = [[self.points objectAtIndex:i+2] CGPointValue];
            CGPoint p4 = [[self.points objectAtIndex:i+3] CGPointValue];
            if (i == 0) {
                [path moveToPoint:p2];
            }
            [self getControlPointx0:p1.x andy0:p1.y x1:p2.x andy1:p2.y x2:p3.x andy2:p3.y x3:p4.x andy3:p4.y path:path];
            [self.bfColor set];
        }
        path.lineCapStyle = kCGLineCapRound;
        [path strokeWithBlendMode:kCGBlendModeNormal alpha:1];
        
        //        if(!self.isDrawPoint){
        //            for(int i=0; i<[[self.points objectAtIndex:0] count]; i++){
        //                CGContextRef ctx = UIGraphicsGetCurrentContext();
        //                CGPoint point = [[[self.points objectAtIndex:0] objectAtIndex:i] CGPointValue];
        //                CGContextFillEllipseInRect(ctx, CGRectMake(point.x-4, point.y-4, 8, 8));
        //                CGContextSetFillColorWithColor(ctx, self.bfColor.CGColor);
        //                CGContextFillPath(ctx);
        //            }
        //        }
        
//        UIBezierPath* path1 = [UIBezierPath bezierPath];
//        [path1 setLineWidth:2];
//        for(int i=0; i<[[self.points lastObject] count]-1; i++){
//            CGPoint firstPoint = [[[self.points lastObject] objectAtIndex:i] CGPointValue];
//            CGPoint secondPoint = [[[self.points lastObject] objectAtIndex:i+1] CGPointValue];
//            [path1 moveToPoint:firstPoint];
//            [UIView animateWithDuration:.1 animations:^(){
//                [path1 addCurveToPoint:secondPoint controlPoint1:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, firstPoint.y) controlPoint2:CGPointMake((secondPoint.x-firstPoint.x)/2+firstPoint.x, secondPoint.y)];
//            }];
//            [self.afColor set];
//
//        }
//        path1.lineCapStyle = kCGLineCapRound;
//        [path1 strokeWithBlendMode:kCGBlendModeNormal alpha:1];
        
        //        //画点
        //        if(!self.isDrawPoint){
        //            for(int i=0; i<[[self.points lastObject] count]; i++){
        //                CGContextRef ctx = UIGraphicsGetCurrentContext();
        //                CGPoint point = [[[self.points lastObject] objectAtIndex:i] CGPointValue];
        //                CGContextFillEllipseInRect(ctx, CGRectMake(point.x-4, point.y-4, 8, 8));
        //                CGContextSetFillColorWithColor(ctx, self.afColor.CGColor);
        //                CGContextFillPath(ctx);
        //            }
        //        }
    }
}

-(void) initData
{
//    int gap = 10;
//    for(int i=0; i<7; i++){
//        Line* line = [[Line alloc]init];
//            line.firstPoint = CGPointMake(1+gap*i, 0);
//            line.secondPoint = CGPointMake(1+gap*i, 205);
////            UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(25+gap*i, 0, 12, 10)];
////            [lab setText:[self reWeeksWithDay:i UseTip:tip]];
////            [lab setBackgroundColor:[UIColor clearColor]];
////            [lab setTextColor:[UIColor whiteColor]];
////            [lab setFont:[UIFont systemFontOfSize:12]];
////            [dayView addSubview:lab];
////        }else{
////            line.firstPoint = CGPointMake(0, 200);
////            line.secondPoint = CGPointMake(247, 200);
////        }
//        [self.lines addObject:line];
//    }
    NSMutableArray* bfPoints = [[NSMutableArray alloc]init];
    NSMutableArray* afPoints = [[NSMutableArray alloc]init];
    int gap = self.frame.size.width/23;
    for(int i=0; i<24; i++){
        CGPoint point1 =CGPointMake(gap*i,arc4random() % 100);
        CGPoint point2 =CGPointMake(gap*i, arc4random() % 100 + 20);
        [bfPoints addObject:[NSValue valueWithCGPoint:point1]];
        [afPoints addObject:[NSValue valueWithCGPoint:point2]];
    }
    self.points = [NSArray arrayWithObjects:bfPoints,afPoints, nil];
    
}

- (void)getControlPointx0:(CGFloat)x0 andy0:(CGFloat)y0
                       x1:(CGFloat)x1 andy1:(CGFloat)y1
                       x2:(CGFloat)x2 andy2:(CGFloat)y2
                       x3:(CGFloat)x3 andy3:(CGFloat)y3
                     path:(UIBezierPath*) path{
    CGFloat smooth_value =0.6;
    CGFloat ctrl1_x;
    CGFloat ctrl1_y;
    CGFloat ctrl2_x;
    CGFloat ctrl2_y;
    CGFloat xc1 = (x0 + x1) /2.0;
    CGFloat yc1 = (y0 + y1) /2.0;
    CGFloat xc2 = (x1 + x2) /2.0;
    CGFloat yc2 = (y1 + y2) /2.0;
    CGFloat xc3 = (x2 + x3) /2.0;
    CGFloat yc3 = (y2 + y3) /2.0;
    CGFloat len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
    CGFloat len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
    CGFloat len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
    CGFloat k1 = len1 / (len1 + len2);
    CGFloat k2 = len2 / (len2 + len3);
    CGFloat xm1 = xc1 + (xc2 - xc1) * k1;
    CGFloat ym1 = yc1 + (yc2 - yc1) * k1;
    CGFloat xm2 = xc2 + (xc3 - xc2) * k2;
    CGFloat ym2 = yc2 + (yc3 - yc2) * k2;
    ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
    ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
    ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
    ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;
    [path addCurveToPoint:CGPointMake(x2, y2) controlPoint1:CGPointMake(ctrl1_x, ctrl1_y) controlPoint2:CGPointMake(ctrl2_x, ctrl2_y)];
}

@end
