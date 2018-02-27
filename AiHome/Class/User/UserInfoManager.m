//
//  UserInfoManager.m
//  AiHome
//
//  Created by wkj on 2018/1/27.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "UserInfoManager.h"
#import "ImageStreamRequest.h"
#import <objc/runtime.h>
static UserInfoManager *userInfo;
@implementation UserInfoManager

#pragma mark-系统方法（此时将方法进行交换）
+ (void)load{
    
    //将属性的所有setter、getter方法与自定义的方法互换
    unsigned int count = 0;
    Ivar *varList = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i ++) {
        
        Ivar ivar = varList[i];
        //获取属性名称
        const char *attr = ivar_getName(ivar);
        NSString *attriName = [NSString stringWithFormat:@"%s",attr];
        attriName = [attriName substringFromIndex:1];
        NSString *firstAttriName = [attriName substringToIndex:1];
        firstAttriName = [firstAttriName uppercaseString];
        NSString *lastAttriName = [attriName substringFromIndex:1];
        //构造原setter方法
        SEL originalSetSelector = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:",firstAttriName,lastAttriName]);
        Method originalSetMethod = class_getInstanceMethod([self class], originalSetSelector);
        
        //构造原getter方法
        SEL originalGetSelector = NSSelectorFromString(attriName);
        Method originalGetMethod = class_getInstanceMethod([self class], originalGetSelector);
        
        //新setter方法
        SEL newSetSelector = @selector(setMyAttribute:);
        Method newSetMethod = class_getInstanceMethod([self class], newSetSelector);
        IMP newSetIMP = method_getImplementation(newSetMethod);
        //新getter方法
        SEL newGetSelector = @selector(getAttribute);
        Method newGetMethod = class_getInstanceMethod([self class], newGetSelector);
        IMP newGetIMP = method_getImplementation(newGetMethod);
        
        //Method Swizzling
        method_setImplementation(originalSetMethod, newSetIMP);
        method_setImplementation(originalGetMethod, newGetIMP);
        
    }
    
}

#pragma mark-自定义setter方法（将属性值都存储到用户偏好设置）
- (void)setMyAttribute:(id)attribute{
    
    //获取调用的方法名称
    NSString *selectorString = NSStringFromSelector(_cmd);
    
    //对set方法进行属性字段的解析,并存储到用户偏好设置表
    NSString *attr = [selectorString substringFromIndex:3];
    attr = [attr substringToIndex:[attr length]-1];
    //对首字符进行小写
    NSString *firstChar = [attr substringToIndex:1];
    firstChar = [firstChar lowercaseString];
    NSString *lastAttri = [NSString stringWithFormat:@"%@%@",firstChar,[attr substringFromIndex:1]];
    [[NSUserDefaults standardUserDefaults]setObject:attribute forKey:lastAttri];
    
}

#pragma mark-自定义的getter方法（将属性值从用户偏好设置中取出）
- (id)getAttribute{
    
    //获取方法名
    NSString *selectorString = NSStringFromSelector(_cmd);
    
    NSString *result = [[NSUserDefaults standardUserDefaults] objectForKey:selectorString];
    if ([result isEqual:[NSNull null]]) {
        result = nil;
    }
    return result;
    
}

#pragma mark-初始化工具类
+ (instancetype)shareUser{
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        userInfo = [[UserInfoManager alloc]init];
    });
    
    return userInfo;
}

#pragma mark-配置数据
+ (void)configInfo:(NSDictionary *)infoDic{
    UserInfoManager *manager = [UserInfoManager shareUser];
    //字典转模型
    [manager setValuesForKeysWithDictionary:infoDic];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    //将返回值中的null转为""，才可以存储
    [infoDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if([key isEqualToString:@"headImage"] && ![obj isKindOfClass:[NSNull class]]){
            NSArray *array = [userInfo.headImage componentsSeparatedByString:@"/"];
            NSString * imageUrl = [array lastObject];
            [dic setValue:imageUrl forKey:key];
        }else if([key isEqualToString:@"birthday"] && ![obj isKindOfClass:[NSNull class]]){
            NSInteger timestamp = [[infoDic valueForKey:@"birthday"] integerValue];
            NSDate *birthDate = [NSDate dateWithTimeIntervalSince1970:timestamp/1000];
            manager.birthday = birthDate;
            [dic setValue:obj forKey:key];
        }else{
            [dic setValue:([obj isKindOfClass:[NSNull class]] ? @"" : obj) forKey:key];
        }
    }];
    NSString *imageUrl = [dic valueForKey:@"headImage"];
    //设置默认头像
    manager.headImageData = UIImagePNGRepresentation([UIImage imageNamed:@"head"]);
    //如果未加载过头像
    NSData *tempData = [[NSUserDefaults standardUserDefaults] valueForKey:@"headData"];
    if([tempData isKindOfClass:[NSNull class]] || tempData == nil){
        if(![imageUrl isEqualToString:@""] && ![imageUrl isKindOfClass:[NSNull class]]){
            ImageStreamRequest *api = [[ImageStreamRequest alloc] initWithImageUrl:imageUrl];
            [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
                NSData *responseData = [request responseData];
                NSInteger status = request.responseStatusCode;
                if (200 == status) {
                    manager.headImageData = [request responseData];
                }
                [[NSUserDefaults standardUserDefaults] setObject:manager.headImageData forKey:@"headData"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                [[NSUserDefaults standardUserDefaults] setObject:manager.headImageData forKey:@"headData"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }];
        }
    }else{
        manager.headImageData = tempData;
    }
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"UserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        UserInfoManager *manager = [UserInfoManager shareUser];
        manager.uuid = value;
    }
}

#pragma mark-用户登出操作
+ (void)loginOut{
    
    //清除本地信息
    [self cleanLocalInfo];
    
    /*
     *
     如果业务逻辑上需要将用户登出的状态通知到服务器；在此处进行项目的网络操作
     network handle
     *
     */
    
}

//清除存储在用户偏好设置中的所有用户信息
+ (void)cleanLocalInfo{
    
    NSArray *allAttribute =  [self getAllProperties];
    for (NSString *attribute in allAttribute) {
        
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:attribute];
        
    }
    
}

//获取用户信息类的所有属性
+ (NSArray *)getAllProperties
{
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}


@end
