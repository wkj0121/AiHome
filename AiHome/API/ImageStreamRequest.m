//
//  FKLoginRequest.m
//  FXXKBaseMVVM
//
//  Created by 梁宪松 on 2017/12/11.
//  Copyright © 2017年 madao. All rights reserved.
//

#import "ImageStreamRequest.h"

@implementation ImageStreamRequest
{
    NSString *_url;
}

- (id)initWithImageUrl:(NSString *)url
{
    if (self = [super init]) {
        _url = url;
    }
    return self;
}

- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodGET;
}

- (YTKResponseSerializerType)responseSerializerType
{
    return YTKResponseSerializerTypeHTTP;
}

- (BOOL)statusCodeValidator
{
    return YES;
}

- (NSString *)requestUrl {
    return @"/xk/user/download";
}


- (id)requestArgument {
    return @{
             @"filename":_url
             };
}

@end
