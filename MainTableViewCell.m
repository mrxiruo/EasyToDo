//
//  MainTableViewCell.m
//  EasyToDo
//
//  Created by XiRuo on 15/10/10.
//  Copyright © 2015年 Xiruo. All rights reserved.
//

#import "MainTableViewCell.h"

@implementation MainTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setEventModel:(ToDoEventModel *)eventModel
{
    self.eventNameLabel.text = [NSString stringWithFormat:@"%@, %@",eventModel.eventName, eventModel.eventAddedTime];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
