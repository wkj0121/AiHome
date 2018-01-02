//
//  iCocosSettingItem.m
//  01-iCocos
//
//  Created by apple on 13-12-23.
//  Copyright (c) 2013年 iCocos. All rights reserved.
//

#import "iCocosSettingItem.h"

@implementation iCocosSettingItem

/**
 *  初始化Cell（通过icon创建Cell）
 * @param icon 图标
 * @param title 标题
 * @param style 样式
 * @param type 类型
 * @param desc 描述
 * @return 对应Cell模型
 */
+ (id)itemWithImage:(UIImage *)icon title:(NSString *)title style:(UITableViewCellStyle)style type:(iCocosSettingItemType)type desc:(NSString *)desc
{
    iCocosSettingItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    item.style = style;
    item.type = type;
    item.desc = desc;
    return item;
}

/**
 *  初始化Cell（通过icon创建Cell）
 * @param icon 图标
 * @param title 标题
 * @param style 样式
 * @param type 类型
 * @param desc 描述
 * @param detailLabelColor 描述文字颜色
 * @return 对应Cell模型
 */
+ (id)itemWithImage:(UIImage *)icon title:(NSString *)title style:(UITableViewCellStyle)style type:(iCocosSettingItemType)type desc:(NSString *)desc detailLabelColor:(UIColor *)detailLabelColor
{
    iCocosSettingItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    item.style = style;
    item.type = type;
    item.desc = desc;
    item.detailLabelColor = detailLabelColor;
    return item;
}


/**
 *  初始化Cell（通过icon创建Cell带右侧图片）
 * @param icon 图标
 * @param title 标题
 * @param style 样式
 * @param type 类型
 * @param image 图片
 * @return 对应Cell模型
 */
+ (id)itemWithImage:(UIImage *)icon title:(NSString *)title style:(UITableViewCellStyle)style type:(iCocosSettingItemType)type image:(UIImage *)image
{
    iCocosSettingItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    item.style = style;
    item.type = type;
    item.image = image;
    return item;
}

/**
 *  初始化Cell（通过icon创建Cell带右侧图片）
 * @param icon 图标
 * @param title 标题
 * @param style 样式
 * @param type 类型
 * @param image 图片
 * @param desc 描述
 * @param detailLabelColor 描述文字颜色
 * @return 对应Cell模型
 */
+ (id)itemWithImage:(UIImage *)icon title:(NSString *)title style:(UITableViewCellStyle)style type:(iCocosSettingItemType)type image:(UIImage *)image desc:(NSString *)desc detailLabelColor:(UIColor *)detailLabelColor
{
    iCocosSettingItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    item.style = style;
    item.type = type;
    item.image = image;
    item.desc = desc;
    item.detailLabelColor = detailLabelColor;
    return item;
}


/**
 *  初始化Cell（通过标题创建Cell）
 * @param title 标题
 * @param style 样式
 * @param type 类型
 * @param placeHolder 占位文字
 * @return 对应Cell模型
 */
+ (id)itemWithTitle:(NSString *)title style:(UITableViewCellStyle)style type:(iCocosSettingItemType)type placeHolder:(NSString *)placeHolder
{
    iCocosSettingItem *item = [[self alloc] init];
    item.title = title;
    item.style = style;
    item.type = type;
    item.placeHolder = placeHolder;
    return item;
}



@end
