//
//  ToDoEventModel.h
//  EasyToDo
//
//  Created by XiRuo on 15/10/10.
//  Copyright © 2015年 Xiruo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoEventModel : NSObject

@property (assign, nonatomic) NSInteger eventId;

@property (copy, nonatomic) NSString *eventName;

@property (copy, nonatomic) NSString *eventDescription;


@property (copy, nonatomic) NSString *eventAddedTime;

@property (copy, nonatomic) NSString *eventRemindTime;

@end
