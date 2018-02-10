//
//  FKLoginRequest.m
//  FXXKBaseMVVM
//
//  Created by 梁宪松 on 2017/12/11.
//  Copyright © 2017年 madao. All rights reserved.
//

#import "FKLogoutRequest.h"

@implementation FKLogoutRequest
{
    NSString *_usr;
    NSString *_pwd;
    
}

- (id)initWithUsr:(NSString *)usr pwd:(NSString *)pwd
{
    self = [super init];
    if (self) {
        _usr = usr;
        _pwd = pwd;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

- (YTKResponseSerializerType)responseSerializerType
{
//    return YTKResponseSerializerTypeHTTP;
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
    return @"/xk/user/login";
}


- (id)requestArgument {
    
    NSDictionary *dic = @{
                            @"userName":_usr,
                            @"userPassword":_pwd
                        };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if (!jsonData) {
        return @{@"userInfo": @""};
    } else {
        return @{@"userInfo": [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]};
    }
}

@end
