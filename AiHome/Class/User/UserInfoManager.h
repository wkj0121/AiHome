//
//  UserInfoManager.h
//  AiHome
//
//  Created by wkj on 2018/1/27.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserInfoManager : NSObject

//用户的基本信息....
@property (nonatomic, assign) NSNumber *uuid;

@property(nonatomic,copy)NSString *userName,*userPassword,*nickName,*headImage,*telNum,*qqNum,*sex,*height,*address;

@property(nonatomic,strong)NSDate *birthday;

@property(nonatomic,strong)NSDate *createTime;

@property(nonatomic,strong)NSDate *updateTime;

@property(nonatomic,strong)NSData *headImageData;

/**
 *
 通过单例模式对工具类进行初始化
 *
 */
+ (instancetype)shareUser;

/**
 *
 通过单例模式对工具类进行初始化
 *
 */
+ (void)configInfo:(NSDictionary *)infoDic;

/**
 *
 用户退出登录的操作
 *
 */
+ (void)loginOut;

+ (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
