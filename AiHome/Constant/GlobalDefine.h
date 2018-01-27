//
//  GlobalDefine.h
//  AiHome
//
//  Created by wkj on 2017/12/31.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 ====================================================================================================//打印相关
 */
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)

#else

#define NSLog(...)
#define debugMethod()
#endif

#define NSSLog(FORMAT, ...) {\
NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];\
[dateFormatter setDateStyle:NSDateFormatterMediumStyle];\
[dateFormatter setTimeStyle:NSDateFormatterShortStyle];\
[dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SSS"]; \
NSString *str = [dateFormatter stringFromDate:[NSDate date]];\
fprintf(stderr,"%s %s:%d %s\n",[str UTF8String], [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);\
}

/*
 ====================================================================================================//获取屏幕尺寸
 */
#define IS_IOS_VERSION_11         (([[[UIDevice currentDevice]systemVersion]floatValue] >= 11.0)? (YES):(NO))
#define SCREEN_FRAME                ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)
#define NSCREEN_WIDTH               [UIScreen mainScreen].bounds.size.width/375
#define NSCREEN_HEIGHT              [UIScreen mainScreen].bounds.size.height/667

#define NAV_WIDTH                   SCREEN_WIDTH
#define NAV_HEIGHT                  (44)

#define TAB_BAR_WIDTH               SCREEN_WIDTH
#define TAB_BAR_HEIGHT              (48)

//#define STATUS_BAR_HEIGHT           (20)
#define STATUS_BAR_HEIGHT           [[UIApplication sharedApplication] statusBarFrame].size.height

//#define Margin  5
//#define Padding 10
#define iOS7TopMargin 64 //导航栏44，状态栏20
#define ButtonHeight 44
// TabView行高
#define TabViewRowHeight 42.0f
#define TabViewCustomHeadRowHeight 88.0f
#define PI 3.14159265358979323846
/*
 ====================================================================================================//颜色相关1
 */
//1.基础颜色
#define FKTHEMECOLOR  HEX_RGB(0x0177D7)
#define THEMECOLOR  HEX_RGB(0x258482)
#define COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define RandomColor [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1.0];

#define navigationBarColor RGB(67, 199, 176)
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
// 2.获得RGB颜色
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r, g, b)                        RGBA(r, g, b, 1.0f)
/**  */
#define COLOR_BLACK [UIColor blackColor]
/**  */
#define COLOR_DARKGRAY [UIColor darkGrayColor]
/**  */
#define COLOR_LIGHTGRAY [UIColor lightGrayColor]
/**  */
#define COLOR_WHITE [UIColor whiteColor]
/**  */
#define COLOR_GRAY [UIColor grayColor]
/**  */
#define COLOR_RED [UIColor redColor]
/**  */
#define COLOR_GREEN [UIColor greenColor]
/**  */
#define COLOR_BLUE [UIColor blueColor]
/**  */
#define COLOR_CYAN [UIColor cyanColor]
/**  */
#define COLOR_YELLOW [UIColor yellowColor]
/**  */
#define COLOR_MAGENTA [UIColor magentaColor]
/**  */
#define COLOR_ORANGE [UIColor orangeColor]
/**  */
#define COLOR_PURPLE [UIColor purpleColor]
/**  */
#define COLOR_BROWN [UIColor brownColor]
/**  */
#define COLOR_CLEAR [UIColor clearColor]
/*
 ====================================================================================================//颜色相关2
 */
/**  */
#define BLACK_COLOR [UIColor blackColor]
/**  */
#define DARKGRAY_COLOR [UIColor darkGrayColor]
/**  */
#define LIGHTGRAY_COLOR [UIColor lightGrayColor]
/**  */
#define WHITE_COLOR [UIColor whiteColor]
/**  */
#define GRAY_COLOR [UIColor grayColor]
/**  */
#define RED_COLOR [UIColor redColor]
/**  */
#define GREEN_COLOR [UIColor greenColor]
/**  */
#define BLUE_COLOR [UIColor blueColor]
/**  */
#define CYAN_COLOR [UIColor cyanColor]
/**  */
#define YELLOW_COLOR [UIColor yellowColor]
/**  */
#define MAGENTA_COLOR [UIColor magentaColor]
/**  */
#define ORANGE_COLOR [UIColor orangeColor]
/**  */
#define PURPLE_COLOR [UIColor purpleColor]
/**  */
#define BROWN_COLOR [UIColor brownColor]
/**  */
#define CLEAR_COLOR [UIColor clearColor]
/*
 ====================================================================================================//颜色相关3
 */
#define RGB_COLOR(R,G,B)     [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1]
#define RGBA_COLOR(R,G,B,A)  [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]
#define COLOR_RGB(R,G,B)     [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1]
#define COLOR_RGBA(R,G,B,A)  [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]
/** 16进制颜色值，如：#000000 , 注意：在使用的时候hexValue写成：0x000000 */
#define HexColor(hexValue)  [UIColor colorWithRed:((float)(((hexValue) & 0xFF0000) >> 16))/255.0 green:((float)(((hexValue) & 0xFF00) >> 8))/255.0 blue:((float)((hexValue) & 0xFF))/255.0 alpha:1.0]

/*
 ====================================================================================================//版本检查
 */
// 版本检查
#define IOS11_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS10_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS9_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS8_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS7_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS6_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS5_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] compare:@"5.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS4_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] compare:@"4.0" options:NSNumericSearch] != NSOrderedAscending )
#define IOS3_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] compare:@"3.0" options:NSNumericSearch] != NSOrderedAscending )

