//
//  MoreTableViewCell.m
//  AiHome
//
//  Created by macbook on 2018/2/27.
//  Copyright © 2018年 华通晟云. All rights reserved.
//

#import "MoreTableViewCell.h"

@implementation MoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if([self.delegate respondsToSelector:@selector(textfieldTextWasChanged:withParentCell:)]) {
        [self.delegate textfieldTextWasChanged:textField.text withParentCell:self];
    }
    return [textField resignFirstResponder];
}

@end
