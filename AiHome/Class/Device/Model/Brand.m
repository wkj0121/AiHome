//
//  Brand.m
//  AiHome
//
//  Created by wkj on 2018/1/14.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "Brand.h"

@implementation Brand

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
        //当有模型嵌套时,需要手动将字典转换成模型
        NSMutableArray * arrayModels = [NSMutableArray array];
        for (NSDictionary * item_dict in dict[@"versions"]) {
            [arrayModels addObject:item_dict];
        }
        self.versions = arrayModels;
    }
    return self;
}
+ (instancetype)brandWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

@end
