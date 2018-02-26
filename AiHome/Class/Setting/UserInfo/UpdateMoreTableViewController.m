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

@interface UpdateMoreTableViewController ()

@property (nonatomic, strong) NSMutableArray *allCellsArray;

@end

@implementation UpdateMoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"更多信息";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
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
    [headArray addObject:@{@"label": @"QQ", @"value": userInfo.qqNum}];
    [headArray addObject:@{@"label": @"性别", @"value": userInfo.sex}];
    [headArray addObject:@{@"label": @"生日", @"value": currentDateString}];
    [headArray addObject:@{@"label": @"身高", @"value": userInfo.height}];
    [headArray addObject:@{@"label": @"地址", @"value": userInfo.address}];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPathxPath {
    return 60.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出type
    NSMutableArray *infos = self.allCellsArray[indexPath.section];
    NormalInfo *info = infos[indexPath.item];
    NormalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"normal"];
    if (!cell) {
        cell = [[NormalTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"normal"];
    }
    cell.normalLabel.text = info.label;
    cell.normalData.text = info.value;
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    return cell;
}

@end
