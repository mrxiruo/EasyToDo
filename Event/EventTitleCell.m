//
//  EventTitleCell.m
//  EasyToDo
//
//  Created by XiRuo on 15/10/11.
//  Copyright © 2015年 Xiruo. All rights reserved.
//

#import "EventTitleCell.h"

@implementation EventTitleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTitle:(NSString *)title
{
    self.titleTextField.text = title;
}

@end
