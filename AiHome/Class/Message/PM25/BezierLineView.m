//
//  BezierLineView.m
//  AiHome
//
//  Created by wkj on 2018/1/8.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "BezierLineView.h"

@implementation BezierLineView
    

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 *  如果View从xib中加载,就会调用initWithCoder:方法
 *  创建子控件,...
 注意: 如果子控件是从xib中创建,是处于未唤醒状态
 */
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
//    NSLog(@"BezierLineView initWithCoder");
//    NSLog(@"lineview width:%@",CGRectGetWidth(self.frame));
//    NSLog(@"lineview height:%@",CGRectGetHeight(self.frame));
    if (self = [super initWithCoder:aDecoder]) {
        // Initialization code
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
}

- (void)layoutSubviews {
    // 一定要调用super的方法
    [super layoutSubviews];
    
    // 确定子控件的frame（这里得到的self的frame/bounds才是准确的）
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    self.lineChart.frame = CGRectMake(0, 0, width, height);
}

-(XLineChart *)lineChart
{
    NSMutableArray* itemArray = [[NSMutableArray alloc] init];
    NSMutableArray* numbersArray = [NSMutableArray new];
    //点的数据
    for (int j = 0; j < 2; j++) {
        NSMutableArray* numberArray = [NSMutableArray new];
        
        for (int i = 0; i < 5; i++) {
            int num = [[XRandomNumerHelper shareRandomNumberHelper]
                       randomNumberSmallThan:14] *
            [[XRandomNumerHelper shareRandomNumberHelper]
             randomNumberSmallThan:14];
            NSNumber* number = [NSNumber numberWithInt:num];
            [numberArray addObject:number];
        }
        
        [numbersArray addObject:numberArray];
    }
    NSArray* colorArray = @[
                            [UIColor tealColor], [UIColor brickRedColor], [UIColor babyBlueColor],
                            [UIColor bananaColor], [UIColor orchidColor]
                            ];
    
    for (int i = 0; i < 2; i++) {
        XLineChartItem* item =
        [[XLineChartItem alloc] initWithDataNumberArray:numbersArray[i]
                                                  color:colorArray[i]];
        [itemArray addObject:item];
    }
    
    XNormalLineChartConfiguration* configuration =
    [[XNormalLineChartConfiguration alloc] init];
    configuration.lineMode = CurveLine;
    configuration.isShowShadow = YES;
    configuration.isShowCoordinate = NO;
//    configuration.lineWidth = 1.0;
//    configuration.pointDiameter = 5.0;
//    configuration.hasOrdinateView = NO;
    
    if (!_lineChart) {
        _lineChart =
        [[XLineChart alloc] initWithFrame:CGRectMake(0, 0, 200, 80)
                            dataItemArray:itemArray
                        dataDiscribeArray:[NSMutableArray arrayWithArray:@[
                                                                           @"January", @"February", @"March", @"April", @"May"
                                                                           ]]
                                topNumber:@240
                             bottomNumber:@0
                                graphMode:MutiLineGraph
                       chartConfiguration:configuration];
//        [[XLineChart alloc] initWithFrame:CGRectMake(0, 0, 200, 80)
//                            dataItemArray:itemArray
//                        dataDiscribeArray:nil
//                                topNumber:@240
//                             bottomNumber:@0
//                                graphMode:MutiLineGraph
//                       chartConfiguration:configuration];
        [self addSubview:_lineChart];
        self.lineChart = _lineChart;
    }
//    _lineChart.backgroundColor = COLOR_LIGHTGRAY;
    return _lineChart;
}

@end
