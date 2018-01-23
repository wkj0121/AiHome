//
//  Brand.h
//  AiHome
//
//  Created by wkj on 2018/1/14.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Brand : NSObject

/** 设备类型 */
@property (nonatomic, strong) NSString *brandName;
/** 设备品牌型号对象数组 */
@property (nonatomic, strong) NSArray<NSString *> *versions;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
+ (instancetype)brandWithDictionary:(NSDictionary *)dict;

@end
