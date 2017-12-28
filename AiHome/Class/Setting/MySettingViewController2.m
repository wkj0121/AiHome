//
//  MySettingViewController.m
//  AiHome
//
//  Created by wkj on 2017/12/23.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import "MySettingViewController2.h"

@interface MySettingViewController2 ()

@end

@implementation MySettingViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的设置";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    
    [self add0SectionItems];
    
    [self add1SectionItems];
    
    [self add2SectionItems];
    
    [self add3SectionItems];
    
    [self add4SectionItems];
    
}

#pragma mark 添加第0组的模型数据
- (void)add0SectionItems
{
    /**
     *  只有文字
     */
    iCocosSettingItem *title = [iCocosSettingItem itemWithImage:nil title:@"只有文字" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeNone desc:nil];
    
    /** 点击对应的行调整（其他可能只是在内部做一些事情，请自行操作） */
    title.operation = ^{
        UIViewController *view = [[UIViewController alloc] init];
        [self.navigationController pushViewController:view animated:YES];
    };
    
    /**
     *  只有文字和左边的图片
     */
    iCocosSettingItem *titleAndImage = [iCocosSettingItem itemWithImage:[UIImage imageNamed:@"brand"] title:@"只有文字和图片" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeNone desc:nil];
    titleAndImage.operation = ^{
    };
    
    //分组
    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
    group.items = @[title, titleAndImage];
    [_allGroups addObject:group];
}

/**-------------------------------------------------*/
/**----------------------------*/
/**文字和左边的图片根据是否存在设置对应的值，没有则设置nil，有责直接设置*/
/**----------------------------*/
/**-------------------------------------------------*/


#pragma mark 添加第0组的模型数据
- (void)add1SectionItems
{
    /**
     *  文字和右边剪头
     */
    iCocosSettingItem *arrow= [iCocosSettingItem itemWithImage:[UIImage imageNamed:@"brand"] title:@"文字和右边剪头" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeArrow desc:nil];
    arrow.operation = ^{
    };
    
    /**
     *  文字和右边图片）
     */
    iCocosSettingItem *image = [iCocosSettingItem itemWithImage:[UIImage imageNamed:@"brand"] title:@"文字和右边图片）" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeImage image:[UIImage imageNamed:@"02.png"]];
    image.operation = ^{
    };
    
    /**
     * 文字和右边描述
     */
    iCocosSettingItem *desc = [iCocosSettingItem itemWithImage:[UIImage imageNamed:@"brand"] title:@"文字和右边描述" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeArrow desc:@"描述文字"];
    desc.operation = ^{
    };
    
    /**
     *  文字和右边颜色占位
     */     iCocosSettingItem *placeholder = [iCocosSettingItem itemWithImage:[UIImage imageNamed:@"brand"] title:@"文字和右边颜色占位" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeArrow desc:@"颜色占位" detailLabelColor:[UIColor redColor]];
    placeholder.operation = ^{
    };
    
    //分组
    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
    group.items = @[arrow, image, desc, placeholder];
    [_allGroups addObject:group];
}



#pragma mark 添加第0组的模型数据
- (void)add2SectionItems
{
    /**
     *  Switch控件
     */
    iCocosSettingItem *documents = [iCocosSettingItem itemWithImage:[UIImage imageNamed:@"brand"] title:@"Switch控件" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeSwitch desc:nil];
    documents.operation = ^{
    };
    
    //分组
    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
    group.items = @[documents];
    [_allGroups addObject:group];
}



#pragma mark 添加第0组的模型数据
- (void)add3SectionItems
{
    /**
     *  点击可输入文字
     */
    iCocosSettingItem *documents = [iCocosSettingItem itemWithImage:nil title:@"点击可输入文字" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeTextField desc:nil];
    documents.operation = ^{
    };
    
    
    /**
     *  文本占位（可输入）
     */
    iCocosSettingItem *arrow= [iCocosSettingItem itemWithTitle:@"文本占位（可输入）" style:UITableViewCellStyleValue1 type:iCocosSettingItemTypeTextField placeHolder:@"请输入您的手机号"];
    arrow.operation = ^{
    };
    
    //分组
    iCocosSettingGroup *group = [[iCocosSettingGroup alloc] init];
    group.items = @[documents, arrow];
    [_allGroups addObject:group];
}


- (double)rowHeight
{
    return 44;
}


/**
 *  多余行数据
 */

- (void)add4SectionItems
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

