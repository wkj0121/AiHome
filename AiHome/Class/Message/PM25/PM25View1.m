//
//  PM25ViewController.m
//  AiHome
//
//  Created by wkj on 2018/1/7.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "PM25View1.h"

@interface PM25View1()

@end

@implementation PM25View1

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadData];
        [self initSubViews];
    }
     return self;
}

- (void)layoutSubviews {
    // 一定要调用super的方法
    [super layoutSubviews];
    // 确定子控件的frame（这里得到的self的frame/bounds才是准确的）
    [self setupSubViewLayout];
}

- (void)initLayout
{
}

-(void)loadData
{
    _pm25OutNum = @"24";
    _pm25InNum = @"16";
}

-(void)initSubViews
{
    NSLog(@"initSubViews");
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"PM2.5参考值";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel setFont:[UIFont systemFontOfSize:14]];
    
    _pm25Label = [[UILabel alloc] init];
    _pm25Label.text = _pm25OutNum;
    _pm25Label.textAlignment = NSTextAlignmentCenter;
    [_pm25Label setFont:[UIFont systemFontOfSize:24]];
    
    [self addSubview:_titleLabel];
    [self addSubview:_pm25Label];
    
    NSArray *pointYArray = @[@(1), @(4), @(1), @(5), @(2), @(3), @(5)];
    _chartView = [[ELBezierLineChartView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100) pointsArray:pointYArray];
    _chartView.backgroundColor = COLOR_BLUE;
//    _chartView.center = self.center;
    [self addSubview:_chartView];
    
    _pm25RoomOutLabel = [[UILabel alloc] init];
    _pm25RoomOutLabel.text = [@"室外：" stringByAppendingString:_pm25OutNum];
    _pm25RoomOutLabel.textAlignment = NSTextAlignmentCenter;
    [_pm25RoomOutLabel setFont:[UIFont systemFontOfSize:14]];
    
    _pm25RoomInLabel = [[UILabel alloc] init];
    _pm25RoomInLabel.text = [@"室内：" stringByAppendingString:_pm25InNum];
    _pm25RoomInLabel.textAlignment = NSTextAlignmentCenter;
    [_pm25RoomInLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:_pm25RoomOutLabel];
    [self addSubview:_pm25RoomInLabel];
}

-(void)setupSubViewLayout
{
    NSLog(@"setupSubViewLayout");
//    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,50)];
    _titleLabel.frame = CGRectMake(0,0,50,20);
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
    
//     _pm25Label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,100)];
    _pm25Label.frame = CGRectMake(0,0,50,20);
    [_pm25Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.mas_centerX);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(20);
    }];
//    _chartView = [[ELBezierLineChartView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100) pointsArray:pointYArray];
    _chartView.frame = CGRectMake(0, 0, self.frame.size.width, 20);
    [_chartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.width.equalTo(self.mas_width);
        make.height.mas_equalTo(20);
    }];
//    _pm25RoomOutLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,50)];
    _pm25RoomOutLabel.frame = CGRectMake(0,0,50,50);
    [_pm25RoomOutLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_top).offset(-5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
//    _pm25RoomInLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,50)];
    _pm25RoomInLabel.frame = CGRectMake(0,0,50,50);
    [_pm25RoomInLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
}

@end
