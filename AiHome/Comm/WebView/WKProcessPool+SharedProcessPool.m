//
//  WKProcessPool+SharedProcessPool.m
//  AiHome
//
//  Created by wkj on 2018/1/22.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "WKProcessPool+SharedProcessPool.h"

@implementation WKProcessPool (SharedProcessPool)

+ (WKProcessPool*)sharedProcessPool {
    
    static WKProcessPool* SharedProcessPool;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        SharedProcessPool = [[WKProcessPool alloc] init];
        
    });
    
    return SharedProcessPool;
    
}

@end
