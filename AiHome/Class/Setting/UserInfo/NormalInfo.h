//
//  Region.h
//  AiHome
//
//  Created by wkj on 2018/1/6.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NormalInfo : NSObject

@property (nonatomic, copy) NSString *label;  // 标签

@property (nonatomic, copy) NSString *value;  // 显示内容

@property (nonatomic, copy) NSData *data;     // 图片数据

@property (nonatomic, assign) NSInteger type; // 类型

- (id)initWithDict:(NSDictionary *)dict;

+ (id)infoWithDict:(NSDictionary *)dict;

@end
