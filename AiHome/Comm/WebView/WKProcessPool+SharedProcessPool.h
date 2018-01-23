//
//  WKProcessPool+SharedProcessPool.h
//  AiHome
//
//  Created by wkj on 2018/1/22.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WebKit/WebKit.h>

@interface WKProcessPool (SharedProcessPool)

+ (WKProcessPool*)sharedProcessPool;

@end
