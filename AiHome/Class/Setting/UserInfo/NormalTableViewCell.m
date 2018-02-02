//
//  RegionTableViewCell.m
//  AiHome
//
//  Created by wkj on 2018/1/6.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NormalTableViewCell.h"

@interface NormalTableViewCell()

@end

@implementation NormalTableViewCell

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
    self.normalLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (CGRectGetHeight(self.contentView.frame)-40)/2, 100, 40)];
    [self.contentView addSubview:self.normalLabel];
    [self.normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(@20);
    }];
    
    // headImageView
    self.normalData = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
    [self.contentView addSubview:self.normalData];
    [self.normalData mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
    }];
}

@end
