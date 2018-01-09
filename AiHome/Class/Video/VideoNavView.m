//
//  VideoNavView.m
//  AiHome
//
//  Created by wkj on 2018/1/9.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoNavView.h"

@interface VideoNavView()

@end

@implementation VideoNavView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        /* 添加子控件的代码*/
        //        self.imageView = [[UIImageView alloc]init];
        //        [self addSubview:self.imageView];
        self.backgroundColor = COLOR_WHITE;
        [self addSubview:self.historyBtn];
        [self addSubview:self.photosBtn];
        [self addSubview:self.videoBtn];
    }
    return self;
}


- (void)layoutSubviews {
    // 一定要调用super的方法
    [super layoutSubviews];
    // 确定子控件的frame（这里得到的self的frame/bounds才是准确的）
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat hMagin = 30;
    CGFloat vMagin = 0;
    CGFloat btnSize =height-2*vMagin;
    self.historyBtn.frame = CGRectMake(hMagin, vMagin, btnSize, btnSize);
    self.photosBtn.frame = CGRectMake(width/2-btnSize/2, vMagin, btnSize, btnSize);
    self.videoBtn.frame = CGRectMake(width-hMagin-btnSize, vMagin, btnSize, btnSize);
//    self.historyBtn.backgroundColor = COLOR_GREEN;
    // button标题的偏移量
    self.historyBtn.titleEdgeInsets = UIEdgeInsetsMake(self.historyBtn.imageView.frame.size.height+5, -self.historyBtn.imageView.bounds.size.width, 0,0);
    // button图片的偏移量
    self.historyBtn.imageEdgeInsets = UIEdgeInsetsMake(0, self.historyBtn.titleLabel.frame.size.width/2, self.historyBtn.titleLabel.frame.size.height+5, -self.historyBtn.titleLabel.frame.size.width/2);
    // button标题的偏移量
    self.photosBtn.titleEdgeInsets = UIEdgeInsetsMake(self.photosBtn.imageView.frame.size.height+5, -self.photosBtn.imageView.bounds.size.width, 0,0);
    // button图片的偏移量
    self.photosBtn.imageEdgeInsets = UIEdgeInsetsMake(0, self.photosBtn.titleLabel.frame.size.width/2, self.photosBtn.titleLabel.frame.size.height+5, -self.photosBtn.titleLabel.frame.size.width/2);
    // button标题的偏移量
    self.videoBtn.titleEdgeInsets = UIEdgeInsetsMake(self.videoBtn.imageView.frame.size.height+5, -self.videoBtn.imageView.bounds.size.width, 0,0);
    // button图片的偏移量
    self.videoBtn.imageEdgeInsets = UIEdgeInsetsMake(0, self.videoBtn.titleLabel.frame.size.width/2, self.videoBtn.titleLabel.frame.size.height+5, -self.videoBtn.titleLabel.frame.size.width/2);
    //设置下边线
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1);
    layer.backgroundColor = COLOR_RGB(239, 239, 239).CGColor;
    [self.layer addSublayer:layer];
}


-(UIButton *)historyBtn{
    if (!_historyBtn) {
        UIButton *historyBtn = [[UIButton alloc]init];
        [historyBtn setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
//        historyBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [historyBtn setTitle:@"历史查询" forState:UIControlStateNormal];
        [historyBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
//        historyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        historyBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        self.historyBtn = historyBtn;
    }
    return _historyBtn;
}

-(UIButton *)photosBtn{
    if (!_photosBtn) {
        UIButton *photosBtn = [[UIButton alloc]init];
        [photosBtn setImage:[UIImage imageNamed:@"photoAlbum"] forState:UIControlStateNormal];
        [photosBtn setTitle:@"相册" forState:UIControlStateNormal];
        [photosBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
//        photosBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        photosBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        self.photosBtn = photosBtn;
    }
    return _photosBtn;
}

-(UIButton *)videoBtn{
    if (!_videoBtn) {
        UIButton *videoBtn = [[UIButton alloc]init];
        [videoBtn setImage:[UIImage imageNamed:@"camera_normal"] forState:UIControlStateNormal];
        [videoBtn setTitle:@"实时监控" forState:UIControlStateNormal];
        [videoBtn setTitleColor:THEMECOLOR forState:UIControlStateNormal];
//        videoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        videoBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        self.videoBtn = videoBtn;
    }
    return _videoBtn;
}


@end
