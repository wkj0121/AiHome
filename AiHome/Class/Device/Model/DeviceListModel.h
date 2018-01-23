//
//  DeviceListModel.h
//  AiHome
//
//  Created by wkj on 2018/1/14.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Brand.h"

@interface DeviceListModel : NSObject

/** 设备类型 */
@property (nonatomic, strong) NSString *type;
/** 设备品牌型号对象数组 */
@property (nonatomic, strong) NSMutableArray<Brand *> *brands;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)deviceListModelWithDictionary:(NSDictionary *)dict;

@end
