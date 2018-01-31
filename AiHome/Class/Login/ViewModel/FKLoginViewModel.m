//
//  FKLoginViewModel.m
//  FXXKBaseMVVM
//
//  Created by 梁宪松 on 2017/12/10.
//  Copyright © 2017年 madao. All rights reserved.
//

#import "FKLoginViewModel.h"
#import "FKLoginRequest.h"

@interface FKLoginViewModel()<FKBaseRequestFeformDelegate, YTKRequestDelegate>

@end
@implementation FKLoginViewModel

- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super initWithParams:params]) {
        
    }
    return self;
}

/**
 viewModel 初始化属性
 */
- (void)fk_initializeForViewModel
{
    _cellTitleArray = @[
                        @"账户",
                        @"密码",
                        @""
                        ];
    
    
    
    // 是否可以登录
    RAC(self, isLoginEnable) =  [[RACSignal combineLatest:@[
                                                            RACObserve(self, userAccount),
                                                            RACObserve(self, password)]
                                  ]
                                 map:^id _Nullable(RACTuple * _Nullable value) {
                                     RACTupleUnpack(NSString *account, NSString *pwd) = value;
                                     return @(account && pwd && account.length && pwd.length);
                                 }];
    
}

#pragma mark - Getter
- (RACCommand *)loginCommand
{
    if (!_loginCommand) {
        @weakify(self);
        _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            FKLoginRequest *loginRequest = [[FKLoginRequest alloc] initWithUsr:self.userAccount pwd:self.password];
            return [[[loginRequest rac_requestSignal] doNext:^(id _Nullable x) {
                NSDictionary* result = (NSDictionary*)x;
                [[NSUserDefaults standardUserDefaults] setBool:([result objectForKey:@"code"] ? NO : YES) forKey:@"isLogin"];
            }] materialize];
        }];
    }
    return _loginCommand;
}

#pragma mark - FKBaseRequestFeformDelegate
- (id)request:(FKBaseRequest *)request reformJSONResponse:(id)jsonResponse
{
    if([request isKindOfClass:FKLoginRequest.class]){
        // 在这里对json数据进行重新格式化
        return @{
                 FKLoginAccessTokenKey : jsonResponse[@"token"],
                 // FKLoginAccessTokenKey : DecodeStringFromDic(jsonResponse, @"token"),
                 };
    }
    return jsonResponse;
}

#pragma mark - YTKRequestDelegate
- (void)requestFinished:(__kindof YTKBaseRequest *)request
{
}

- (void)requestFailed:(__kindof YTKBaseRequest *)request
{
    // do something
}
@end
