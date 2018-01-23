//
//  VideoEventModel.h
//  AiHome
//
//  Created by wkj on 2018/1/6.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoEventModel : NSObject

@property (nonatomic, copy) NSString *eventShortTime; //事件小时分钟
@property (nonatomic, copy) NSString *eventTime; //事件时间
@property (nonatomic, copy) NSString *eventText;  //事件描述

- (id)initWithDict:(NSDictionary *)dict;

+ (id)videoEventModelWithDict:(NSDictionary *)dict;

@end
