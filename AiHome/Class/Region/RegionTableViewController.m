//
//  RegionTableViewController.m
//  AiHome
//
//  Created by wkj on 2018/1/6.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "RegionTableViewController.h"
#import "Region.h"
#import "RegionTableViewCell.h"

@interface RegionTableViewController ()
// 声明一个大数组存放所有区域
@property (nonatomic, strong) NSMutableArray *allRegionsArray;
// check button array
@property (nonatomic, strong) NSMutableArray *checkBtnsArray;

@end

@implementation RegionTableViewController
// 懒加载 （重写getter方法）
- (NSMutableArray *)allRegionsArray
{
    if (_allRegionsArray == nil) {
        _allRegionsArray = [NSMutableArray array];
    }
    return _allRegionsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"区域选择";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    [self handleData];
    
}

- (void)handleData
{
//    // 读取plist文件
//    NSMutableArray *array =[NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Regions" ofType:@"plist"]];
    NSMutableArray *array = [NSMutableArray array];
//    NSDictionary *dic = @{@"regName":@"上海的家",@"msgNum":@"21",@"regCheckFlag":@NO};
    [array addObject:@{@"regName":@"上海的家",@"msgNum":@"21",@"regCheckFlag":@NO}];
    [array addObject:@{@"regName":@"南京的家",@"msgNum":@"65",@"regCheckFlag":@YES}];
    [array addObject:@{@"regName":@"杭州的家",@"msgNum":@"31",@"regCheckFlag":@NO}];
    [array addObject:@{@"regName":@"温州的家",@"msgNum":@"12",@"regCheckFlag":@NO}];
    [array addObject:@{@"regName":@"外国的家",@"msgNum":@"11",@"regCheckFlag":@NO}];
    
    // 将要显示的数据转为model对象
    for (NSDictionary *regoinDict in array) {
        Region *region = [[Region alloc] init];
        // 使用KVC赋值
        [region setValuesForKeysWithDictionary:regoinDict];
        // 将联系人model存放在大数组中
        [self.allRegionsArray addObject:region];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.allRegionsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建常量标识符
    static NSString *identifier = @"cell";
    // 从重用队列里查找可重用的cell
    RegionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 判断如果没有可以重用的cell，创建
    if (!cell) {
        cell = [[RegionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 设置数据
    // 取出model对象
    Region *region = self.allRegionsArray[indexPath.section];
    cell.regionLabel.text = region.regName;
    cell.messageBadge.text = region.msgNum;
    [cell.regionRedioBtn setSelected : region.regCheckFlag];
    [self.checkBtnsArray addObject:cell.regionRedioBtn];
    [self.checkBtnsArray[0] setGroupButtons:self.checkBtnsArray]; // Setting buttons into the group
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
