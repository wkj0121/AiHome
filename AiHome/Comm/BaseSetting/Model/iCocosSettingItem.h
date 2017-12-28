//
//  iCocosSettingItem.h
//  01-iCocos
//
//  Created by apple on 13-12-23.
//  Copyright (c) 2013年 iCocos. All rights reserved.
//  一个Item对应一个Cell
// 用来描述当前cell里面显示的内容，描述点击cell后做什么事情

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, iCocosSettingItemType) {
    iCocosSettingItemTypeNone = 0, // 什么也没有
    iCocosSettingItemTypeArrow, // 箭头
    iCocosSettingItemTypeImage, //图片
    iCocosSettingItemTypeImageWithArrow, //图片&箭头
    iCocosSettingItemTypeSwitch, // 开关
    iCocosSettingItemTypeTextField // 文本
};

@interface iCocosSettingItem : NSObject
/** 图片  */
@property (nonatomic, copy) UIImage *icon;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 描述 */
@property (nonatomic, copy) NSString *desc;
/** 占位文字 */
@property (nonatomic, copy) NSString *placeHolder;
/** 图片 */
@property (nonatomic, weak) UIImage *image;
/** 描述文字颜色 */
@property (nonatomic , strong) UIColor *detailLabelColor;

/** 类型 */
@property (nonatomic, assign) iCocosSettingItemType type;// Cell的类型
/** 样式 */
@property (nonatomic, assign) UITableViewCellStyle style;// Cell的样式

/** 点击Cell的操作 */
@property (nonatomic, copy) void (^operation)() ; // 点击cell后要执行的操作


/**
 *  初始化Cell（通过icon创建Cell）
 * @param icon 图标
 * @param title 标题
 * @param style 样式
 * @param type 类型
 * @param desc 描述
 * @return 对应Cell模型
 */
+ (id)itemWithImage:(UIImage *)icon title:(NSString *)title style:(UITableViewCellStyle)style type:(iCocosSettingItemType)type desc:(NSString *)desc;

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
+ (id)itemWithImage:(UIImage *)icon title:(NSString *)title style:(UITableViewCellStyle)style type:(iCocosSettingItemType)type desc:(NSString *)desc detailLabelColor:(UIColor *)detailLabelColor;

/**
 *  初始化Cell（通过icon创建Cell带右侧图片）
 * @param icon 图标
 * @param title 标题
 * @param style 样式
 * @param type 类型
 * @param image 图片
 * @return 对应Cell模型
 */
+ (id)itemWithImage:(UIImage *)icon title:(NSString *)title style:(UITableViewCellStyle)style type:(iCocosSettingItemType)type image:(UIImage *)image;

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
+ (id)itemWithImage:(UIImage *)icon title:(NSString *)title style:(UITableViewCellStyle)style type:(iCocosSettingItemType)type image:(UIImage *)image desc:(NSString *)desc detailLabelColor:(UIColor *)detailLabelColor;

/**
 *  初始化Cell（通过标题创建Cell）
 * @param title 标题
 * @param style 样式
 * @param type 类型
 * @param placeHolder 占位文字
 * @return 对应Cell模型
 */
+ (id)itemWithTitle:(NSString *)title style:(UITableViewCellStyle)style type:(iCocosSettingItemType)type placeHolder:(NSString *)placeHolder;

@end
