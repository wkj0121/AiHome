//
//  RegGetCodeRequest.m
//  AiHome
//
//  Created by wkj on 2018/1/24.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "RegGetCodeRequest.h"

@implementation RegGetCodeRequest
{
    NSString *_telNum;
}

- (id)initWithTelNum:(NSString *)telNum{
    self = [super init];
    if (self) {
        _telNum = telNum;
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
//    if([request isKindOfClass:RegGetCodeRequest.class]){
//        // 在这里对json数据进行重新格式化
//        return @{
//                 @"message" : jsonResponse[@"token"],
//                 // FKLoginAccessTokenKey : DecodeStringFromDic(jsonResponse, @"token"),
//                 };
//    }
//    return jsonResponse;
//}

- (NSString *)requestUrl {
    
    return @"/xk/user/noteSend";
}


- (id)requestArgument {
    
    return  @{
              @"telNum":_telNum
              };
}


@end
