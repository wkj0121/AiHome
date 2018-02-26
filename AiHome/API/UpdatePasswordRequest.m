//
//  SaveUserInfo.m
//  FXXKBaseMVVM
//
//  Created by 梁宪松 on 2017/12/11.
//  Copyright © 2017年 madao. All rights reserved.
//

#import "UpdatePasswordRequest.h"

@implementation UpdatePasswordRequest
{
    NSDictionary *_params;
}

- (id)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if (self) {
        _params = params;
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
    return @"/xk/user/updatePwd";
}

- (id)requestArgument {
    return _params;
}

@end
