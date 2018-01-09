//
//  VideoEventTableViewController.m
//  AiHome
//
//  Created by wkj on 2018/1/6.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "VideoEventTableViewController.h"
#import "VideoEventModel.h"
#import "VideoEventTableViewCell.h"
#import "VideoNavView.h"
#import "PhotoCollectionView.h"

@interface VideoEventTableViewController ()
// 声明一个大数组存放所有区域 视频历史事件数据TableView数据源
@property (nonatomic, strong) NSMutableArray *allEventsArray;
//视频历史事件TimeLine样式显示TableView
@property (nonatomic, strong) UITableView *tableView;
//视频功能导航视图，包含事件查询、视频相册查看、实时监控三个功能跳转按钮
@property (nonatomic, strong) VideoNavView *videoNavView;
//视频相册视图
@property (nonatomic, strong) NSArray *photosArray;
@property (nonatomic, strong) PhotoCollectionView *photoShowView;

@end

@implementation VideoEventTableViewController
    CGFloat navBarHeight;
    CGFloat tabBarHeight;
    CGFloat statusBarHeight;
    CGFloat videoNavHeight;

// 懒加载 （重写getter方法）
- (NSMutableArray *)allEventsArray
{
    if (_allEventsArray == nil) {
        _allEventsArray = [NSMutableArray array];
        self.allEventsArray = _allEventsArray;
    }
    return _allEventsArray;
}

//- (void)loadView
//{
//    /**
//     添加TableView
//     
//     - returns: return value description
//     */
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    navBarHeight = self.navigationController.navigationBar.frame.size.height;
    tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    videoNavHeight = 80;
    //定制导航栏
    [self customNavItem];
    //添加视频导航功能视图
    [self.view addSubview:self.videoNavView];
    [[self.videoNavView.historyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.tableView.hidden = NO;
        self.photoShowView.hidden = YES;
    }];
    [[self.videoNavView.photosBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.tableView.hidden = YES;
        self.photoShowView.hidden = NO;
    }];
    //初始化视频历史事件数据并添加TabView
    [self loadVideoEventData];
    [self.view addSubview:self.tableView];
//    self.tableView.backgroundColor = COLOR_BROWN;
    //初始化视频相册数据并初始化View
    [self initPhotosData];
    [self.view addSubview:[self photoShowView:self.photosArray withColumnNum:3 withSpace:2.0]];
    self.photoShowView.hidden = YES;
}

#pragma mark - 初始化视频功能导航视图
-(VideoNavView *)videoNavView
{
    if (!_videoNavView) {
        VideoNavView *tempVideoNavView = [[VideoNavView alloc] initWithFrame:CGRectMake(0, statusBarHeight+navBarHeight, self.view.frame.size.width, videoNavHeight)];
        self.videoNavView = tempVideoNavView;
    }
    return _videoNavView;
}

#pragma mark - 初始化视频事件TimeLine的TableView
-(UITableView *)tableView
{
    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, statusBarHeight+navBarHeight+videoNavHeight, self.view.frame.size.width, self.view.frame.size.height-(statusBarHeight+navBarHeight+videoNavHeight)) style:UITableViewStyleGrouped];
        tempTableView.delegate = self;
        tempTableView.dataSource = self;
//        tempTableView.sectionFooterHeight = 10;
        //    tableView.sectionHeaderHeight = 0;
        tempTableView.separatorStyle = NO;
        tempTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tempTableView.backgroundColor = [UIColor whiteColor];
        //    tableView.rowHeight = self.rowHeight;
        //设置头部高度
        tempTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
        self.tableView = tempTableView;
    }
    return _tableView;
}

#pragma mark - 初始化视频相册视图
-(PhotoCollectionView *)photoShowView:(NSArray *)viewArray withColumnNum:(NSInteger)columnNum withSpace:(CGFloat)space {
    if(!_photoShowView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // 尾部距离屏幕尺寸（竖直模式，x没有作用）
        layout.headerReferenceSize = CGSizeMake(0, 0); //头部尺寸
        layout.footerReferenceSize = CGSizeMake(0, 0); //尾部尺寸
        // 缩进：和屏幕上下以及相对于屏幕的左右间距（上左下右）：左右会影响到竖直间距
        // 默认是10：终于可以改变了
        layout.sectionInset = UIEdgeInsetsMake(space, space, space, space);
        // 目前发现：预估尺寸等效于于itemSize
        layout.estimatedItemSize = CGSizeMake((self.view.frame.size.width - space*(columnNum+1)) / columnNum, (self.view.frame.size.width - space*(columnNum+1)) / columnNum);
        // 前提minimumInteritemSpacing为0（默认为10）
        layout.minimumInteritemSpacing = 0;
        // 行间距（竖直模式）
        layout.minimumLineSpacing = space;
        // 设置页眉和页脚是否一直存在
        layout.sectionHeadersPinToVisibleBounds= NO;
        
//        layout.itemSize = CGSizeMake((self.view.frame.size.width - space*(columnNum+1)) / columnNum, (self.view.frame.size.height - statusBarHeight -navBarHeight - tabBarHeight -videoNavHeight - space*(rowNum+1)) / rowNum);
//        layout.minimumLineSpacing = space; // 竖
//        layout.minimumInteritemSpacing = 0.0; // 横
//        layout.sectionInset = UIEdgeInsetsMake(space, space, space, space);
        
        PhotoCollectionView *nineView = [[PhotoCollectionView alloc] initWithFrame:CGRectMake(0, statusBarHeight+navBarHeight+videoNavHeight, self.view.frame.size.width, self.view.frame.size.height - statusBarHeight-navBarHeight - tabBarHeight-videoNavHeight) collectionViewLayout:layout withView:viewArray];
        self.photoShowView = nineView;
    }
    return _photoShowView;
}

#pragma mark - 加载视频事件数据集
- (void)loadVideoEventData
{
//    // 读取plist文件
//    NSMutableArray *array =[NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Regions" ofType:@"plist"]];
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@{@"eventShortTime":@"11:52",@"eventTime":[[self getCurrentTime] stringByAppendingString:@" 11:52:02"],@"eventText":@"[摄像机]检测到画面变化"}];
    [array addObject:@{@"eventShortTime":@"11:50",@"eventTime":[[self getCurrentTime] stringByAppendingString:@" 11:50:53"],@"eventText":@"[摄像机]检测到画面异常"}];
    [array addObject:@{@"eventShortTime":@"11:50",@"eventTime":[[self getCurrentTime] stringByAppendingString:@" 11:50:00"],@"eventText":@"[摄像机]检测到人脸"}];
    
    // 将要显示的数据转为model对象
    for (NSDictionary *videoEventDict in array) {
        VideoEventModel *videoEvent = [[VideoEventModel alloc] init];
        // 使用KVC赋值
        [videoEvent setValuesForKeysWithDictionary:videoEventDict];
        // 将联系人model存放在大数组中
        [self.allEventsArray addObject:videoEvent];
    }
}
-(void)initPhotosData
{
    self.photosArray = @[
     @"http://image.tianjimedia.com/uploadImages/2012/273/M6J97CZGYA4Z_NatGeo01_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/J3ME8ZNAG315_NatGeo02_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/EL9230AP5196_NatGeo03_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/SYJ43SG47PC8_NatGeo04_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/605X52620G0M_NatGeo05_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/7H5RQ1ELP8MZ_NatGeo06_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/Z2W429E0203R_NatGeo07_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/BG011W9LWL77_NatGeo08_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/936FM8NN22J2_NatGeo09_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/H79633PPEFZW_NatGeo10_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/54Z01YZ78050_NatGeo11_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/61V3658UA4IY_NatGeo12_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/H3HL7YILNGKB_NatGeo13_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/1V6797311ZA5_NatGeo14_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/93L81IKN156R_NatGeo15_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/V93E1EGU2G0Z_NatGeo16_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/QC205CD96IWZ_NatGeo17_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/M6J97CZGYA4Z_NatGeo01_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/J3ME8ZNAG315_NatGeo02_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/EL9230AP5196_NatGeo03_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/SYJ43SG47PC8_NatGeo04_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/605X52620G0M_NatGeo05_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/7H5RQ1ELP8MZ_NatGeo06_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/Z2W429E0203R_NatGeo07_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/BG011W9LWL77_NatGeo08_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/936FM8NN22J2_NatGeo09_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/H79633PPEFZW_NatGeo10_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/54Z01YZ78050_NatGeo11_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/61V3658UA4IY_NatGeo12_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/H3HL7YILNGKB_NatGeo13_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/1V6797311ZA5_NatGeo14_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/93L81IKN156R_NatGeo15_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/V93E1EGU2G0Z_NatGeo16_250.jpg",
     @"http://image.tianjimedia.com/uploadImages/2012/273/QC205CD96IWZ_NatGeo17_250.jpg"];
}
//获取当天时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:[NSDate date]];
    return dateTime;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 定制导航条内容
- (void)customNavItem {
    self.navigationItem.title = @"摄像机";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    UIButton *leftBtn = [[UIButton alloc] init];
    [leftBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"back"]] forState:UIControlStateNormal];
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
}

#pragma mark - 视频TimeLine历史事件Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allEventsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建常量标识符
    static NSString *identifier = @"videoEventCell";
    // 从重用队列里查找可重用的cell
    VideoEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 判断如果没有可以重用的cell，创建
    if (!cell) {
        cell = [[VideoEventTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    // 设置数据
    // 取出model对象
    VideoEventModel *videoEvent = self.allEventsArray[indexPath.section];
    cell.eventLabel.text = videoEvent.eventText;
    cell.eventShortTimeLabel.text = videoEvent.eventShortTime;
    cell.eventLongTimeLabel.text = videoEvent.eventTime;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}

#pragma mark 返回每一组的footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44;
}

#pragma mark 返回每一组的footer高度
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc]init];
//    footerView.backgroundColor = COLOR_RED;
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark 返回每一组的头部view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
//    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    headerView.backgroundColor = [UIColor clearColor];
    UIImageView *sectionHeaderImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera_selected"]];
    [headerView addSubview:sectionHeaderImgView];
    [sectionHeaderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left).offset(12);
        make.centerY.mas_equalTo(headerView.mas_centerY);
        make.width.equalTo(@35);
        make.height.equalTo(@35);
    }];
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:15.0f weight:UIFontWeightThin];
//    label.frame = CGRectMake(15, 0, 100, 20);
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sectionHeaderImgView.mas_right).offset(25);
        make.centerY.mas_equalTo(headerView.mas_centerY);
        make.width.equalTo(@200);
        make.height.equalTo(@40);
    }];
   VideoEventModel *videoEvent = self.allEventsArray[section];
    if(videoEvent){
        label.text = [videoEvent.eventTime substringToIndex:10];
    }
    return headerView;
}

@end
