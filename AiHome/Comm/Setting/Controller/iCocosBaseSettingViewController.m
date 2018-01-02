//
//  iCocosBaseSettingViewController.m
//  01-iCocos
//
//  Created by apple on 13-12-23.
//  Copyright (c) 2013年 iCocos. All rights reserved.
//

#import "iCocosBaseSettingViewController.h"
#import "iCocosSettingCell.h"


@interface iCocosBaseSettingViewController ()

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation iCocosBaseSettingViewController

- (void)loadView
{
    /**
     添加TableView
     
     - returns: return value description
     */
    UITableView *tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.view = tableView;
    tableView.sectionFooterHeight = 20;
    tableView.sectionHeaderHeight = 0;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);//willDisplayCell完美实现方式
//    tableView.separatorStyle = NO;
//    tableView.separatorColor=[UIColor clearColor];
    tableView.rowHeight = self.rowHeight;
    //设置头部高度
    tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _allGroups = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:235 / 255.0];
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _allGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    iCocosSettingGroup *group = _allGroups[section];
    return group.items.count;
}

#pragma mark 每当有一个cell进入视野范围内就会调用，返回当前这行显示的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    // 1.创建一个iCocosSettingCell
//    iCocosSettingCell *cell = [iCocosSettingCell settingCellWithTableView:tableView];
//    CGFloat cellHeight = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
    // 1.取出这行对应的模型（iCocosSettingItem）
    iCocosSettingGroup *group = _allGroups[indexPath.section];
    iCocosSettingItem *settingItem = group.items[indexPath.row];
    // 2.创建一个iCocosSettingCell
    iCocosSettingCell *cell = [iCocosSettingCell settingCellWithTableView:tableView cellStyle:settingItem.style];
    if(indexPath.row == 0 && indexPath.section == 0 && self.hasCustomHead) {
        [cell setItem:(settingItem) isCustomHead:YES];
    }else{
        [cell setItem:settingItem isCustomHead:NO];
    }
    return cell;
}

#pragma mark 点击了cell后的操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 0.取出这行对应的模型
    iCocosSettingGroup *group = _allGroups[indexPath.section];
    iCocosSettingItem *item = group.items[indexPath.row];
    
    // 1.取出这行对应模型中的block代码
    if (item.operation) {
        // 执行block
        item.operation();
    }
}

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
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 0)];
    }
}

#pragma mark 返回每一组的header标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    iCocosSettingGroup *group = _allGroups[section];
    
    return group.header;
}
#pragma mark 返回每一组的footer标题
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    iCocosSettingGroup *group = _allGroups[section];
    
    return group.footer;
}


#pragma mark 返回每一组的footer高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    iCocosSettingGroup *group = _allGroups[section];
    return group.footerHeight;
}

#pragma mark 返回每一组的header高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    iCocosSettingGroup *group = _allGroups[section];
    return group.headerHeight;
}
#pragma mark 返回每一组的Row高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0 && indexPath.section == 0 && self.hasCustomHead) {
        return self.rowHeight*2;
    }else{
        return self.rowHeight;
    }
}


@end
