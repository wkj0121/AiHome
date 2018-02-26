//
//  FKLoginRequest.h
//  FXXKBaseMVVM
//
//  Created by 梁宪松 on 2017/12/11.
//  Copyright © 2017年 madao. All rights reserved.
//

#import "FKBaseRequest.h"

@interface UploadImageRequest : FKBaseRequest

- (id)initWithImageInfo:(NSData *)imageData name:(NSString *)imageName type:(NSString *)imageType;

@end
