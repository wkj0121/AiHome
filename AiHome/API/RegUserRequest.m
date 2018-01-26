//
//  RegUserRequest.m
//  AiHome
//
//  Created by wkj on 2018/1/24.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "RegUserRequest.h"

@implementation RegUserRequest
{
    NSString *_telNum;
    NSString *_password;
    NSString *_code;
}

- (id)initWithTelNum:(NSString *)telNum password:(NSString *)password code:(NSString *)code{
    self = [super init];
    if (self) {
        _telNum = telNum;
        _password = password;
        _code = code;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (YTKResponseSerializerType)responseSerializerType
{
    return YTKResponseSerializerTypeJSON;
}

- (BOOL)statusCodeValidator
{
    return YES;
}

//// 可以在这里对response 数据进行重新格式化， 也可以使用delegate 设置 reformattor
//- (id)reformJSONResponse:(id)jsonResponse
//{
//
//}

- (NSString *)requestUrl {

    return @"/xk/user/register";
}


- (id)requestArgument {
    
    return  @{
              @"telNum":_telNum,
              @"password":_password,
              @"code":_code
              };
}


@end
