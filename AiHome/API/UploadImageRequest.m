//
//  FKLoginRequest.m
//  FXXKBaseMVVM
//
//  Created by 梁宪松 on 2017/12/11.
//  Copyright © 2017年 madao. All rights reserved.
//

#import "UploadImageRequest.h"
#import "AFURLRequestSerialization.h"

@implementation UploadImageRequest
{
    NSData *_imageData;
    NSString *_imageName;
    NSString *_imageType;
}

- (id)initWithImageInfo:(NSData *)imageData name:(NSString *)imageName type:(NSString *)imageType {
    self = [super init];
    if (self) {
        _imageData = imageData;
        _imageName = imageName;
        _imageType = imageType;
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

- (NSString *)requestUrl {
    return @"/xk/user/upload";
}

- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        NSString *formKey = @"file";
        NSString *fileName = [[NSString alloc] initWithFormat:@"%@.%@",_imageName,_imageType];
        NSString *type = [[NSString alloc] initWithFormat:@"image/%@",_imageType];
        [formData appendPartWithFileData:_imageData name:formKey fileName:fileName mimeType:type];
    };
}

@end
