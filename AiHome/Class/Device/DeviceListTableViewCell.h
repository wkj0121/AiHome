//
//  DeviceListTableViewCell.h
//  AiHome
//
//  Created by wkj on 2018/1/13.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioButton.h"

@interface DeviceListTableViewCell : UITableViewCell

    //DeviceVersion RedioButton
    @property (nonatomic, strong) RadioButton *versionRedioBtn;
    @property (nonatomic, strong) UILabel *versionLabel;
@end
