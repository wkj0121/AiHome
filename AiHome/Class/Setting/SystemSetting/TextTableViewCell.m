//
//  RegionTableViewCell.m
//  AiHome
//
//  Created by wkj on 2018/1/6.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextTableViewCell.h"

@interface TextTableViewCell()

@end

@implementation TextTableViewCell

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
}

@end
