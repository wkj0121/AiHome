//
//  UpdateMoreTableViewController.m
//  AiHome
//
//  Created by macbook on 2018/2/26.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "UpdateMoreTableViewController.h"
#import "NormalInfo.h"
#import "NormalTableViewCell.h"
#import "SaveUserInfoRequest.h"

@interface UpdateMoreTableViewController ()

@property (nonatomic, strong) NSMutableArray *allCellsArray;

@end

@implementation UpdateMoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更多信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self handleData];
}

- (NSMutableArray *)allCellsArray
{
    if (_allCellsArray == nil) {
        _allCellsArray = [[NSMutableArray array] init];
    }
    return _allCellsArray;
}

- (void)handleData
{
    UserInfoManager *userInfo = [UserInfoManager shareUser];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateString = [dateFormatter stringFromDate:userInfo.birthday];
    NSMutableArray *headArray = [NSMutableArray array];
    [headArray addObject:@{@"label": @"QQ", @"value": userInfo.qqNum, @"type": @100}];
    [headArray addObject:@{@"label": @"qq", @"value": userInfo.qqNum, @"type": @101, @"bVisible": @NO}];
    [headArray addObject:@{@"label": @"性别", @"value": userInfo.sex, @"type": @100}];
    [headArray addObject:@{@"label": @"sex", @"value": @"男", @"type": @102, @"bVisible": @NO}];
    [headArray addObject:@{@"label": @"sex", @"value": @"女", @"type": @102, @"bVisible": @NO}];
    [headArray addObject:@{@"label": @"生日", @"value": currentDateString, @"type": @100}];
    [headArray addObject:@{@"label": @"身高", @"value": userInfo.height, @"type": @100}];
    [headArray addObject:@{@"label": @"height", @"value": userInfo.height, @"type": @101, @"bVisible": @NO}];
    [headArray addObject:@{@"label": @"地址", @"value": userInfo.address, @"type": @100}];
    [headArray addObject:@{@"label": @"address", @"value": userInfo.address, @"type": @101, @"bVisible": @NO}];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:headArray];
    
    [self.allCellsArray removeAllObjects];
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return self.allCellsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    NSMutableArray *array = self.allCellsArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *infos = self.allCellsArray[indexPath.section];
    NormalInfo *info = infos[indexPath.item];
    if(info.type != 100 && !info.bVisible) {
        return 0;
    }
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出type
    NSMutableArray *infos = self.allCellsArray[indexPath.section];
    NormalInfo *info = infos[indexPath.item];
    if(info.type == 101) {
        MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MoreTableViewCell" owner:self options:nil] firstObject];
        }
        cell.textField.text = info.value;
        cell.textField.hidden = !info.bVisible;
        cell.delegate = self;
        cell.indexPath = indexPath;
        return cell;
    }else if(info.type == 102){
        MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"labelCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MoreTableViewCell" owner:self options:nil] objectAtIndex:1];
        }
        cell.normalLabel.text = info.value;
        cell.normalLabel.hidden = !info.bVisible;
        return cell;
    }
    NormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normal"];
    if (!cell) {
        cell = [[NormalTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"normal"];
    }
    cell.normalLabel.text = info.label;
    cell.normalData.text = info.value;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld,%ld",indexPath.section,indexPath.item);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0 && (indexPath.item == 0 || indexPath.item == 6 || indexPath.item == 8)){// 修改文本内容
        NSMutableArray *infos = self.allCellsArray[0];
        NormalInfo *info = infos[indexPath.item+1];
        info.bVisible = !info.bVisible;
        MoreTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:indexPath.item+1 inSection:0]];
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForItem:indexPath.item+1 inSection:0],nil] withRowAnimation:UITableViewRowAnimationFade];
    }else if(indexPath.section == 0 && indexPath.item == 2){
        NSMutableArray *infos = self.allCellsArray[0];
        for(int i=0;i<infos.count;i++){
            NormalInfo *info = infos[i];
            if(info.type == 102){
                info.bVisible = !info.bVisible;
                MoreTableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForItem:i inSection:0],nil] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }else if(indexPath.section == 0 && (indexPath.item == 3 || indexPath.item == 4)){
        NSMutableArray *infos = self.allCellsArray[0];
        NormalInfo *info = infos[indexPath.item];
        // 获取用户信息
        UserInfoManager *userInfo = [UserInfoManager shareUser];
        // 上传数据
        NSDictionary *dic = @{@"id": userInfo.uuid,@"telNum": userInfo.telNum, @"sex": info.value};
        // 修改请求
        SaveUserInfoRequest *api = [[SaveUserInfoRequest alloc] initWithUserInfo:dic];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            NSInteger status = request.responseStatusCode;
            if (200 == status && [request statusCodeValidator]) {
                [SVProgressHUD fk_displaySuccessWithStatus:@"修改成功"];
                // 修改表格内容
                NSMutableArray *infos = self.allCellsArray[0];
                NormalInfo *info2 = infos[2];
                info2.value = info.value;
                NormalInfo *info3 = infos[3];
                info3.bVisible = !info3.bVisible;
                NormalInfo *info4 = infos[4];
                info4.bVisible = !info4.bVisible;
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForItem:2 inSection:0],[NSIndexPath indexPathForItem:3 inSection:0],[NSIndexPath indexPathForItem:4 inSection:0],nil] withRowAnimation:UITableViewRowAnimationFade];
                // 保存修改信息
                userInfo.sex = info.value;
                // 修改缓存数据
                NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"];
                NSMutableDictionary *mUserDic = [[NSMutableDictionary alloc] initWithDictionary:userDic];
                [mUserDic setValue:info.value forKey:@"sex"];
                [[NSUserDefaults standardUserDefaults] setObject:mUserDic forKey:@"UserInfo"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                [SVProgressHUD fk_displayErrorWithStatus:@"修改失败"];
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            NSMutableArray *infos = self.allCellsArray[0];
            NormalInfo *info3 = infos[3];
            info3.bVisible = !info3.bVisible;
            NormalInfo *info4 = infos[4];
            info4.bVisible = !info4.bVisible;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForItem:3 inSection:0],[NSIndexPath indexPathForItem:4 inSection:0],nil] withRowAnimation:UITableViewRowAnimationFade];
            [SVProgressHUD fk_displayErrorWithStatus:@"修改失败"];
        }];
    }else if(indexPath.section == 0 && indexPath.item == 5){
        NSMutableArray *infos = self.allCellsArray[0];
        NormalInfo *info = infos[5];
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        [datePicker setDate:[formatter dateFromString:info.value]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert.view addSubview:datePicker];
        [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(alert.view.mas_top).offset(10);
            make.left.mas_equalTo(alert.view.mas_left).offset(30);
            make.width.mas_equalTo(alert.view.frame.size.width - 60);
        }];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            NSString *dateString = [formatter stringFromDate:datePicker.date];
            // 获取用户信息
            UserInfoManager *userInfo = [UserInfoManager shareUser];
            // 上传数据
            NSDictionary *dic = @{@"id": userInfo.uuid,@"telNum": userInfo.telNum, @"birthday": dateString};
            // 修改请求
            SaveUserInfoRequest *api = [[SaveUserInfoRequest alloc] initWithUserInfo:dic];
            [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
                NSInteger status = request.responseStatusCode;
                if (200 == status && [request statusCodeValidator]) {
                    [SVProgressHUD fk_displaySuccessWithStatus:@"修改成功"];
                    // 修改日期
                    info.value = dateString;
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForItem:5 inSection:0],nil] withRowAnimation:UITableViewRowAnimationFade];
                    // 保存修改信息
                    userInfo.birthday = datePicker.date;
                    // 修改缓存数据
                    NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"];
                    NSMutableDictionary *mUserDic = [[NSMutableDictionary alloc] initWithDictionary:userDic];
                    [mUserDic setValue:[NSNumber numberWithInteger:[datePicker.date timeIntervalSince1970]*1000] forKey:@"birthday"];
                    [[NSUserDefaults standardUserDefaults] setObject:mUserDic forKey:@"UserInfo"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                } else {
                    [SVProgressHUD fk_displayErrorWithStatus:@"修改失败"];
                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                NSMutableArray *infos = self.allCellsArray[0];
                NormalInfo *info3 = infos[3];
                info3.bVisible = !info3.bVisible;
                NormalInfo *info4 = infos[4];
                info4.bVisible = !info4.bVisible;
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForItem:3 inSection:0],[NSIndexPath indexPathForItem:4 inSection:0],nil] withRowAnimation:UITableViewRowAnimationFade];
                [SVProgressHUD fk_displayErrorWithStatus:@"修改失败"];
            }];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [alert addAction:ok];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:^{}];
    }
    [tableView beginUpdates];
    [tableView endUpdates];
}

- (void)textfieldTextWasChanged:(NSString *)newText withParentCell:(MoreTableViewCell *)parentCell
{
    NSIndexPath *indexPath = parentCell.indexPath;
    NSString *key = nil;
    // 获取用户信息
    UserInfoManager *userInfo = [UserInfoManager shareUser];
    if(indexPath.item == 1){
        key = @"qqNum";
    }else if(indexPath.item == 7){
        key = @"height";
    }else if(indexPath.item == 9){
        key = @"address";
    }
    NSDictionary *dic = @{@"id": userInfo.uuid,@"telNum": userInfo.telNum, key: newText};
    SaveUserInfoRequest *api = [[SaveUserInfoRequest alloc] initWithUserInfo:dic];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        NSInteger status = request.responseStatusCode;
        if (200 == status && [request statusCodeValidator]) {
            [SVProgressHUD fk_displaySuccessWithStatus:@"修改成功"];
            // 修改表格内容
            NSMutableArray *infos = self.allCellsArray[0];
            NormalInfo *info0 = infos[indexPath.item-1];
            info0.value = newText;
            NormalInfo *info1 = infos[indexPath.item];
            info1.bVisible = !info1.bVisible;
            info1.value = newText;
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForItem:indexPath.item-1 inSection:0],indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
            // 保存修改信息
            [userInfo setValue:newText forKey:key];
            // 修改缓存数据
            NSDictionary *userDic = [[NSUserDefaults standardUserDefaults] valueForKey:@"UserInfo"];
            NSMutableDictionary *mUserDic = [[NSMutableDictionary alloc] initWithDictionary:userDic];
            [mUserDic setValue:newText forKey:key];
            [[NSUserDefaults standardUserDefaults] setObject:mUserDic forKey:@"UserInfo"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            [SVProgressHUD fk_displayErrorWithStatus:@"修改失败"];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSMutableArray *infos = self.allCellsArray[0];
        NormalInfo *info1 = infos[indexPath.item];
        info1.bVisible = !info1.bVisible;
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
        [SVProgressHUD fk_displayErrorWithStatus:@"修改失败"];
    }];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

@end
