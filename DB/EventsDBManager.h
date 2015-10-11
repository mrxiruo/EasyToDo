//
//  EventsDBManager.h
//  EasyToDo
//
//  Created by XiRuo on 15/10/11.
//  Copyright © 2015年 Xiruo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"

@class ToDoEventModel;

@interface EventsDBManager : NSObject

@property (strong, nonatomic) FMDatabase *eventDataBase;

@property (strong, nonatomic) NSString *dataBasePath;


+ (EventsDBManager*)sharedInstance;

- (BOOL)insertNewEvent:(ToDoEventModel *)event;

- (BOOL)updateEventByNewEvent:(ToDoEventModel *)event;

- (BOOL)deleteEvent:(ToDoEventModel *)event;

- (NSArray *)getAllEvents;


@end
