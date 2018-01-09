//
//  VideoEventTableViewCell.h
//  AiHome
//
//  Created by wkj on 2018/1/6.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoEventTableViewCell : UITableViewCell

// Cell竖线
@property (nonatomic, strong) UIView *verticalLine;

//Cell时分Label
@property (nonatomic, strong) UILabel *eventShortTimeLabel;

//事件Lable描述
@property (nonatomic, strong) UILabel *eventLabel;

//事件时间Label
@property (nonatomic, strong) UILabel *eventLongTimeLabel;

// 事件描述区域横线
@property (nonatomic, strong) UIView *horizontalLine;

//事件描述视图
@property (nonatomic, strong) UIView *eventView;

@end
