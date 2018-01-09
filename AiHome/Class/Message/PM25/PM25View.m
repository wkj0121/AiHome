//
//  PM25View.m
//  AiHome
//
//  Created by wkj on 2018/1/7.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "PM25View.h"

@interface PM25View()

@end

@implementation PM25View

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        NSLog(@"PM25View initWithFrame");
    }
    return self;
}

+ (instancetype)viewFromNIB {
//    NSLog(@"PM25View viewFromNIB");
    // 加载xib中的视图，其中xib文件名和本类类名必须一致
    // 这个xib文件的File's Owner必须为空
    // 这个xib文件必须只拥有一个视图，并且该视图的class为本类
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}
- (void)awakeFromNib {
    // 视图内容布局
    //    self.backgroundColor = [UIColor yellowColor];
//    self.chartView.backgroundColor = [UIColor yellowColor];
//    _chartView = [[ELBezierLineChartView alloc] initWithFrame:CGRectMake(0, 0, 300, 130)];
}

@end
