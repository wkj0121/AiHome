//
//  Region.m
//  AiHome
//
//  Created by wkj on 2018/1/6.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "NormalInfo.h"

@implementation NormalInfo

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (id)infoWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end
