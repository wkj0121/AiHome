//
//  TouchIDAuthenticate.h
//  AiHome
//
//  Created by wkj on 2017/12/20.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface TouchIDAuthenticate : NSObject

//@property (nonatomic, assign, readonly) BOOL isVaild;

//发送验证通知
- (void)sendNotice;
//指纹验证
-(void)touchIDAuthenticate;
//评估指纹验证
-(void)evaluateAuthenticate;

@end
