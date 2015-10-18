//
//  DetailViewController.h
//  EasyToDo
//
//  Created by XiRuo on 15/10/15.
//  Copyright © 2015年 Xiruo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UILabel *remindTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;

@property (strong, nonatomic) ToDoEventModel *eventModel;

@property (assign, nonatomic) BOOL isAddNewEvent;

@property (assign, nonatomic) NSInteger currentEventRow;

@property (copy, nonatomic) void(^finishEditEventBlock)(BOOL isAddNewEvent, NSInteger currentEventRow, ToDoEventModel *currentEvent);

@end
