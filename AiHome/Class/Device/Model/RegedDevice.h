//
//  RegedDevice.h
//  AiHome
//
//  Created by wkj on 2018/1/14.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Device.h"
//Groupm模型类
@interface RegedDevice : NSObject

/** 设备类型 */
@property (nonatomic, strong) NSString *type;
/** 设备列表 */
@property (nonatomic, strong) NSMutableArray<Device *> *devices;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)regedDeviceWithDictionary:(NSDictionary *)dict;

@end
