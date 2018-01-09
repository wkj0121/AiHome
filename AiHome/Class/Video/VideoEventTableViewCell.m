//
//  VideoEventTableViewCell.m
//  AiHome
//
//  Created by wkj on 2018/1/6.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoEventTableViewCell.h"

@interface VideoEventTableViewCell()

@end

@implementation VideoEventTableViewCell

    static CGFloat marginSize = 0;//缩进跨度

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化子视图
        [self initLayout];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x += marginSize;
    
    frame.size.width -= 2 * marginSize;
    
    [super setFrame:frame];
    
}

- (void)initLayout
{
    // 1.vLineImageView
    self.verticalLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, CGRectGetHeight(self.contentView.frame)*0.6)];
    self.verticalLine.backgroundColor = COLOR_RGB(57, 50, 49);
    //    self.headerImageView.backgroundColor = [UIColor orangeColor];
    // cell提供了一个contentView的属性，专门用来自定义cell,防止在cell布局的时候发生布局混乱，如果是自定义cell，记得将子控件添加到ContentView上
    [self.contentView addSubview:self.verticalLine];
    [self.verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        make.left.mas_equalTo(@30);
        make.width.equalTo(@0.8);
        make.height.mas_equalTo(self.contentView.mas_height).multipliedBy(0.5);
    }];
    
    // 2.eventShortTimeLabel
    self.eventShortTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.contentView.frame)*0.6, 30, CGRectGetHeight(self.contentView.frame)*0.4)];
    //    self.nameLabel.backgroundColor = [UIColor redColor];
    self.eventShortTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.eventShortTimeLabel.textColor = [UIColor blackColor];
    self.eventShortTimeLabel.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightThin];
    [self.contentView addSubview:self.eventShortTimeLabel];
    [self.eventShortTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.verticalLine.mas_centerX);
        make.top.mas_equalTo(self.verticalLine.mas_bottom).offset(8);
        make.width.equalTo(@50);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        //make.height.equalTo(@(self.contentView.frame.size.height-self.verticalLine.frame.size.height-10));
    }];
    
    // 3.eventView
    self.eventView = [[UIView alloc] initWithFrame:CGRectMake(30, 0, CGRectGetWidth(self.frame)-30, CGRectGetHeight(self.frame))];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:self.eventView.bounds];
    UIImage* bubbleImg = [UIImage imageNamed:@"bubble"];
    imageView.image= bubbleImg;
    [self.eventView insertSubview:imageView atIndex:0];
    [self.contentView addSubview:self.eventView];
    [self.eventView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(28);
        make.left.mas_equalTo(self.eventShortTimeLabel.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-50);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.eventView).with.insets(UIEdgeInsetsMake(3, 3, 3, 3));
    }];
    
    self.eventLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame)-30, 30)];
    //    self.nameLabel.backgroundColor = [UIColor redColor];
    self.eventLabel.textAlignment = NSTextAlignmentLeft;
    self.eventLabel.textColor = [UIColor whiteColor];
    self.eventLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.eventView addSubview:self.eventLabel];
    [self.eventLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.eventView.mas_left).offset(20);
        make.top.mas_equalTo(self.eventView.mas_top).offset(10);
        make.width.mas_equalTo(self.eventView.mas_width).offset(-5);
        make.height.equalTo(@20);
    }];
    
    self.horizontalLine=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.eventView.bounds.size.width, 1)];
    self.horizontalLine.backgroundColor = COLOR_RGB(151, 185, 184);
    [self.eventView addSubview:self.horizontalLine];
    [self.horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.eventLabel.mas_left).offset(-5);
        make.top.mas_equalTo(self.eventLabel.mas_bottom);
        make.right.mas_equalTo(self.eventView.mas_right).offset(-10);
        make.height.equalTo(@1);
    }];
    
    self.eventLongTimeLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.eventView.bounds.size.width, 30)];
    //    self.nameLabel.backgroundColor = [UIColor redColor];
    self.eventLongTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.eventLongTimeLabel.textColor = [UIColor whiteColor];
    self.eventLongTimeLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.eventView addSubview:self.eventLongTimeLabel];
    [self.eventLongTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.eventLabel.mas_left);
        make.top.mas_equalTo(self.horizontalLine.mas_bottom).offset(2);
        make.right.mas_equalTo(self.eventView.mas_right).offset(-5);
        make.height.equalTo(@20);
    }];
    
}

@end
