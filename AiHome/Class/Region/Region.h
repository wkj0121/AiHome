//
//  Region.h
//  AiHome
//
//  Created by wkj on 2018/1/6.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Region : NSObject
@property (nonatomic, copy) NSString *regName; //区域名称
@property (nonatomic, copy) NSNumber *regionID;//区域ID
@property (nonatomic, copy) NSString *msgNum;  //消息数量
@property (nonatomic, assign) BOOL regCheckFlag;//是否选中

- (id)initWithDict:(NSDictionary *)dict;

+ (id)regionWithDict:(NSDictionary *)dict;

@end
