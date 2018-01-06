//
//  RegionTableViewCell.h
//  AiHome
//
//  Created by wkj on 2018/1/6.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"

@interface RegionTableViewCell : UITableViewCell
// Region Label
@property (nonatomic, strong) UILabel *regionLabel;

// Message Badge
@property (nonatomic, strong) UILabel *messageBadge;

//region RedioButton
@property (nonatomic, strong) RadioButton *regionRedioBtn;

@end
