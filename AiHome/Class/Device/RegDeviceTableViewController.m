//
//  RegDeviceTableViewController.m
//  AiHome
//
//  Created by wkj on 2018/1/13.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "RegDeviceTableViewController.h"
#import "Device.h"
#import "RegedDevice.h"
#import "DeviceListModel.h"
#import "DeviceListTableViewCell.h"

@interface RegDeviceTableViewController ()
    // 已注册设备数组
    @property (nonatomic, strong) NSMutableArray *allRegDevicesArray;
    // 设备列表数组
    @property (nonatomic, strong) NSMutableArray *allDevicesArray;
    //已注册设备TableView
    @property (nonatomic, strong) UITableView *regedDevsTableView;
    //设备列表xuan zeTableView
    @property (nonatomic, strong) UITableView *devListTableView;
@end

@implementation RegDeviceTableViewController

#pragma mark ----------数据源相关----------
#pragma mark 懒加载 allRegDevicesArray（重写getter方法）
- (NSMutableArray *)allRegDevicesArray
{
    if (_allRegDevicesArray == nil) {
        self.allRegDevicesArray = [[NSMutableArray array]init];
    }
    return _allRegDevicesArray;
}
- (NSMutableArray *)allDevicesArray
{
    if (_allDevicesArray == nil) {
        self.allDevicesArray = [[NSMutableArray array]init];
    }
    return _allDevicesArray;
}
#pragma mark - 加载视频事件数据集
- (void)loadRegDicesData
{
    //    // 读取plist文件
    //    NSMutableArray *array =[NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Regions" ofType:@"plist"]];
    NSMutableArray *array = [NSMutableArray array];
    Device *device = [[Device alloc]init];
    device.type = @"地暖";
    device.brand = @"Vaillant";
    device.version = @"L1PB20-VUW CN 182/2-3 H TURBO";
    device.logo = @"Vaillant";
    [array addObject:@{@"type":@"空调",@"devices":@[]}];
    [array addObject:@{@"type":@"地暖",@"devices":@[device]}];
    [array addObject:@{@"type":@"新风",@"devices":@[]}];
    [array addObject:@{@"type":@"太阳能热水器",@"devices":@[]}];
    
    // 将要显示的数据转为model对象
    for (NSDictionary *regedDevicesDict in array) {
        RegedDevice *regedDevice = [[RegedDevice alloc] init];
        // 使用KVC赋值
        [regedDevice setValuesForKeysWithDictionary:regedDevicesDict];
        // 将联系人model存放在大数组中
        [self.allRegDevicesArray addObject:regedDevice];
    }
}

- (void)loadDevicesData
{
    //    // 读取plist文件
    //    NSMutableArray *array =[NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Regions" ofType:@"plist"]];
    NSMutableArray *brandArr1 = [NSMutableArray array];
    Brand *brand1 = [[Brand alloc]init];
    brand1.brandName = @"大金";
    brand1.versions = @[@"VRV200",@"VRV300",@"VRV400"];
    [brandArr1 addObject:brand1];
    Brand *brand2 = [[Brand alloc]init];
    brand2.brandName = @"日立";
    brand2.versions = @[@"XXXXXXXX",@"XXXXXX",@"XXXXXXX"];
    [brandArr1 addObject:brand2];
    Brand *brand3 = [[Brand alloc]init];
    brand3.brandName = @"东芝";
    brand3.versions = @[@"XXXXXXXX",@"XXXXXX",@"XXXXXXX"];
    [brandArr1 addObject:brand3];
    Brand *brand4 = [[Brand alloc]init];
    brand4.brandName = @"三菱";
    brand4.versions = @[@"XXXXXXXX",@"XXXXXX",@"XXXXXXX"];
    [brandArr1 addObject:brand4];
    
    NSMutableArray *brandArr2 = [NSMutableArray array];
    Brand *brand21 = [[Brand alloc]init];
    brand21.brandName = @"威能";
    brand21.versions = @[@"L1PB20-VUW CN 182/2-3 H TURBO",@"L1PB21-VUW CN 182/2-3 H TURBO",@"L1PB22-VUW CN 182/2-3 H TURBO"];
    [brandArr2 addObject:brand21];
    Brand *brand22 = [[Brand alloc]init];
    brand22.brandName = @"日立";
    brand22.versions = @[@"XXXXXXXX",@"XXXXXX",@"XXXXXXX"];
    [brandArr2 addObject:brand22];
    Brand *brand23 = [[Brand alloc]init];
    brand23.brandName = @"东芝";
    brand23.versions = @[@"XXXXXXXX",@"XXXXXX",@"XXXXXXX"];
    [brandArr2 addObject:brand23];
    Brand *brand24 = [[Brand alloc]init];
    brand24.brandName = @"三菱";
    brand24.versions = @[@"XXXXXXXX",@"XXXXXX",@"XXXXXXX"];
    [brandArr2 addObject:brand24];
    
    NSMutableArray *brandArr3 = [NSMutableArray array];
    Brand *brand31 = [[Brand alloc]init];
    brand31.brandName = @"威能";
    brand31.versions = @[@"L1PB20-VUW CN 182/2-3 H TURBO",@"L1PB21-VUW CN 182/2-3 H TURBO",@"L1PB22-VUW CN 182/2-3 H TURBO"];
    [brandArr3 addObject:brand31];
    Brand *brand32 = [[Brand alloc]init];
    brand32.brandName = @"日立";
    brand32.versions = @[@"XXXXXXXX",@"XXXXXX",@"XXXXXXX"];
    [brandArr3 addObject:brand32];
    Brand *brand33 = [[Brand alloc]init];
    brand33.brandName = @"东芝";
    brand33.versions = @[@"XXXXXXXX",@"XXXXXX",@"XXXXXXX"];
    [brandArr3 addObject:brand33];
    Brand *brand34 = [[Brand alloc]init];
    brand34.brandName = @"三菱";
    brand34.versions = @[@"XXXXXXXX",@"XXXXXX",@"XXXXXXX"];
    [brandArr3 addObject:brand34];
    
    NSMutableArray *brandArr4 = [NSMutableArray array];
    Brand *brand41 = [[Brand alloc]init];
    brand41.brandName = @"威能";
    brand41.versions = @[@"L1PB20-VUW CN 182/2-3 H TURBO",@"L1PB21-VUW CN 182/2-3 H TURBO",@"L1PB22-VUW CN 182/2-3 H TURBO"];
    [brandArr4 addObject:brand41];
    Brand *brand42 = [[Brand alloc]init];
    brand42.brandName = @"日立";
    brand42.versions = @[@"XXXXXXXX",@"XXXXXX",@"XXXXXXX"];
    [brandArr4 addObject:brand42];
    Brand *brand43 = [[Brand alloc]init];
    brand43.brandName = @"东芝";
    brand43.versions = @[@"XXXXXXXX",@"XXXXXX",@"XXXXXXX"];
    [brandArr4 addObject:brand43];
    Brand *brand44 = [[Brand alloc]init];
    brand44.brandName = @"三菱";
    brand44.versions = @[@"XXXXXXXX",@"XXXXXX",@"XXXXXXX"];
    [brandArr4 addObject:brand44];
    
    NSMutableArray *deviceListArr = [NSMutableArray array];
    DeviceListModel *deviceListModel1 = [[DeviceListModel alloc]init];
    deviceListModel1.type = @"空调";
    deviceListModel1.brands = brandArr1;
    [deviceListArr addObject:deviceListModel1];
    DeviceListModel *deviceListModel2 = [[DeviceListModel alloc]init];
    deviceListModel2.type = @"地暖";
    deviceListModel2.brands = brandArr2;
    [deviceListArr addObject:deviceListModel2];
    DeviceListModel *deviceListModel3 = [[DeviceListModel alloc]init];
    deviceListModel3.type = @"新风";
    deviceListModel3.brands = brandArr3;
    [deviceListArr addObject:deviceListModel3];
    DeviceListModel *deviceListModel4 = [[DeviceListModel alloc]init];
    deviceListModel4.type = @"太阳能热水器";
    deviceListModel4.brands = brandArr4;
    [deviceListArr addObject:deviceListModel4];
    
    // 将要显示的数据转为model对象
    for (NSDictionary *devicesDict in deviceListArr) {
        DeviceListModel *deviceListModel = [[DeviceListModel alloc] init];
        // 使用KVC赋值
        [deviceListModel setValuesForKeysWithDictionary:devicesDict];
        // 将联系人model存放在大数组中
        [self.allDevicesArray addObject:deviceListModel];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //定制导航栏
    [self customNavItem];
    //初始化数据并添加TabView
    //加载已注册设备数据
    [self loadRegDicesData];
    //加载所有设备数据
    [self loadDevicesData];
    //添加TableView
    [self.view addSubview:self.regedDevsTableView];
    [self.view addSubview:self.devListTableView];
//    self.devListTableView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 定制导航条内容
- (void)customNavItem {
    self.navigationItem.title = @"设备登记";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"back"]] forState:UIControlStateNormal];
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    self.navigationItem.leftMargin = 5;
}

#pragma mark - 初始化已注册设备的TableView
-(UITableView *)regedDevsTableView
{
    if (!_regedDevsTableView) {
        UITableView *tempTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        tempTableView.delegate = self;
        tempTableView.dataSource = self;
//        tempTableView.sectionFooterHeight = 10;
//        tableView.sectionHeaderHeight = 0;
//        tempTableView.separatorStyle = NO;
        tempTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tempTableView.backgroundColor = [UIColor whiteColor];
//        //设置头部高度
//        tempTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        self.regedDevsTableView = tempTableView;
    }
    return _regedDevsTableView;
}

#pragma mark - 初始化设备列表的TableView
-(UITableView *)devListTableView
{
    if (!_devListTableView) {
        UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH* 0.3, 0, SCREEN_WIDTH*0.7, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        tempTableView.delegate = self;
        tempTableView.dataSource = self;
        //        tempTableView.sectionFooterHeight = 10;
        //    tableView.sectionHeaderHeight = 0;
        tempTableView.separatorStyle = NO;
        tempTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tempTableView.backgroundColor = [UIColor whiteColor];
        //    tableView.rowHeight = self.rowHeight;
//        //设置头部高度
//        tempTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        self.devListTableView = tempTableView;
    }
    return _devListTableView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSUInteger num = 1;
    if (tableView == self.regedDevsTableView){// 左边表格
        num = self.allRegDevicesArray.count;
    }else if (tableView == self.devListTableView) {// 右边表格
        DeviceListModel *deviceList = self.allDevicesArray[0];
        num = deviceList.brands.count;//品牌分组
    }
    return num;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger num = 1;
    if (tableView == self.regedDevsTableView){// 左边表格
        RegedDevice *regDevice = self.allRegDevicesArray[section];
        num = regDevice.devices.count;
    }else if (tableView == self.devListTableView) {// 右边表格
        DeviceListModel *deviceList = [self.allDevicesArray objectAtIndex:(self.regedDevsTableView.indexPathForSelectedRow.row)];
        Brand *brand = deviceList.brands[section];
        num = brand.versions.count;
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建常量标识符
    static NSString *identifierLeft = @"RegDeviceCell";
    static NSString *identifierRight = @"DeviceListCell";
    if (tableView == self.regedDevsTableView){// 左边表格
        // 从重用队列里查找可重用的cell
       UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierLeft];
        // 判断如果没有可以重用的cell，创建
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierLeft];
        }
        // 设置数据
        RegedDevice *regDevice = self.allRegDevicesArray[indexPath.section];
        Device *device = regDevice.devices[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:device.logo];
        cell.textLabel.text = device.version;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
    }
    
//    else if (tableView == self.devListTableView) {// 右边表格
        // 从重用队列里查找可重用的cell
        DeviceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRight];
        // 判断如果没有可以重用的cell，创建
        if (!cell) {
            cell = [[DeviceListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierRight];
        }
        // 设置数据
        DeviceListModel *deviceList = self.allDevicesArray[indexPath.section];
        Brand *brand = deviceList.brands[indexPath.section];
        cell.versionLabel.text = brand.versions[indexPath.row];
//        [self.checkBtnsArray addObject:cell.regionRedioBtn];
//        [self.checkBtnsArray[0] setGroupButtons:self.checkBtnsArray]; //
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return  cell;
//    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 55;
}

#pragma mark 返回每一组的头部view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = COLOR_RGB(237, 238, 238);
    //设置 title 区域
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, tableView.contentSize.width, 20)];
    //设置 title 文字内容
    RegedDevice *regDevice = self.allRegDevicesArray[section];
    titleLabel.text =  regDevice.type;
    titleLabel.font = [UIFont systemFontOfSize:18.0f];
    //设置 title 颜色
    titleLabel.textColor =  COLOR_BLACK;
    //设置添加按钮
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"add"]] forState:UIControlStateNormal];
    [[addBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"点击了设备添加按钮！");
    }];
    [view addSubview:titleLabel];
    [view addSubview:addBtn];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_left).offset(20);
        make.centerY.mas_equalTo(view.mas_centerY);
    }];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(view.mas_right).offset(-20);
        make.centerY.mas_equalTo(view.mas_centerY);
        make.width.mas_equalTo(view.mas_height).multipliedBy(0.5);
        make.height.mas_equalTo(view.mas_height).multipliedBy(0.5);
    }];
    return view;
}

//#pragma mark 返回每一组的footer高度
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 44;
//}
//
//#pragma mark 返回每一组的footer高度
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *footerView = [[UIView alloc]init];
//    //    footerView.backgroundColor = COLOR_RED;
//    return footerView;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
