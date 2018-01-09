//
//  PhotoCollectionView.m
//  AiHome
//
//  Created by wkj on 2017/12/23.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import "PhotoCollectionView.h"
#import "UIImageView+WebCache.h"

@interface PhotoCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>

    @property (nonatomic, strong) NSArray *viewArr;
    @property (nonatomic, strong) UICollectionViewFlowLayout *Layout;

@end

@implementation PhotoCollectionView
    // 创建常量标识符
    static NSString *identifier = @"videoPhotosCell";

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withView:(NSArray *)viewArray {
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        self.backgroundColor = [UIColor whiteColor];
        _viewArr = viewArray;
        _Layout = (UICollectionViewFlowLayout *)layout;
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
        self.delegate = self;
        self.dataSource = self;
        // 注册唯一标识
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    }
    return self;
}
#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 从重用队列里查找可重用的cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    // 第三方Image请求
    UIImageView *imv = [[UIImageView alloc] init];
    [imv sd_setImageWithURL:_viewArr[indexPath.row] placeholderImage:[UIImage imageNamed:@"u=2312994427,1092373000&fm=21&gp=0.jpg"] options:SDWebImageRetryFailed];
    cell.backgroundView = imv;
    
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0].CGColor;
//    [cell.contentView addSubview:uiV];
//    [uiV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(cell.contentView.mas_width);
//        make.height.equalTo(cell.contentView.mas_height);
//        make.centerX.equalTo(cell.contentView.mas_centerX);
//        make.centerY.equalTo(cell.contentView.mas_centerY);
//    }];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld分区---%ldItem--对象--%@ 被点击了！", indexPath.section, indexPath.row, _viewArr[indexPath.row]);
}

@end
