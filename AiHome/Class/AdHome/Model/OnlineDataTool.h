//
//  OnlineDataTool.h
//  ConnectedHome
//
//  Created by wkj on 2017/12/13.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PromotionItem;
@interface OnlineDataTool : NSObject

/**
 * 加载闪屏也广告
 */
- (void)loadPromotionPageData;


/**
 * 返回广告数据模型
 */
- (PromotionItem *)getPromotionItem;


@end
