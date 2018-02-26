//
//  SaveUserInfo.m
//  FXXKBaseMVVM
//
//  Created by 梁宪松 on 2017/12/11.
//  Copyright © 2017年 madao. All rights reserved.
//

#import "SaveUserInfoRequest.h"

@implementation SaveUserInfoRequest
{
    NSDictionary *_userInfo;
}

- (id)initWithUserInfo:(NSDictionary *)userInfo
{
    self = [super init];
    if (self) {
        _userInfo = userInfo;
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
    return @"/xk/user/save";
}


- (id)requestArgument {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_userInfo options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        return @{@"userInfo": @""};
    } else {
        return @{@"userInfo": [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]};
    }
}

@end
