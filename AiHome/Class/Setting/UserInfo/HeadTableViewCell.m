//
//  RegionTableViewCell.m
//  AiHome
//
//  Created by wkj on 2018/1/6.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeadTableViewCell.h"

@interface HeadTableViewCell()

@end

@implementation HeadTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 初始化子视图
        [self initLayout];
    }
    return self;
}

- (void)initLayout
{
    // normalLabel
    self.normalLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (CGRectGetHeight(self.contentView.frame)-40)/2, 100, 60)];
    [self.contentView addSubview:self.normalLabel];
    [self.normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(@20);
    }];
    
    // headImageView
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.headImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.width.mas_equalTo(@40);
        make.height.mas_equalTo(@40);
    }];
}

@end
