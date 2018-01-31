//
//  FKLoginViewController.m
//  FXXKBaseMVVM
//
//  Created by 梁宪松 on 2017/12/10.
//  Copyright © 2017年 madao. All rights reserved.
//

#import "FKLoginViewController.h"
#import "AppDelegate.h"
#import "FKLoginViewModel.h"
#import "FKLoginInputFooterView.h"
#import "FKLoginAccountInputTableViewCell.h"
#import "FKLoginPwdInputTableViewCell.h"

typedef NS_ENUM(NSInteger, kLoginInputType) {
    kLoginInputType_account = 0,//账户
    kLoginInputType_password = 1, //密码
    kLoginInputType_null = 2 //密码
};

@interface FKLoginViewController ()<UITableViewDelegate, UITableViewDataSource>

/**
 viewModel
 */
@property (nonatomic, strong) FKLoginViewModel *viewModel;

/**
 用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImageView;

/**
 用户输入tableview
 */
@property (weak, nonatomic) IBOutlet UITableView *loginInputTableView;

/**
 tableheader
 */
@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;

/**
 tableFooter
 */
@property (nonatomic, strong) IBOutlet FKLoginInputFooterView *tableFooterView;

@end

@implementation FKLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.view.backgroundColor = [UIColor blueColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fk_initialDefaultsForController
{
    [self setViewModel:[[FKLoginViewModel alloc] initWithParams:self.params]];

}

- (void)fk_configNavigationForController
{
    
}

- (void)fk_createViewForConctroller
{
    // config tableView
    _loginInputTableView.delegate = self;
    _loginInputTableView.dataSource = self;
    [_loginInputTableView setScrollEnabled:NO];
//    _loginInputTableView.backgroundColor = [UIColor redColor];
    
    // 注册cell
    [_loginInputTableView registerNib:[UINib nibWithNibName:NSStringFromClass(FKLoginAccountInputTableViewCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(FKLoginAccountInputTableViewCell.class)];
    [_loginInputTableView registerNib:[UINib nibWithNibName:NSStringFromClass(FKLoginPwdInputTableViewCell.class) bundle:nil] forCellReuseIdentifier:NSStringFromClass(FKLoginPwdInputTableViewCell.class)];
    
    // tableHeaderView
    _loginInputTableView.tableHeaderView = self.tableHeaderView;
    self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/3);
//    self.tableHeaderView.backgroundColor = [UIColor orangeColor];
    
    // tableFooterView
    _loginInputTableView.tableFooterView = self.tableFooterView;
}

-(void)fk_bindViewModelForController
{
    @weakify(self);

    // 是否可以登录
    RAC(self.tableFooterView.loginBtn, enabled) = RACObserve(self.viewModel, isLoginEnable);
    
    // 点击登录信号
    [[[self.tableFooterView.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] throttle:1.0f] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        //执行命令
        [self.viewModel.loginCommand execute:nil];
        [self fk_hideKeyBoard];
    }];
    
    // 监听loginCommand命令是否执行完毕，skip表示跳过第一次信号
    [[self.viewModel.loginCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if (x.boolValue) {
            [self.tableFooterView.loginBtn startLoadingAnimation];
        } else {
            // 2秒后移除提示框
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableFooterView.loginBtn stopLoadingAnimation];
            });
        }
    }];
    
    // 订阅loginCommand中的信号
    [self.viewModel.loginCommand.executionSignals subscribeNext:^(RACSignal* signal) {
        
        [[signal dematerialize] subscribeNext:^(id  _Nullable x) {
            
            BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"];
            if(isLogin){
                [SVProgressHUD fk_displaySuccessWithStatus:@"登录成功"];
                // 2s后进入首页
                [SVProgressHUD dismissWithDelay:2.0f completion:^{
                    NSLog(@"-----SVProgressHUD");
                    [[NSNotificationCenter defaultCenter] postNotificationName:FKLoginStateChangedNotificationKey object:nil];
                }];
            }else{
                [SVProgressHUD fk_displaySuccessWithStatus:@"登录失败"];
            }
        } error:^(NSError * _Nullable error) {
            [SVProgressHUD fk_displayErrorWithStatus:error.localizedDescription];
        }];
    }];
}

#pragma mark - Getter
- (FKLoginInputFooterView *)tableFooterView
{
    if (!_tableFooterView){
        CGFloat height = self.view.frame.size.height-self.tableHeaderView.frame.size.height- self.viewModel.cellTitleArray.count*_loginInputTableView.rowHeight;
//        NSLog(@"create FooterView height==>%f",height);
        _tableFooterView = [[FKLoginInputFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
//       //设置FooterView背景颜色
//        UIView *view = [[UIView alloc] initWithFrame:(_tableFooterView.frame)];
//        view.backgroundColor = [UIColor greenColor];
//        _tableFooterView.backgroundView = view;
    }
    return _tableFooterView;
}

@end


#pragma mark - UITableViewDelegate
@implementation FKLoginViewController(UITableViewDelegate)

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.cellTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case kLoginInputType_account:
        {
            // 账户
            FKLoginAccountInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(FKLoginAccountInputTableViewCell.class)];
            
            [cell bindViewModel:self.viewModel withParams:nil];
//            cell.backgroundColor = [UIColor blackColor];
            return cell;
        }
            break;
        case kLoginInputType_password:
        {
            // 密码
            FKLoginPwdInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(FKLoginPwdInputTableViewCell.class)];
            
            [cell bindViewModel:self.viewModel withParams:nil];
//            cell.backgroundColor = [UIColor blackColor];
            return cell;
        }
            break;
        default:
            break;
    }
//    UITableViewCell *cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"blankCell"];
//    cell.backgroundColor = [UIColor grayColor];
//    return cell;
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"blankCell"];
    
}

////nnd 根本没调用DisplayFootView
//-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
//    UITableViewHeaderFooterView *footerView = (UITableViewHeaderFooterView *)view;
//    CGFloat height = self.tableHeaderView.frame.size.height- self.viewModel.cellTitleArray.count*_loginInputTableView.rowHeight;
//    NSLog(@"willDisplayFooterView FooterView height==>%f",height);
//    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
//}
#pragma mark - 设置cell分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If cell margins are derived from the width of the readableContentGuide.
    // NS_AVAILABLE_IOS(9_0)，需进行判断
    // 设置为 NO，防止在横屏时留白
    if ([tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    
    // Prevent the cell from inheriting the Table View's margin settings.
    // NS_AVAILABLE_IOS(8_0)，需进行判断
    // 阻止 Cell 继承来自 TableView 相关的设置（LayoutMargins or SeparatorInset），设置为 NO 后，Cell 可以独立地设置其自身的分割线边距而不依赖于 TableView
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Remove seperator inset.
    // NS_AVAILABLE_IOS(8_0)，需进行判断
    // 移除 Cell 的 layoutMargins（即设置为 0）
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    // Explictly set your cell's layout margins.
    // NS_AVAILABLE_IOS(7_0)，需进行判断
    // 根据需求设置相应的边距
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 30, 0, 60)];
    }
}

@end
