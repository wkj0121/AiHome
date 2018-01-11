//
//  VideoEventTableViewController.m
//  AiHome
//
//  Created by wkj on 2018/1/6.
//  Copyright © 2018年 华通晟云. All rights reserved.
//
#import "HCWSNetSDK.h"
#import "VideoEventTableViewController.h"
#import "VideoEventModel.h"
#import "VideoEventTableViewCell.h"
#import "VideoNavView.h"
#import "PhotoCollectionView.h"
#import "CameraShowView.h"

@interface VideoEventTableViewController ()<UIGestureRecognizerDelegate>

// 声明一个大数组存放所有区域 视频历史事件数据TableView数据源
@property (nonatomic, strong) NSMutableArray *allEventsArray;
//视频历史事件TimeLine样式显示TableView
@property (nonatomic, strong) UITableView *tableView;
//视频功能导航视图，包含事件查询、视频相册查看、实时监控三个功能跳转按钮
@property (nonatomic, strong) VideoNavView *topNavView;
//视频相册视图
@property (nonatomic, strong) NSArray *photosArray;
@property (nonatomic, strong) PhotoCollectionView *photoShowView;
//实时视频监控显示视图
@property (nonatomic, strong) CameraShowView *cameraShowView;
//视频显示加载进度框
@property (nonatomic, strong) MBProgressHUD *loadVideoHUD;

@end

@implementation VideoEventTableViewController
//视图size相关参数
    static CGFloat navBarHeight;
    static CGFloat videoTabBarHeight;
    static CGFloat videoNavHeight;
//视频SDK相关参数
NSString    *ip         =   @"58.210.203.38";
int         port        =   8000;
NSString    *username  =    @"admin";
NSString    *password  =    @"ht123456";
int         channel    =    1;
OC_NET_DVR_DEVICEINFO_V30 *deviceInfo;
OC_NET_DVR_PREVIEWINFO *previewInfo;
int hikUserID = -1;
int hikRealPlayID = -1;
bool hasInitVideoSDK = false;
bool hasLockPTZ = true;//初始锁定状态

//- (void)loadView
//{
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    navBarHeight = self.navigationController.navigationBar.frame.size.height;
    videoTabBarHeight = self.tabBarController.tabBar.frame.size.height;
    videoNavHeight = 80;
    //定制导航栏
    [self customNavItem];
    //添加视频导航功能视图
    [self.view addSubview:self.topNavView];
    [[self.topNavView.historyBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.tableView.hidden = NO;
        self.photoShowView.hidden = YES;
        self.cameraShowView.hidden = YES;
        [self playVideo:NO];
    }];
    [[self.topNavView.photosBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.tableView.hidden = YES;
        self.photoShowView.hidden = NO;
        self.cameraShowView.hidden = YES;
        [self playVideo:NO];
    }];
    [[self.topNavView.videoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.tableView.hidden = YES;
        self.photoShowView.hidden = YES;
        self.cameraShowView.hidden = NO;
        _loadVideoHUD = [MBProgressHUD  showHUDAddedTo:self.cameraShowView.realPlayView animated:YES];
        _loadVideoHUD.mode = MBProgressHUDModeIndeterminate;
        _loadVideoHUD.label.textColor = COLOR_WHITE;
        _loadVideoHUD.label.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightHeavy];
        _loadVideoHUD.label.textAlignment = NSTextAlignmentCenter;
        _loadVideoHUD.label.text = @"加载视频中...";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            [self initVideoSDK];//根据hasInitVideoSDK标志初始化SDK，第一次点击实质触发，再次点击函数不做处理
            [self playVideo:YES];
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                [NSThread sleepForTimeInterval:1.2f];//延时2秒关闭加载框
                [MBProgressHUD hideHUDForView:weakSelf.cameraShowView.realPlayView animated:YES];
            });
        });
    }];
    //初始化视频历史事件数据并添加TabView
    [self loadVideoEventData];
    [self.view addSubview:self.tableView];
//    self.tableView.backgroundColor = COLOR_BROWN;
    //初始化视频相册数据并初始化View
    [self initPhotosData];
    [self.view addSubview:[self photoShowView:self.photosArray withColumnNum:3 withSpace:2.0]];
    self.photoShowView.hidden = YES;
    //添加实时监控显示视图
    [self.view addSubview:self.cameraShowView];
    self.cameraShowView.hidden = YES;
    //添加Ptz控制按钮事件
    UILongPressGestureRecognizer *leftLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(leftLongPressAction:)];
    leftLongPress.minimumPressDuration=0.8;//定义按的时间
    [self.cameraShowView.leftBtn addGestureRecognizer:leftLongPress];
    
    UILongPressGestureRecognizer *rightLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(rightLongPressAction:)];
    rightLongPress.minimumPressDuration=0.8;//定义按的时间
    [self.cameraShowView.rightBtn addGestureRecognizer:rightLongPress];
    
    UILongPressGestureRecognizer *topLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(topLongPressAction:)];
    topLongPress.minimumPressDuration=0.8;//定义按的时间
    [self.cameraShowView.topBtn addGestureRecognizer:topLongPress];
    
    UILongPressGestureRecognizer *downLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(downLongPressAction:)];
    downLongPress.minimumPressDuration=0.8;//定义按的时间
    [self.cameraShowView.bottomBtn addGestureRecognizer:downLongPress];
    
    //关闭视频和技防暂时设置长按Zoom IN.OUT事件
    UILongPressGestureRecognizer *closeVideoLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(closeVideoLongPressAction:)];
    closeVideoLongPress.minimumPressDuration=0.8;//定义按的时间
    [self.cameraShowView.closeVideoBtn addGestureRecognizer:closeVideoLongPress];

    UILongPressGestureRecognizer *securityLongPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(securityLongPressAction:)];
    securityLongPress.minimumPressDuration=0.8;//定义按的时间
    [self.cameraShowView.securityBtn addGestureRecognizer:securityLongPress];

    [[self.cameraShowView.leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if(!hasLockPTZ){self.cameraShowView.leftBtn.selected = YES;}
    }];
    [[self.cameraShowView.rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if(!hasLockPTZ){self.cameraShowView.rightBtn.selected = YES;}
    }];
    [[self.cameraShowView.topBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if(!hasLockPTZ){self.cameraShowView.topBtn.selected = YES;}
    }];
    [[self.cameraShowView.bottomBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if(!hasLockPTZ){self.cameraShowView.bottomBtn.selected = YES;}
    }];
    [[self.cameraShowView.closeVideoBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if(!hasLockPTZ){self.cameraShowView.closeVideoBtn.selected = !self.cameraShowView.closeVideoBtn.selected;}
    }];
    [[self.cameraShowView.securityBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if(!hasLockPTZ){self.cameraShowView.securityBtn.selected = !self.cameraShowView.securityBtn.selected ;}
    }];
    
    //锁云台控制按钮事件
    [[self.cameraShowView.lockBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.cameraShowView.lockBtn.selected = !self.cameraShowView.lockBtn.selected;
        hasLockPTZ = self.cameraShowView.lockBtn.selected;
        if(hasLockPTZ){
            [self.cameraShowView.leftBtn setEnabled:NO];
            [self.cameraShowView.rightBtn setEnabled:NO];
            [self.cameraShowView.topBtn setEnabled:NO];
            [self.cameraShowView.bottomBtn setEnabled:NO];
            [self.cameraShowView.closeVideoBtn setEnabled:NO];
            [self.cameraShowView.securityBtn setEnabled:NO];
        }else{
            [self.cameraShowView.leftBtn setEnabled:YES];
            [self.cameraShowView.rightBtn setEnabled:YES];
            [self.cameraShowView.topBtn setEnabled:YES];
            [self.cameraShowView.bottomBtn setEnabled:YES];
            [self.cameraShowView.closeVideoBtn setEnabled:YES];
            [self.cameraShowView.securityBtn setEnabled:YES];
        }
    }];
}

#pragma mark - 初始化视频功能导航视图
-(VideoNavView *)topNavView
{
    if (!_topNavView) {
        VideoNavView *tempVideoNavView = [[VideoNavView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+navBarHeight, self.view.frame.size.width, videoNavHeight)];
        self.topNavView = tempVideoNavView;
    }
    return _topNavView;
}

#pragma mark - 初始化视频事件TimeLine的TableView
-(UITableView *)tableView
{
    if (!_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        UITableView *tempTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+navBarHeight+videoNavHeight, self.view.frame.size.width, self.view.frame.size.height-(STATUS_BAR_HEIGHT+navBarHeight+videoNavHeight)) style:UITableViewStyleGrouped];
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
        
        PhotoCollectionView *nineView = [[PhotoCollectionView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+navBarHeight+videoNavHeight, self.view.frame.size.width, self.view.frame.size.height - STATUS_BAR_HEIGHT-navBarHeight - videoTabBarHeight-videoNavHeight) collectionViewLayout:layout withView:viewArray];
        self.photoShowView = nineView;
    }
    return _photoShowView;
}

#pragma mark - 初始化实时监控显示视图
-(CameraShowView *)cameraShowView
{
    if (!_cameraShowView) {
        CameraShowView *tempCameraShowView = [[CameraShowView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+navBarHeight+self.topNavView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-STATUS_BAR_HEIGHT-navBarHeight-videoNavHeight-videoTabBarHeight)];
        self.cameraShowView = tempCameraShowView;
    }
    return _cameraShowView;
}

#pragma mark ----------数据源相关----------
#pragma mark 懒加载 allEventsArray（重写getter方法）
- (NSMutableArray *)allEventsArray
{
    if (_allEventsArray == nil) {
        _allEventsArray = [NSMutableArray array];
        self.allEventsArray = _allEventsArray;
    }
    return _allEventsArray;
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
#pragma mark - 加载视频相册数据集
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

#pragma mark ----------视频TimeLine历史事件TableView相关代理函数实现

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

#pragma mark ----------视频监控SDK控制相关处理函数
#pragma mark 视频SDK初始化
-(void)initVideoSDK{
    //初始化视频SDK
    if(!hasInitVideoSDK){
            deviceInfo = [[OC_NET_DVR_DEVICEINFO_V30 alloc] init];
            previewInfo = [[OC_NET_DVR_PREVIEWINFO alloc] init];
            [HCWSNetSDK NET_DVR_Init];
            [HCWSNetSDK NET_DVR_SetExceptionCallBack];
            hikUserID = [HCWSNetSDK NET_DVR_Login_V30:ip wDVRPort:port sUserName:username sPassword:password OC_LPNET_DVR_DEVICEINFO_V30:deviceInfo];
//            hasInitVideoSDK = true;
    }
}

#pragma mark --- 视频预览
-(void)playVideo:(BOOL)shouldPlay{
    if(shouldPlay) {
        if(hikUserID == -1) {
            NSLog(@"无法连接摄像头");
            dispatch_async(dispatch_get_main_queue(), ^{
                _loadVideoHUD.hidden = YES;//隐藏视频加载框
                MBProgressHUD *hud = [MBProgressHUD  showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.mode = MBProgressHUDModeText;
                //背景半透明的效果
                hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
                hud.bezelView.backgroundColor = COLOR_RGB(245, 245, 245);
                hud.label.textColor = COLOR_RGB(226, 21, 20);
                hud.label.font = [UIFont systemFontOfSize:14.0f weight:UIFontWeightHeavy];
                hud.label.textAlignment = NSTextAlignmentCenter;
                hud.label.text = @"网络异常，无法连接摄像头！";
    //            hud.backgroundColor = [UIColor clearColor];
                hud.dimBackground = YES;// YES代表需要蒙版效果
    //            hud.offset = CGPointMake(0.f, MBProgressMaxOffset);// Move to bottm center.
                [hud hideAnimated:YES afterDelay:2.f];
            });
              //2.SVProgressHUD方式--------
//            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
//            [SVProgressHUD setFont:[UIFont systemFontOfSize:14.0f weight:UIFontWeightHeavy]];
//            [SVProgressHUD setForegroundColor:COLOR_RGB(226, 21, 20)];
//            [SVProgressHUD setBackgroundColor:COLOR_RGB(245, 245, 245)];
//            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
//            [SVProgressHUD showErrorWithStatus:@"网络异常，无法连接摄像头！"];
              //3.UIAlertController方式--------
//            UIAlertController *alertController = [UIAlertController
//                                                  alertControllerWithTitle:nil
//                                                  message:nil
//                                                  preferredStyle:UIAlertControllerStyleAlert];
//            // 使用富文本来改变alert的message字体大小和颜色
//            // NSMakeRange(0, 2) 代表:从0位置开始 两个字符
//            NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
//            paragraph.alignment = NSTextAlignmentCenter;
//            NSDictionary *ats = @{
//                                  NSFontAttributeName : [UIFont systemFontOfSize:14.0f weight:UIFontWeightHeavy],
//                                  NSForegroundColorAttributeName : COLOR_RGB(226, 21, 20),
//                                  NSParagraphStyleAttributeName : paragraph,
//                                  };
//            NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:@"网络异常，无法连接摄像头！" attributes:ats];
//            [alertController setValue:messageText forKey:@"attributedMessage"];
//
//            if ([self.navigationController.topViewController isMemberOfClass:[self class]]) {//判断导航控制器的栈顶控制器是否为当前控制器
//                [self presentViewController:alertController animated:YES completion:^{
//                    dispatch_time_t time=dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC);
//                    dispatch_after(time, dispatch_get_main_queue(), ^{
//                        [alertController dismissViewControllerAnimated:YES completion:nil];
//                    });
//                }];
//            };
        }else{
            if((deviceInfo.byChanNum > 0) || (deviceInfo.byIPChanNum > 0)){
                previewInfo.lChannel = channel;
                previewInfo.dwStreamType = 1;
                previewInfo.bBlocked = 1;
                previewInfo.hPlayWnd = self.cameraShowView.realPlayView;
                hikRealPlayID = [HCWSNetSDK NET_DVR_RealPlay_V40:hikUserID lpPreviewInfo:previewInfo];
            }
        }
    }else{
        [HCWSNetSDK NET_DVR_StopRealPlay:hikRealPlayID];
    }
}
#pragma mark --- 云台控制
-(void) ptzCtroll:(int)ptzCommand ptzStop:(int)ptzStop
{
    if(hikRealPlayID != -1)
    {
        [HCWSNetSDK NET_DVR_PTZControl:hikRealPlayID dwPTZCommand: ptzCommand dwStop: ptzStop dwSpeed: 4];
        //        [HCWSNetSDK NET_DVR_PTZControl:realPlayID dwPTZCommand: 23 dwStop: 1 dwSpeed: 3];
    }
}

#pragma mark --按钮长按事件
-(void)leftLongPressAction:(UILongPressGestureRecognizer*)gestureRecognizer{
    if(!hasLockPTZ){
        if([gestureRecognizer state] ==UIGestureRecognizerStateBegan){
    //        NSLog(@"长按开始");
            self.cameraShowView.leftBtn.selected = YES;
            [self ptzCtroll:23 ptzStop:0];//云台左转
        }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
    //        NSLog(@"长按结束");
            self.cameraShowView.leftBtn.selected = NO;
            [self ptzCtroll:23 ptzStop:1];
        }
    }
}

-(void)rightLongPressAction:(UILongPressGestureRecognizer*)gestureRecognizer{
    if(!hasLockPTZ){
        if([gestureRecognizer state] ==UIGestureRecognizerStateBegan){
    //        NSLog(@"长按开始");
            self.cameraShowView.rightBtn.selected = YES;
            [self ptzCtroll:24 ptzStop:0];//云台右转
        }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
    //        NSLog(@"长按结束");
            self.cameraShowView.rightBtn.selected = NO;
            [self ptzCtroll:24 ptzStop:1];
        }
    }
}

-(void)topLongPressAction:(UILongPressGestureRecognizer*)gestureRecognizer{
    if(!hasLockPTZ){
        if([gestureRecognizer state] ==UIGestureRecognizerStateBegan){
    //        NSLog(@"长按开始");
            self.cameraShowView.topBtn.selected = YES;
            [self ptzCtroll:21 ptzStop:0];//云台上仰
        }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
    //        NSLog(@"长按结束");
            self.cameraShowView.topBtn.selected = NO;
            [self ptzCtroll:21 ptzStop:1];
        }
    }
}

-(void)downLongPressAction:(UILongPressGestureRecognizer*)gestureRecognizer{
    if(!hasLockPTZ){
        if([gestureRecognizer state] ==UIGestureRecognizerStateBegan){
//            NSLog(@"长按开始");
            self.cameraShowView.bottomBtn.selected = YES;
            [self ptzCtroll:22 ptzStop:0];//云台下俯
        }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//            NSLog(@"长按结束");
            self.cameraShowView.bottomBtn.selected = NO;
            [self ptzCtroll:22 ptzStop:1];
        }
    }
}
-(void)closeVideoLongPressAction:(UILongPressGestureRecognizer*)gestureRecognizer{
    if(!hasLockPTZ){
        if([gestureRecognizer state] ==UIGestureRecognizerStateBegan){
//            NSLog(@"长按开始");
            [self ptzCtroll:11 ptzStop:0];//焦距变大(倍率变大) ZOOM_IN
        }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//            NSLog(@"长按结束");
            [self ptzCtroll:11 ptzStop:1];
        }
    }
}
-(void)securityLongPressAction:(UILongPressGestureRecognizer*)gestureRecognizer{
    if(!hasLockPTZ){
        if([gestureRecognizer state] ==UIGestureRecognizerStateBegan){
//            NSLog(@"长按开始");
            [self ptzCtroll:12 ptzStop:0];//焦距变小(倍率变小) ZOOM_OUT
        }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//            NSLog(@"长按结束");
            [self ptzCtroll:12 ptzStop:1];
        }
    }
}

- (void)viewDidDisappear{
    [HCWSNetSDK NET_DVR_StopRealPlay:hikRealPlayID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [HCWSNetSDK NET_DVR_StopRealPlay:hikRealPlayID];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [super dealloc];
    [HCWSNetSDK NET_DVR_StopRealPlay:hikRealPlayID];
    [HCWSNetSDK NET_DVR_Logout:hikUserID];
    [HCWSNetSDK NET_DVR_Cleanup];
}

@end
