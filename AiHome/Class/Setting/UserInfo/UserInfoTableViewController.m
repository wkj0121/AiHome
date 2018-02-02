//
//  UserInfoTableViewController.m
//  AiHome
//
//  Created by wkj on 2018/1/6.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "UserInfoTableViewController.h"
#import "NormalInfo.h"
#import "NormalTableViewCell.h"
#import "HeadTableViewCell.h"

@interface UserInfoTableViewController ()
// cell数组
@property (nonatomic, strong) NSMutableArray *allCellsArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation UserInfoTableViewController
// 懒加载 （重写getter方法）
- (NSMutableArray *)allCellsArray
{
    if (_allCellsArray == nil) {
        self.allCellsArray = [[NSMutableArray array]init];
    }
    return _allCellsArray;
}

- (void)loadView
{
    /**
     添加TableView
     
     - returns: return value description
     */
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
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
    
    tableView.delegate = self;
    tableView.dataSource = self;
    self.view = tableView;
    tableView.sectionFooterHeight = 20;
    tableView.sectionHeaderHeight = 0;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //设置头部高度
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavItem];
    [self handleData];
    
}

- (void)handleData
{
    UserInfoManager *userInfo = [UserInfoManager shareUser];
    NSMutableArray *headArray = [NSMutableArray array];
    [headArray addObject:@{@"label": @"头像", @"data": userInfo.headImageData, @"type": @100}];
    [headArray addObject:@{@"label": @"昵称", @"value": @"偷得浮生半日闲", @"type": @101}];
    [headArray addObject:@{@"label": @"手机号", @"value": @"18013556187", @"type": @101}];
    [headArray addObject:@{@"label": @"分享AiHome", @"data": UIImagePNGRepresentation([UIImage imageNamed:@"QRCode"]), @"type": @100}];
    [headArray addObject:@{@"label": @"更多", @"value": @"", @"type": @101}];
    
    NSMutableArray *deviceArray = [NSMutableArray array];
    [deviceArray addObject:@{@"label": @"设备转移", @"value": @"", @"type": @101}];
    
    NSMutableArray *settingArray = [NSMutableArray array];
    [settingArray addObject:@{@"label": @"密码修改", @"value": @"", @"type": @101}];
    [settingArray addObject:@{@"label": @"手势密码", @"value": @"", @"type": @101}];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:headArray];
    [array addObject:deviceArray];
    [array addObject:settingArray];
    
    // 将要显示的数据转为model对象
    for (NSArray *regoins in array) {
        NSArray * persons = [[regoins.rac_sequence map:^id _Nullable(NSDictionary* value) {
            return [NormalInfo infoWithDict:value];
        }] array];
        [self.allCellsArray addObject:persons];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 定制导航条内容
- (void)customNavItem {
    self.navigationItem.title = @"个人信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.allCellsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *array = self.allCellsArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出type
    NSMutableArray *infos = self.allCellsArray[indexPath.section];
    NormalInfo *info = infos[indexPath.item];
    // 类型判断
    if(info.type == 100){// 右侧有图片
        HeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"head"];
        if (!cell) {
            cell = [[HeadTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"head"];
        }
        cell.normalLabel.text = info.label;
        cell.headImageView.image = [UIImage imageWithData:info.data];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    NormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normal"];
    if (!cell) {
        cell = [[NormalTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"normal"];
    }
    cell.normalLabel.text = info.label;
    cell.normalData.text = info.value;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld,%ld",indexPath.section,indexPath.item);
    if(indexPath.section == 0 && indexPath.item == 0){
        [self changeIcon];
    }else if(indexPath.section == 0 && indexPath.item == 1){
        NSMutableArray *infos = self.allCellsArray[0];
        NormalInfo *info = infos[1];
        [self changeText:info.value];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)changeIcon
{
    UIAlertController *alertController;
    __block NSUInteger blockSourceType = 0;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //支持访问相机与相册情况
        alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击从相册中选取");
            blockSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = blockSourceType;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击拍照");
            blockSourceType = UIImagePickerControllerSourceTypeCamera;
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = blockSourceType;
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击取消");
            return;
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        //只支持访问相册情况
        alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:@"从相册中选取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击从相册中选取");
            blockSourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = blockSourceType;
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击取消");
            return;
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)changeText:(NSString *)text
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改" message:@"请输入内容" preferredStyle:UIAlertControllerStyleAlert];
    //添加的输入框
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = text;
    }];
    UIAlertAction *Action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *twoAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //添加的带输入框的提示框
        UITextField *senceText = (UITextField *)alert.textFields.firstObject;
        NSLog(@"%@",senceText.text);
    }];
    [alert addAction:Action];
    [alert addAction:twoAc];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
