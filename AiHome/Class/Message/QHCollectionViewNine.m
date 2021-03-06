//
//  QHCollectionViewNine.m
//  AiHome
//
//  Created by wkj on 2017/12/23.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import "QHCollectionViewNine.h"

@interface QHCollectionViewNine ()<UICollectionViewDelegate, UICollectionViewDataSource>

    @property (nonatomic, strong) NSArray *viewArr;
    @property (nonatomic, strong) UICollectionViewFlowLayout *Layout;

@end

@implementation QHCollectionViewNine
    // 创建常量标识符
    static NSString *identifier = @"MessageViewCell";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withView:(NSArray *)viewArray {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor whiteColor];
        _viewArr = viewArray;
        _Layout = (UICollectionViewFlowLayout *)layout;
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        self.delegate = self;
        self.dataSource = self;
        // 注册唯一标识
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
//        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    }
    return self;
}
#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIView *uiV = nil;
    if ([NSStringFromClass([_viewArr[indexPath.row] class]) isEqualToString:@"UIImage"]) { // 如果是UIImage数组 即 本地图片
        UIView *uiV = [[UIImageView alloc] initWithImage:_viewArr[indexPath.row]];
        uiV.contentMode =  UIViewContentModeCenter;
    } else if([NSStringFromClass([_viewArr[indexPath.row] class]) isEqualToString:@"UIImageView"]){
        uiV = _viewArr[indexPath.row];
        uiV.contentMode =  UIViewContentModeCenter;
    } else if([NSStringFromClass([_viewArr[indexPath.row] class]) isEqualToString:@"PM25View"]){
        uiV = _viewArr[indexPath.row];
//        uiV.backgroundColor = [UIColor greenColor];
    } else {
        uiV = _viewArr[indexPath.row];
    }
//    CGRect imageFrame = imageV.frame;
//    imageFrame.size = _Layout.itemSize;
//    imageV.frame = imageFrame;
//    cell.backgroundColor = [UIColor greenColor];
//    imageV.backgroundColor = [UIColor redColor];
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0].CGColor;
    [cell.contentView addSubview:uiV];
    [uiV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(cell.contentView.mas_width);
        make.height.equalTo(cell.contentView.mas_height);
        make.centerX.equalTo(cell.contentView.mas_centerX);
        make.centerY.equalTo(cell.contentView.mas_centerY);
    }];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld分区---%ldItem--对象--%@ 被点击了！", indexPath.section, indexPath.row, _viewArr[indexPath.row]);
}

@end
