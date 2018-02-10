//
//  SystemSettingTableViewController.m
//  AiHome
//
//  Created by macbook on 2018/2/10.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "SystemSettingTableViewController.h"
#import "TextTableViewCell.h"

@interface SystemSettingTableViewController ()

@property (nonatomic, strong) NSMutableArray *allCellsArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SystemSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self handleData];
}

- (NSMutableArray *)allCellsArray
{
    if (_allCellsArray == nil) {
        _allCellsArray = [[NSMutableArray array] init];
    }
    return _allCellsArray;
}

- (UITableView *)tableView
{
    if(_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.sectionFooterHeight = 20;
        _tableView.sectionHeaderHeight = 0;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //设置头部高度
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    }
    return _tableView;
}

- (void)loadView
{
    // 添加TableView
    self.view = self.tableView; //此处会使界面加载两次
    // 设置导航栏
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    self.navigationItem.title = @"设置";
    // 左侧返回按钮
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    self.navigationItem.leftMargin = 5;
}

- (void)handleData
{
    NSMutableArray *dataArray = [NSMutableArray array];
    [dataArray addObject:@{@"label": @"消息提醒"}];
    [dataArray addObject:@{@"label": @"勿扰模式"}];
    [dataArray addObject:@{@"label": @"系统更新"}];
    [dataArray addObject:@{@"label": @"清除数据"}];
    
    NSMutableArray *aboutArray = [NSMutableArray array];
    [aboutArray addObject:@{@"label": @"关于AiHome"}];
    [aboutArray addObject:@{@"label": @"反馈"}];
    
    NSMutableArray *exitArray = [NSMutableArray array];
    [exitArray addObject:@{@"label": @"退出"}];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:dataArray];
    [array addObject:aboutArray];
    [array addObject:exitArray];
    
    self.allCellsArray = array;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allCellsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *marray = self.allCellsArray[section];
    return marray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出type
    NSMutableArray *infos = self.allCellsArray[indexPath.section];
    NSDictionary *dic = infos[indexPath.item];
    TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normal"];
    if (!cell) {
        cell = [[TextTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"normal"];
    }
    cell.normalLabel.text = [dic objectForKey:@"label"];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2 && indexPath.item == 0){
        // 退出
        NSLog(@"-------------退出");
        // 清空页面栈
//        NSMutableArray *marr = [[NSMutableArray alloc] initWithArray:self.navigationController.viewControllers];
//        for (UIViewController *vc in marr) {
//            if ([vc isKindOfClass:[theVCYouWantToRemove class]]) {
//                [marr removeObject:vc];
//                break;
//            }
//            NSLog(@"%@",vc);
//        }
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FKLoginStateChangedNotificationKey" object:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
