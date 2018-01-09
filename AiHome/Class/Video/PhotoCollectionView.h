//
//  PhotoCollectionView.h
//  AiHome
//
//  Created by wkj on 2017/12/23.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionView : UICollectionView
/**
 *  @frame: collectionView的frame
 *
 *  @layout: UICollectionViewFlowLayout的属性 这次放在外界设置了，比较方便
 *
 *  @image: 本地图片数组(NSArray<UIImage *> *) 或者网络url的字符串(NSArray<NSString *> *)
 *
 */
- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout withView:(NSArray *)viewArray;
@end
