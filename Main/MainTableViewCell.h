//
//  MainTableViewCell.h
//  EasyToDo
//
//  Created by XiRuo on 15/10/10.
//  Copyright © 2015年 Xiruo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoEventModel.h"

@interface MainTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *eventRemindTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventAddedTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;

@property (strong, nonatomic) ToDoEventModel *eventModel;

@end
