//
//  DeviceListTableViewCell.m
//  AiHome
//
//  Created by wkj on 2018/1/13.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "DeviceListTableViewCell.h"

@implementation DeviceListTableViewCell

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
    // 1.VersionRedioBtn
    self.versionRedioBtn = [[RadioButton alloc] initWithFrame:CGRectMake(20, 0, 30, 30)];
    [self.versionRedioBtn setImage:[UIImage imageNamed:@"radioButton-unchecked"] forState:UIControlStateNormal];
    [self.versionRedioBtn setImage:[UIImage imageNamed:@"radioButton-checked"] forState:UIControlStateSelected];
    [self.versionRedioBtn addTarget:self action:@selector(onRadioButtonValueChanged:) forControlEvents:UIControlEventValueChanged];
    //    self.phoneLabel.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:self.versionRedioBtn];
    [self.versionRedioBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(-20);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    // 2.Version Label
    self.versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    //    self.headerImageView.backgroundColor = [UIColor orangeColor];
    // cell提供了一个contentView的属性，专门用来自定义cell,防止在cell布局的时候发生布局混乱，如果是自定义cell，记得将子控件添加到ContentView上
    [self.contentView addSubview:self.versionLabel];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.versionRedioBtn.mas_right).offset(20);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
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
