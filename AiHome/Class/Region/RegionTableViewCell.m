//
//  RegionTableViewCell.m
//  AiHome
//
//  Created by wkj on 2018/1/6.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegionTableViewCell.h"

@interface RegionTableViewCell()

@end

@implementation RegionTableViewCell

    static CGFloat marginSize = 50;//缩进跨度

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
    // 1.regionLabel
    self.regionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (CGRectGetHeight(self.contentView.frame)-40)/2, 100, 40)];
    //    self.headerImageView.backgroundColor = [UIColor orangeColor];
    // cell提供了一个contentView的属性，专门用来自定义cell,防止在cell布局的时候发生布局混乱，如果是自定义cell，记得将子控件添加到ContentView上
    [self.contentView addSubview:self.regionLabel];
    [self.regionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(@20);
    }];
    
    // 2.messageBadge
    self.messageBadge = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.regionLabel.frame) + 10, CGRectGetMinY(self.regionLabel.frame), 40, 40)];
    //    self.nameLabel.backgroundColor = [UIColor redColor];
    self.messageBadge.textAlignment = NSTextAlignmentCenter;
    self.messageBadge.textColor = [UIColor whiteColor];
    self.messageBadge.layer.backgroundColor =  COLOR_RGB(229, 1, 20).CGColor;
    self.messageBadge.layer.cornerRadius = 10;
    [self.contentView addSubview:self.messageBadge];
    [self.messageBadge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(self.regionLabel.mas_right).offset(15);
        make.width.equalTo(@40);
        make.height.equalTo(@20);
    }];
    
    // 3.regionRedioBtn
    self.regionRedioBtn = [[RadioButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame), CGRectGetMinY(self.regionLabel.frame), 30, 30)];
    [self.regionRedioBtn setImage:[UIImage imageNamed:@"radioButton-unchecked"] forState:UIControlStateNormal];
    [self.regionRedioBtn setImage:[UIImage imageNamed:@"radioButton-checked"] forState:UIControlStateSelected];
    [self.regionRedioBtn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
    //    self.phoneLabel.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.regionRedioBtn];
    [self.regionRedioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
}

-(void) onRadioButtonValueChanged:(RadioButton*)sender
{
    // Lets handle ValueChanged event only for selected button, and ignore for deselected
    if(sender.selected) {
        NSLog(@"Selected Region: %@", sender);
    }
}

@end
