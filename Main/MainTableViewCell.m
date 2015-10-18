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
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeEvent:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipe];
}

- (void)setEventModel:(ToDoEventModel *)eventModel
{
    self.eventNameLabel.text = eventModel.eventName;
    NSDate *addedDate = [NSDate dateWithTimeIntervalSince1970:[eventModel.eventAddedTime doubleValue]];
    self.eventAddedTimeLabel.text = [NSString stringWithFormat:@"%@",[addedDate getIntervalDisplayDateString]];
    self.eventRemindTimeLabel.text = [[NSDate dateWithTimeIntervalSince1970:[eventModel.eventRemindTime doubleValue]] getDateStringInMessageList];
}

- (void)swipeEvent:(UISwipeGestureRecognizer *)sender
{
    DLog(@"右滑");
    self.backgroundColor = [UIColor yellowColor];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
