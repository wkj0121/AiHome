//
//  MySettingViewController.m
//  AiHome
//
//  Created by wkj on 2017/12/23.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import "MySettingViewController.h"

@interface MySettingViewController ()

@end

@implementation MySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的设置";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    
    [self add0SectionItems];//个人信息组
    
    [self add1SectionItems];//快捷操作组
    
    [self add2SectionItems];//家庭及成员设置组
    
    [self add3SectionItems];//积分商城组
    
    [self add4SectionItems];//服务组
    
    [self add5SectionItems];//系统设置组
    
}

- (void)viewWillAppear:(BOOL)animated {
    UITableView *tableView = (UITableView *)self.view;
    if(tableView.numberOfSections <= 0)
        return;
    UserInfoManager *userInfo = [UserInfoManager shareUser];
    UIImage *headImage = [UIImage imageWithData:userInfo.headImageData];
    iCocosSettingItem *headItem = [iCocosSettingItem itemWithImage:headImage title:([userInfo.nickName isEqualToString:@""] ? userInfo.userName : userInfo.nickName) style:UITableViewCellStyleSubtitle type:iCocosSettingItemTypeImageWithArrow image:[UIImage imageNamed:@"QRCode"] desc:[NSString stringWithFormat:@"手机号:%@",userInfo.telNum] detailLabelColor:[UIColor grayColor]];
    headItem.operation = ^{
        [[UIApplication sharedApplication]  openURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@", NavPushRouteURL,@"UserInfoTableViewController"]] options:nil completionHandler:nil];
    };
    //分组
    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
    group.items = @[headItem];
    [_allGroups replaceObjectAtIndex:0 withObject:group];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark 添加第0组的模型数据
- (void)add0SectionItems
{
    /**
     *  个人信息
     */
    UserInfoManager *userInfo = [UserInfoManager shareUser];
    UIImage *headImage = [UIImage imageWithData:userInfo.headImageData];
    iCocosSettingItem *headItem = [iCocosSettingItem itemWithImage:headImage title:([userInfo.nickName isEqualToString:@""] ? userInfo.userName : userInfo.nickName) style:UITableViewCellStyleSubtitle type:iCocosSettingItemTypeImageWithArrow image:[UIImage imageNamed:@"QRCode"] desc:[NSString stringWithFormat:@"手机号:%@",userInfo.telNum] detailLabelColor:[UIColor grayColor]];
    headItem.operation = ^{
        [[UIApplication sharedApplication]  openURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@", NavPushRouteURL,@"UserInfoTableViewController"]] options:nil completionHandler:nil];
    };
    //分组
    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
    group.items = @[headItem];
    [_allGroups addObject:group];
}

#pragma mark 添加第1组的模型数据
- (void)add1SectionItems
{
    /**
     *  设备品牌
     */
    iCocosSettingItem *deviceBandItem = [iCocosSettingItem itemWithImage:[UIImage imageNamed:@"brand"] title:@"设备登记" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeArrow desc:@"设置后便与维修和保养" detailLabelColor:[UIColor grayColor]];
    
    /** 点击对应的行调整（其他可能只是在内部做一些事情，请自行操作） */
    deviceBandItem.operation = ^{
//        [[UIApplication sharedApplication]  openURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@", NavPushRouteURL,@"RegDeviceTableViewController"]] options:nil completionHandler:nil];
        NSString *urlString = [WEBSettings_DeviceRegisterURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *url = [NSString stringWithFormat:@"%@%@?urlString=%@", NavPushRouteURL,@"WebViewController",urlString];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:nil completionHandler:nil];
    };
    
    /**
     *  一键关闭
     */
    iCocosSettingItem *oneCloseItem = [iCocosSettingItem itemWithImage:[UIImage imageNamed:@"oneclose"] title:@"一键关闭" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeSwitch desc:nil];
    oneCloseItem.operation = ^{
    };
    
    /**
     *  离家设置
     */
    iCocosSettingItem *outDoorItem = [iCocosSettingItem itemWithImage:[UIImage imageNamed:@"outdoor"] title:@"离家设置" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeSwitch desc:nil];
    outDoorItem.operation = ^{
    };
    
    /**
     *  睡眠设置
     */
    iCocosSettingItem *sleepModeItem = [iCocosSettingItem itemWithImage:[UIImage imageNamed:@"sleepmode"] title:@"睡眠设置" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeSwitch desc:nil];
    sleepModeItem.operation = ^{
    };
    
    //分组
    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
    group.items = @[deviceBandItem, oneCloseItem, outDoorItem, sleepModeItem];
    [_allGroups addObject:group];
}

/**-------------------------------------------------*/
/**----------------------------*/
/**文字和左边的图片根据是否存在设置对应的值，没有则设置nil，有责直接设置*/
/**----------------------------*/
/**-------------------------------------------------*/


#pragma mark 添加第2组的模型数据
- (void)add2SectionItems
{
    /**
     *  住宅登记
     */
    iCocosSettingItem *locationItem= [iCocosSettingItem itemWithImage:[UIImage imageNamed:@"location"] title:@"住宅登记" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeArrow desc:nil];
    locationItem.operation = ^{
        NSString *urlString = [WEBSettings_HouseRegisterURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *url = [NSString stringWithFormat:@"%@%@?urlString=%@", NavPushRouteURL,@"WebViewController",urlString];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:nil completionHandler:nil];
    };
    
    /**
     *  成员管理
     */
    iCocosSettingItem *memberItem= [iCocosSettingItem itemWithImage:[UIImage imageNamed:@"member"] title:@"成员管理" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeArrow desc:nil];
    memberItem.operation = ^{
    };
    
    //分组
    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
    group.items = @[locationItem, memberItem];
    [_allGroups addObject:group];
}



#pragma mark 添加第3组的模型数据
- (void)add3SectionItems
{
    /**
     *  绿色积分
     */
    iCocosSettingItem *csmpointItem= [iCocosSettingItem itemWithImage:[UIImage imageNamed:@"csmpoint"] title:@"绿色积分" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeArrow desc:nil];
    csmpointItem.operation = ^{
    };
    
    /**
     *  我的购买
     */
    iCocosSettingItem *mallItem= [iCocosSettingItem itemWithImage:[UIImage imageNamed:@"mall"] title:@"我的购买" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeArrow desc:nil];
    mallItem.operation = ^{
    };
    
    //分组
    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
    group.items = @[csmpointItem, mallItem];
    [_allGroups addObject:group];
}

#pragma mark 添加第4组的模型数据
- (void)add4SectionItems
{
    /**
     *  设置
     */
    iCocosSettingItem *serviceItem = [iCocosSettingItem itemWithImage:[UIImage imageNamed:@"service"] title:@"服务" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeArrow desc:nil];
    serviceItem.operation = ^{

    };
    
    //分组
    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
    group.items = @[serviceItem];
    [_allGroups addObject:group];
}

#pragma mark 添加第5组的模型数据
- (void)add5SectionItems
{
    /**
     *  设置
     */
    iCocosSettingItem *settingItem = [iCocosSettingItem itemWithImage:[UIImage imageNamed:@"setting"] title:@"设置" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeArrow desc:nil];
    settingItem.operation = ^{
        [[UIApplication sharedApplication]  openURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@", NavPushRouteURL,@"SystemSettingTableViewController"]] options:nil completionHandler:nil];
    };
    
    //分组
    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
    group.items = @[settingItem];
    [_allGroups addObject:group];
}


- (double)rowHeight
{
    return TabViewRowHeight;
}

- (BOOL)hasCustomHead
{
    return YES;
}


/**
 *  多余行数据
 */

- (void)add6SectionItems
{
    
    /**
     *  我的订单
     */
    
    iCocosSettingItem *dd0 = [iCocosSettingItem itemWithImage:nil title:nil style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeTextField desc:nil];
    iCocosSettingItem *dd1 = [iCocosSettingItem itemWithImage:nil title:nil style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeTextField desc:nil];
    iCocosSettingItem *dd2 = [iCocosSettingItem itemWithImage:nil title:nil style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeTextField desc:nil];
    iCocosSettingItem *dd3 = [iCocosSettingItem itemWithImage:nil title:nil style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeTextField desc:nil];
    iCocosSettingItem *dd4 = [iCocosSettingItem itemWithImage:nil title:nil style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeTextField desc:nil];
    iCocosSettingItem *dd5 = [iCocosSettingItem itemWithImage:nil title:nil style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeTextField desc:nil];
    iCocosSettingItem *dd6 = [iCocosSettingItem itemWithImage:nil title:nil style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeTextField desc:nil];

    
    //分组
    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
    group.items = @[dd0, dd1, dd2, dd3, dd4, dd5, dd6];
    [_allGroups addObject:group];
}


@end
