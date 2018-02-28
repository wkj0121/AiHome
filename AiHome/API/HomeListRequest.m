//
//  RegUserRequest.m
//  AiHome
//
//  Created by wkj on 2018/1/24.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "HomeListRequest.h"

@implementation HomeListRequest
{
    NSString *_userid;
}

- (id)initWithUserID:(NSString *)userid {
    self = [super init];
    if (self) {
        _userid = userid;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

- (YTKResponseSerializerType)responseSerializerType
{
    return YTKResponseSerializerTypeJSON;
}

- (BOOL)statusCodeValidator
{
    return YES;
}

- (NSString *)requestUrl {
    return [[NSString alloc] initWithFormat:@"/xk/home/%@/list",_userid];
}

@end
