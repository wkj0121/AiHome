//
//  HomeViewController.m
//  AiHome
//
//  Created by wkj on 2017/12/22.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self customNavItem];
    [self setupMainView];
}
#pragma mark - 定制主页内容
-(void)setupMainView{
    //设置顶部三个水平排列按钮
    NSMutableArray *array = [NSMutableArray new];
    UIButton *lockBtn = [[UIButton alloc] init];
    [lockBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"lock"]] forState:UIControlStateNormal];
    UIButton *cameraBtn = [[UIButton alloc] init];
    [cameraBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"camera"]] forState:UIControlStateNormal];
    UIButton *gasBtn = [[UIButton alloc] init];
    [gasBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"gas"]] forState:UIControlStateNormal];
    [self.view addSubview:lockBtn];
    [self.view addSubview:cameraBtn];
    [self.view addSubview:gasBtn];
    [array addObjectsFromArray:@[lockBtn,cameraBtn,gasBtn]];
    [[cameraBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [[UIApplication sharedApplication]  openURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@", NavPushRouteURL,@"VideoEventTableViewController"]] options:nil completionHandler:nil];
    }];
    //水平方向宽度固定等间隔
    [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:(self.view.frame.size.width-40) / 3 leadSpacing:10 tailSpacing:10];
    [array mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
        make.top.equalTo(self.mas_topLayoutGuide).offset(10);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.2);//设置高度为self.view高度的1/5
//        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    //设置中部主图片视图
    UIImageView *homeImgView = [[UIImageView alloc] init];
    homeImgView.backgroundColor = [UIColor whiteColor];
    // 设置图片
    homeImgView.image = [UIImage imageNamed:@"home"];
    //  不规则图片显示
    homeImgView.contentMode =  UIViewContentModeScaleAspectFill;
    homeImgView.autoresizesSubviews = YES;
    homeImgView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    //  图片大于或小于显示区域
    homeImgView.clipsToBounds  = NO;
    [self.view addSubview:homeImgView];
    [homeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lockBtn.mas_bottom).offset(20);
            make.centerX.equalTo(self.view.mas_centerX);
            make.height.equalTo(self.view.mas_height).multipliedBy(0.2);//设置高度为self.view高度的2/5
    }];
    
    //设置环绕主homeimage视图底部三个按钮
    NSMutableArray *array2 = [NSMutableArray new];
    UIEdgeInsets imgPadding = UIEdgeInsetsMake(2, 2, 2, 2);
    UIButton *leaveBtn = [[UIButton alloc] init];
    [leaveBtn setImage:[[UIImage imageNamed:@"leave"] resizableImageWithCapInsets:imgPadding resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setImage:[[UIImage imageNamed:@"close_selected"] resizableImageWithCapInsets:imgPadding resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    UIButton *sleepBtn = [[UIButton alloc] init];
    [sleepBtn setImage:[[UIImage imageNamed:@"sleep"] resizableImageWithCapInsets:imgPadding resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [self.view addSubview:leaveBtn];
    [self.view addSubview:closeBtn];
    [self.view addSubview:sleepBtn];
//    closeBtn.backgroundColor = [UIColor grayColor];
//    leaveBtn.backgroundColor = [UIColor grayColor];
//    sleepBtn.backgroundColor = [UIColor grayColor];
    [array2 addObjectsFromArray:@[leaveBtn,sleepBtn]];
    //水平方向宽度固定等间隔
    [array2 mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:(self.view.frame.size.width-40) / 4 leadSpacing:50 tailSpacing:50];
    [array2 mas_makeConstraints:^(MASConstraintMaker *make) { //数组额你不必须都是view
        make.top.equalTo(homeImgView.mas_bottom).offset(10);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.1);//设置高度为self.view高度的0.1
//        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@[homeImgView.mas_bottom,leaveBtn.mas_centerY]).offset(2);
        make.top.equalTo(leaveBtn.mas_centerY).offset(5);
        make.centerX.equalTo(homeImgView.mas_centerX);
        make.height.equalTo(self.view.mas_height).multipliedBy(0.1);//设置高度为self.view高度的0.1
    }];
    
    //设置底部按钮和左右文字
    NSMutableArray *array3 = [NSMutableArray new];
    UIButton *energyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,100, 100)];
    UIImage *energyImg = [UIImage imageNamed:@"energy"];
    UIImage *stretchableButtonImage = [energyImg stretchableImageWithLeftCapWidth:0 topCapHeight:0];
//    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    UIImage *resizeableImage = [energyImg resizableImageWithCapInsets:edgeInsets];
    [energyBtn setBackgroundImage:stretchableButtonImage forState:UIControlStateNormal];
//    energyBtn.imageEdgeInsets = UIEdgeInsetsMake(25, 25, 25, 25);
    UILabel *leftlabel = [[UILabel alloc]init];
    UILabel *leftlabel2 = [[UILabel alloc]init];
    UILabel *rightlabel = [[UILabel alloc]init];
    UILabel *rightlabel2 = [[UILabel alloc]init];
    [leftlabel setFont:[UIFont systemFontOfSize:21 weight:UIFontWeightLight]];
    [leftlabel2 setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightThin]];
//    [leftlabel2 setTextColor: [UIColor colorWithRed:139.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1]];
    [leftlabel setTextAlignment:NSTextAlignmentCenter];
    [leftlabel2 setTextAlignment:NSTextAlignmentCenter];
    [leftlabel setText:@"Solar Power"];
    [leftlabel2 setText:@"3050Kwh"];
    [rightlabel setFont:[UIFont systemFontOfSize:21 weight:UIFontWeightLight]];
    [rightlabel2 setFont:[UIFont systemFontOfSize:14 weight:UIFontWeightThin]];
//    [rightlabel2 setFont:[UIFont fontWithName:@"Arial" size:14]];
//    [rightlabel2 setTextColor: [UIColor colorWithRed:139.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1]];
    [rightlabel setTextAlignment:NSTextAlignmentCenter];
    [rightlabel2 setTextAlignment:NSTextAlignmentCenter];
    [rightlabel setText:@"Solar Water"];
    [rightlabel2 setText:@"1688h"];
    [self.view addSubview:energyBtn];
    [self.view addSubview:leftlabel];
    [self.view addSubview:rightlabel];
    [self.view addSubview:leftlabel2];
    [self.view addSubview:rightlabel2];
//    energyBtn.backgroundColor = [UIColor grayColor];
//    leftlabel.backgroundColor = [UIColor blueColor];
//    rightlabel.backgroundColor = [UIColor blueColor];
    [array3 addObjectsFromArray:@[leftlabel,energyBtn,rightlabel]];
//    //水平方向宽度固定等间隔
//    [array3 mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:self.view.frame.size.width/3 leadSpacing:0 tailSpacing:0];
    
//    NSLog(@"with::%f",self.view.frame.size.width/3);
    [energyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.top.equalTo(closeBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    [leftlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(energyBtn.mas_top).offset(25);
        make.centerX.equalTo(energyBtn.mas_left).multipliedBy(0.5);//enerygbtn.left/2
    }];
    [self.view layoutIfNeeded];//必须先调用强制布局一次，energyBtn.X才会由初始值0得到更新，rightlabel的centerX设置才能生效
    [rightlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(energyBtn.mas_top).offset(25);
        make.centerX.equalTo(energyBtn.mas_right).offset((self.view.frame.size.width-(energyBtn.frame.origin.x+energyBtn.frame.size.width))/2);
    }];
    [leftlabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(leftlabel.mas_top).offset(25);
        make.centerX.equalTo(leftlabel.mas_centerX);
    }];
    [rightlabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rightlabel.mas_top).offset(25);
        make.centerX.equalTo(rightlabel.mas_centerX);
    }];
//    NSLog(@"view width::%f",self.view.frame.size.width);
//    NSLog(@"energyBtn right::%f",energyBtn.frame.origin.x+energyBtn.frame.size.width);
//    NSLog(@"center offsetx::%f",(self.view.frame.size.width-(energyBtn.frame.origin.x+energyBtn.frame.size.width))/2);
    
}

#pragma mark - 按钮点击事件
- (void)leftAction:(UIButton *)button{
    [button setSelected:!button.isSelected];
    if (button.isSelected) {
        //selected
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"zoom_selected"]] forState:UIControlStateSelected];
    }else{
        //normal
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"zoom"]] forState:UIControlStateNormal];
    }
//    PGGTestViewController *test = [[PGGTestViewController alloc] init];
//    [self.navigationController pushViewController:test animated:YES];
}

#pragma mark - 按钮点击事件
- (void)rightAction:(UIButton *)button{
    [button setSelected:!button.isSelected];
    if (button.isSelected) {
        //selected
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"shopcar_selected"]] forState:UIControlStateSelected];
    }else{
        //normal
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"shopcar"]] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
