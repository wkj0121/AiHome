//
//  PromotionItem.h
//  ConnectedHome
//
//  Created by wkj on 2017/12/13.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromotionItem : NSObject
/** urlString */
@property (nonatomic, copy) NSString *urlString;

/** 是否过期 */
@property (nonatomic, assign) BOOL isTimeOut;

@end
