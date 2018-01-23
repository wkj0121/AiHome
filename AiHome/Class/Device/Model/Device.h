//
//  Device.h
//  AiHome
//
//  Created by wkj on 2018/1/13.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Device : NSObject

/** 设备类型 */
@property (nonatomic, strong) NSString *type;
/** 设备品牌 */
@property (nonatomic, strong) NSString *brand;
/** 设备型号 */
@property (nonatomic, strong) NSString *version;
/** 图标 */
@property (nonatomic, strong) NSString *logo;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)deviceWithDictionary:(NSDictionary *)dict;

@end
