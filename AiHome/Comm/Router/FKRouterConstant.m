//
//  FKRouterConstant.m
//  FXXKBaseMVVM
//
//  Created by 梁宪松 on 2017/12/9.
//  Copyright © 2017年 FKao. All rights reserved.
//

#import "FKRouterConstant.h"

NSString *const FKControllerNameRouteParam = @"viewController";

#pragma mark - 路由模式

NSString *const FKDefaultRouteSchema = @"AiHome";
NSString *const FKHTTPRouteSchema = @"http";
NSString *const FKHTTPsRouteSchema = @"https";
// ----
NSString *const FKComponentsCallBackHandlerRouteSchema = @"AppCallBack";
NSString *const FKWebHandlerRouteSchema = @"Seekco";
NSString *const FKUnknownHandlerRouteSchema = @"UnKnown";

#pragma mark - 路由表

NSString *const FKNavPushRoute = @"/com_seekco_navPush/:viewController";
NSString *const FKNavPresentRoute = @"/com_seekco_navPresent/:viewController";
NSString *const FKNavStoryBoardPushRoute = @"/com_seekco_navStoryboardPush/:viewController";
NSString *const FKComponentsCallBackRoute = @"/com_seekco_callBack/*";

#pragma mark - 应用内路由表
NSString *const NavPushRouteURL =  @"AiHome://com_seekco_navPush/";
NSString *const NavPresentRouteURL = @"AiHome://com_seekco_navPresent/";
NSString *const NavStoryBoardPushRouteURL = @"AiHome://com_seekco_navStoryboardPush/";
NSString *const ComponentsCallBackRouteURL = @"AiHome://com_seekco_callBack/";


