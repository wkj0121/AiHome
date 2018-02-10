//
//  TQViewController.m
//  TQGestureLockViewDemo
//
//  Created by TQTeam on 11/03/2017.
//  Copyright (c) 2017 TQTeam. All rights reserved.
//

#import "TQViewController.h"
#import "TQViewController1.h"
#import "TQViewController2.h"

@interface TQViewController ()

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
@property (nonatomic, strong) UIViewController *rootVC;

@end

@implementation TQViewController

- (instancetype)initWithVC:(UIViewController *)vc
{
    self = [super init];
    _rootVC = vc;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self dataInitialization];
}

- (void)navBarInitialization
{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    backBtn.title = @"返回";
    self.navigationItem.backBarButtonItem = backBtn;
}

- (void)dataInitialization
{
    _titles = [NSMutableArray array];
    _classNames = [NSMutableArray array];
    
    [self addTitle:@"设置手势密码" class:@"TQViewController1"];
    [self addTitle:@"验证手势密码" class:@"TQViewController2"];
}

- (void)addTitle:(NSString *)title class:(NSString *)className
{
    [_titles addObject:title];
    [_classNames addObject:className];
}

- (void)setType:(NSInteger)type
{
    _type = type;
    NSString *className = _classNames[type];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *vc = [[class alloc] initWithVC:_rootVC];
        vc.view.backgroundColor = [UIColor whiteColor];
        vc.navigationItem.title = _titles[type];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

@end

