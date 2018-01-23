//
//  RegUserRequest.h
//  AiHome
//
//  Created by wkj on 2018/1/24.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "FKBaseRequest.h"

@interface RegUserRequest : FKBaseRequest

- (id)initWithTelNum:(NSString *)telNum code:(NSString *)code;

@end
