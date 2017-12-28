//
//  MsgViewController.m
//  AiHome
//
//  Created by wkj on 2017/12/24.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import "MsgViewController.h"
#import "QHCollectionViewNine.h"

@interface MsgViewController()

@end

@implementation MsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Message";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
//    self.view.backgroundColor = [UIColor grayColor];
    
//    UIImage *image1 = [UIImage imageNamed:@"lock"];
//    UIImage *image2 = [UIImage imageNamed:@"camera"];
//    UIImage *image3 = [UIImage imageNamed:@"gas"];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lock"]];
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"camera"]];
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"light"]];
    UIImageView *imageView4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"alarm"]];
    UIImageView *imageView5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"system"]];
    UIImageView *imageView6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pm25"]];
    NSArray *viewArray = @[imageView1, imageView2, imageView3, imageView4, imageView5, imageView6];
    
    [self.view addSubview:[self setupBoxView:viewArray withRowNum:3 withColumnNum:2 withSpace:5.0]];
}

-(QHCollectionViewNine *)setupBoxView:(NSArray *)viewArray withRowNum:(NSInteger)rowNum withColumnNum:(NSInteger)columnNum withSpace:(CGFloat)space {
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((self.view.frame.size.width - space*(columnNum+1)) / columnNum, (self.view.frame.size.height - statusBarHeight -navBarHeight - tabBarHeight - space*(rowNum+1)) / rowNum);
    layout.minimumLineSpacing = space; // 竖
    layout.minimumInteritemSpacing = 0.0; // 横
    layout.sectionInset = UIEdgeInsetsMake(space, space, space, space);
    
    QHCollectionViewNine *nineView = [[QHCollectionViewNine alloc] initWithFrame:CGRectMake(0, statusBarHeight+navBarHeight, self.view.frame.size.width, self.view.frame.size.height - statusBarHeight-navBarHeight - tabBarHeight) collectionViewLayout:layout withView:viewArray];
    return nineView;
}

@end
