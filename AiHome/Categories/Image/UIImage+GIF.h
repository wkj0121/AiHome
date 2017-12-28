//
//  UIImage+GIF.h
//  ConnectedHome
//
//  Created by wkj on 2017/12/12.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GIF)

+ (UIImage *)HT_animatedGIFNamed:(NSString *)name;

+ (UIImage *)HT_animatedGIFWithData:(NSData *)data;

- (UIImage *)HT_animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end
