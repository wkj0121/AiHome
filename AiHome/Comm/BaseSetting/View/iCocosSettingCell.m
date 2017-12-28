//
//  iCocosSettingself.m
//  01-iCocos
//
//  Created by apple on 13-12-23.
//  Copyright (c) 2013年 iCocos. All rights reserved.
//

#import "iCocosSettingCell.h"
#import "iCocosSettingItem.h"
//#import "SevenSwitch.h"

#import "UIView+Extension.h"

@interface iCocosSettingCell()<UITextFieldDelegate>
{
    UIImageView *_arrow;
    UISwitch *_switch;//默认switch
//    SevenSwitch *_switch;
    UITextField *_textField;
    UIImageView *_imageView;
}

@property (nonatomic, weak) UIView *sepView;


@end

@implementation iCocosSettingCell

+ (id)settingCellWithTableView:(UITableView *)tableView cellStyle:(UITableViewCellStyle)cellStyle
{
    // 0.用static修饰的局部变量，只会初始化一次
    static NSString *ID = @"Cell";
    
    // 1.拿到一个标识先去缓存池中查找对应的Cell
    iCocosSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 2.如果缓存池中没有，才需要传入一个标识创建新的Cell
    if (cell == nil) {
        cell = [[iCocosSettingCell alloc] initWithStyle:cellStyle reuseIdentifier:ID];
//        cell = [[iCocosSettingCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
//        cell.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1.0];
    }
    
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        UIView *sepView = [[UIView alloc] init];
        sepView.backgroundColor = [UIColor clearColor];
//        sepView.layer.borderWidth = 1;// 宽度
//        sepView.borderColor = [UIColor.redColor()];//颜色
//        sepView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.0];
        self.sepView = sepView;
        [self.contentView addSubview:sepView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.sepView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.8);
}

- (void)setItem:(iCocosSettingItem *)item isCustomHead:(BOOL *)isCustomHead
{
    _item = item;
    CGFloat rowHeight = TabViewRowHeight;
    if(isCustomHead){
        rowHeight = TabViewCustomHeadRowHeight;
    }
    // 设置数据
    self.imageView.image = item.icon;
//    self.imageView.backgroundColor=[UIColor blackColor];
//    NSLog(@"contentView height/1.5==>%f",self.contentView.height/2);
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.mas_equalTo(self.contentView.mas_centerY);
////        make.left.mas_equalTo(20);
//        make.centerX.mas_equalTo(self.textLabel.mas_left).multipliedBy(0.5);
//        make.width.mas_equalTo(self.contentView.height/2);//icon宽度为cell高度的1/2
//        make.height.mas_equalTo(self.contentView.height/2);//icon高度为cell高度的1/2
////        make.height.mas_equalTo(self.textLabel.mas_height);//icon高度为Label高度
//    }];
//    //UIImage * icon = [UIImage imageNamed:@"goods_1"];
    //适配优化icon大小
//    CGSize itemSize = CGSizeMake(self.contentView.height/2, self.contentView.height/2);//固定图片大小为36*36
    CGSize itemSize = CGSizeMake(rowHeight/2, rowHeight/2);//固定图片大小为36*36
    if(isCustomHead){
        itemSize = CGSizeMake(rowHeight/1.25, rowHeight/1.25);//固定图片大小为36*36
     }
    //开始对imageView进行画图
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0);//*1
    CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
    if(isCustomHead){
        //使用贝塞尔曲线画出一个圆形图
        [[UIBezierPath bezierPathWithRoundedRect:imageRect cornerRadius:20] addClip];
    }
    [item.icon drawInRect:imageRect];
    self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();//*2
    //结束画图
    UIGraphicsEndImageContext();//*3
    
    self.textLabel.text = item.title;
    if(isCustomHead){
        self.textLabel.font = [UIFont systemFontOfSize:18];
    }else{
        self.textLabel.font = [UIFont systemFontOfSize:16];
    }
    self.detailTextLabel.text = item.desc;
    self.detailTextLabel.textColor = item.detailLabelColor;
    if(isCustomHead){
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }else{
        self.detailTextLabel.font = [UIFont systemFontOfSize:10];
    }
    
    if (item.type == iCocosSettingItemTypeArrow) {
        
        if (_arrow == nil) {
            _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IndicatorArrow_right"]];
        }
        
        // 右边显示箭头
        self.accessoryView = _arrow;
        // 用默认的选中样式
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else if (item.type == iCocosSettingItemTypeSwitch) {
        
        if (_switch == nil) {
            //默认switch
            _switch = [[UISwitch alloc] init];
            _switch.on = YES;
            [_switch addTarget:self action:@selector(settingSwitchClick) forControlEvents:UIControlEventValueChanged];
//            _switch = [[SevenSwitch alloc] initWithFrame:CGRectMake(10, 10, 70, 30)];
//            _switch.offLabel.text = @"on";
//            _switch.onLabel.text = @"off";
//             _switch.on = NO;
//            [_switch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        }
        
        // 右边显示开关
        self.accessoryView = _switch;
        // 禁止选中
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else if (item.type == iCocosSettingItemTypeTextField) {
        
        if (_textField == nil) {
            _textField = [[UITextField alloc] init];
            _textField.height = self.frame.size.height;
            _textField.placeholder = item.placeHolder;
            _textField.font = [UIFont systemFontOfSize:13];
            _textField.width = 200;
            _textField.x = [UIScreen mainScreen].bounds.size.width - 210;
            _textField.delegate = self;
            
            _textField.textAlignment = NSTextAlignmentRight;
            
        }
        
        // 右边显示文字输入框
        self.accessoryView = _textField;
        // 禁止选中
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    } else if (item.type == iCocosSettingItemTypeImage) {
//        self.contentView.backgroundColor=[UIColor clearColor];
        self.accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 40)];
        if (_imageView == nil) {
            _imageView = [[UIImageView alloc] init];
            _imageView.image = item.image;
//            _imageView.frame = self.accessoryView.frame;
//            _imageView.frame = CGRectMake(0, 0, _imageView.image.size.width, _imageView.image.size.height);
//            _imageView.width = 100;
        }
        // 右边显示图片
        [self.accessoryView addSubview:_imageView];
//        self.accessoryView = _imageView;
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.accessoryView).with.insets(UIEdgeInsetsMake(3, 3, 3, 3));
        }];
        // 禁止选中
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else if (item.type == iCocosSettingItemTypeImageWithArrow) {
        self.accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 36, 40)];
//        NSMutableArray *array = [NSMutableArray new];
        if (_imageView == nil) {
            _imageView = [[UIImageView alloc] init];
            _imageView.image = item.image;
//            _imageView.frame = self.accessoryView.frame;
//            _imageView.frame = CGRectMake(0, 0, _imageView.image.size.width, _imageView.image.size.height);
//            _imageView.width = 100;
//            _imageView.backgroundColor = [UIColor blackColor];
        }
        if (_arrow == nil) {
            _arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"IndicatorArrow_right"]];
        }
        // 右边显示图片和箭头
        [self.accessoryView addSubview:(_imageView)];
        [self.accessoryView addSubview:(_arrow)];
//        [array addObjectsFromArray:@[_imageView,_arrow]];
//        [array mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1 leadSpacing:1 tailSpacing:1];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.accessoryView.mas_centerY);
            make.left.mas_equalTo(self.accessoryView.mas_left);
            make.width.mas_equalTo(self.accessoryView.width/1.5);
            make.height.mas_equalTo(self.accessoryView.width/1.5);
        }];
        [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.accessoryView.mas_centerY);
            make.width.mas_equalTo(self.accessoryView.height/5.0);
            make.height.mas_equalTo(self.accessoryView.height/3.0);
//            make.top.mas_equalTo(self.accessoryView.mas_top).offset(3);
//            make.bottom.mas_equalTo(self.accessoryView.mas_bottom).offset(-3);
            make.right.mas_equalTo(self.accessoryView.mas_right);
        }];
        // 禁止选中
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }else {
        
        // 什么也没有，清空右边显示的view
        self.accessoryView = nil;
        // 用默认的选中样式
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
}

- (void)settingSwitchClick
{
    NSLog(@"%s", __func__);
}

//- (void)switchChanged:(SevenSwitch *)sender {
//    SevenSwitch *switchInCell = (SevenSwitch *)sender;
//    //UISwitch的superview就是cell
////    UITableViewCell * cell = (UITableViewCell*) switchInCell.superview;
////    NSIndexPath * indexpath = [self.tableView indexPathForCell:cell];
//    NSLog(@"swichItem:%@ Changed value to: %@", switchInCell,sender.on ? @"ON" : @"OFF");
//}


@end
