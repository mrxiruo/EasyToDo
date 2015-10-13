//
//  EventDetailViewController.h
//  EasyToDo
//
//  Created by XiRuo on 15/10/11.
//  Copyright © 2015年 Xiruo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailViewController : UIViewController

@property (strong, nonatomic) ToDoEventModel *eventModel;

@property (assign, nonatomic) BOOL isAddNewEvent;

@property (assign, nonatomic) NSInteger currentEventRow;

@property (copy, nonatomic) void(^finishEditEventBlock)(BOOL isAddNewEvent, NSInteger currentEventRow, ToDoEventModel *currentEvent);

@end
