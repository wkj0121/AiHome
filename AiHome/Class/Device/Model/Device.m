//
//  Device.m
//  AiHome
//
//  Created by wkj on 2018/1/13.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "Device.h"

@implementation Device

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (instancetype)deviceWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

@end
