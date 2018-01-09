//
//  PM25View.h
//  AiHome
//
//  Created by wkj on 2018/1/7.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELBezierLineChartView.h"
#import "BezierLineView.h"

@interface PM25View : UIView

@property (nonatomic, strong) NSString *pm25OutNum;
@property (nonatomic, strong) NSString *pm25InNum;

@property (nonatomic, weak)  IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *pm25Label;

@property (nonatomic, weak) IBOutlet UILabel *pm25RoomOutLabel;
@property (nonatomic, weak) IBOutlet UILabel *pm25RoomInLabel;

@property (nonatomic, weak) IBOutlet BezierLineView *chartView;

+ (instancetype)viewFromNIB;

@end
