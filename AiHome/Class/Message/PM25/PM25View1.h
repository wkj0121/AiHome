//
//  PM25ViewController.h
//  AiHome
//
//  Created by wkj on 2018/1/7.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELBezierLineChartView.h"

@interface PM25View1 : UIView

    @property (nonatomic, strong) NSString *pm25OutNum;
    @property (nonatomic, strong) NSString *pm25InNum;

    @property (nonatomic, strong) UILabel *titleLabel;
    @property (nonatomic, strong) UILabel *pm25Label;

    @property (nonatomic, strong) UILabel *pm25RoomOutLabel;
    @property (nonatomic, strong) UILabel *pm25RoomInLabel;

    @property (nonatomic, strong) ELBezierLineChartView *chartView;

@end
