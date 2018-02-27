//
//  MoreTableViewCell.h
//  AiHome
//
//  Created by macbook on 2018/2/27.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoreTableViewCell;
// 自定义协议
@protocol MoreTableViewCellDelegate <NSObject>

- (void)textfieldTextWasChanged:(NSString *)newText withParentCell:(MoreTableViewCell *)parentCell;

@end


@interface MoreTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet UILabel *normalLabel;

@property(nonatomic, weak) id <MoreTableViewCellDelegate> delegate;
@property(nonatomic, weak) NSIndexPath *indexPath;

@end
