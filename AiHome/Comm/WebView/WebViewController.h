//
//  WebViewController.h
//  ConnectedHome
//
//  Created by wkj on 2017/12/13.
//  Copyright © 2017年 华通晟云. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<FKViewControllerProtocol>

/** urlString */
@property (nonatomic, copy) NSString *urlString;

@end
