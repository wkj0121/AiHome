//
//  MsgViewController.m
//  AiHome
//
//  Created by wkj on 2017/12/24.
//  Copyright © 2017年 华通晟云. All rights reserved.
//
#import "MsgViewController2.h"
#import "LCGridData.h"
#define kGridRowNum 3
#define kGridColumnNum 2
#define kNormalStatusHeight (20)
#define kPhoneVerticalStatusHeight (20)
#define kZero 0

//@implementation UIColor (Extensions)
//
//
//+ (instancetype)randomColor {
//
//    CGFloat red = arc4random_uniform(255) / 255.0;
//    CGFloat green = arc4random_uniform(255) / 255.0;
//    CGFloat blue = arc4random_uniform(255) / 255.0;
//    return [self colorWithRed:red green:green blue:blue alpha:1.0];
//}
//
//@end

@interface MsgViewController2()

@end

@implementation MsgViewController2

@synthesize scroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)touchAction:(NSString *)sender
{
    NSLog(@"touch:%@",sender);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Message";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithCapacity:12];
    for (int i = 0; i < 20; i++)
    {
        NSString *image = nil;
        if (i % 2) {
            image = @"lock.png";
        }
        else  if (i % 3) {
            image = @"camera.png";
        }
        else
        {
            image = @"gas.png";
        }
        LCGridData *data = [[LCGridData alloc]initWith:image label:nil];
//        LCGridData *data = [[LCGridData alloc]initWith:image label:[NSString stringWithFormat:@"test%i",i+1]];
        [array addObject:data];
//        [data release];
    }
    
    CGRect newRect = self.view.bounds;
    
    _scroll = [[LCGridView alloc]initWithFrame:newRect withSource:array withRowNum:kGridRowNum withColumnNum:kGridColumnNum isPageControl:YES withBgImgName:@"gridBG"];
    _scroll.delegate = self;
    [self.view addSubview:_scroll];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//
//}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self setFrame:self.view withOrientation:toInterfaceOrientation];
    [self setupFrame];
}

- (void)setupFrame
{
    _scroll.frame = self.view.frame;
    [_scroll setupFrame];
    
}

- (void)setFrame:(UIView *)view withOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    float width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    float height = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            view.frame = CGRectMake(kZero, kZero, width>height?width:height, (width<height?width:height)-kPhoneVerticalStatusHeight);
        }
        else
        {
            view.frame = CGRectMake(kZero, kZero, width>height?width:height, (width<height?width:height)-kNormalStatusHeight);
        }
    }
    else
    {
        view.frame = CGRectMake(kZero, kZero, (width<height?width:height), (width>height?width:height)-kNormalStatusHeight);
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
