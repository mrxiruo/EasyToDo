//
//  EventsDBManager.m
//  EasyToDo
//
//  Created by XiRuo on 15/10/11.
//  Copyright © 2015年 Xiruo. All rights reserved.
//

#import "EventsDBManager.h"
#import "ToDoEventModel.h"



#define DBNAME    @"events.sqlite"

#define TABLENAME @"TableAllEvents"

#define ID              @"id"
#define EVENT_ID        @"eventId"
#define EVENT_TITLE     @"eventTitle"
#define EVENT_DETAIL    @"eventDetail"
#define EVENT_TIME      @"eventTime"
#define EVENT_REMIND_TIME      @"eventRemindTime"

static dispatch_once_t *once_token_reset;

static EventsDBManager *eventsDBManager;


@implementation EventsDBManager


+ (EventsDBManager *) sharedInstance
{
    static dispatch_once_t onceToken;
    once_token_reset = &onceToken;
    dispatch_once(&onceToken, ^{
        eventsDBManager = [[EventsDBManager alloc] init];
        [eventsDBManager createEventsTable];
//        [dbHelper addObserver:dbHelper forKeyPath:@"unReadMesageCountNumber" options:NSKeyValueObservingOptionNew context:NULL];
    });
    
    return eventsDBManager;
}


#pragma mark - 创建表

-(BOOL)createEventsTable
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    self.dataBasePath = [documents stringByAppendingPathComponent:DBNAME];
    
    self.eventDataBase = [FMDatabase databaseWithPath:self.dataBasePath];
    
    if([self.eventDataBase open]){
        NSString *sqlCreateTable =  [NSString stringWithFormat:
                                     @"CREATE TABLE IF NOT EXISTS '%@'\
                                     ('%@' INTEGER PRIMARY KEY AUTOINCREMENT,\
                                     '%@' INTEGER, \
                                     '%@' TEXT,\
                                     '%@' TEXT, \
                                     '%@' TEXT, \
                                     '%@' BLOB)",\
                                     TABLENAME,\
                                     ID,\
                                     EVENT_ID,\
                                     EVENT_TITLE,\
                                     EVENT_DETAIL,\
                                     EVENT_TIME,\
                                     EVENT_REMIND_TIME];
        BOOL res = [self.eventDataBase executeUpdate:sqlCreateTable];
        if(!res){
            DLog(@"error when creating db table");
        }else{
            DLog(@"success to open db table");
        }
        
        [self.eventDataBase close];
        
        return res;
    }else{
        return NO;
    }
}


#pragma mark - 新建/添加 一条事件

- (BOOL)insertNewEvent:(ToDoEventModel *)event
{
    if ([self.eventDataBase open]) {
        NSData *eventRemindTimedata = event.eventRemindTimeArray ? [NSKeyedArchiver archivedDataWithRootObject:event.eventRemindTimeArray] : nil;
        
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@')",
                               TABLENAME, EVENT_TITLE, EVENT_DETAIL, EVENT_TIME, EVENT_REMIND_TIME, event.eventName, event.eventDescription, event.eventAddedTime, eventRemindTimedata];
        BOOL res = [self.eventDataBase executeUpdate:insertSql1];
        
        if (!res) {
            DLog(@"error when insert db table");
        } else {
            DLog(@"success to insert db table");
        }
        [self.eventDataBase close];
        
        return res;
    }else{
        return NO;
    }
}

#pragma mark - 修改/更新 某一事件

- (BOOL)updateEventByNewEvent:(ToDoEventModel *)event
{
    if ([self.eventDataBase open]) {
        NSData *eventRemindTimedata = event.eventRemindTimeArray ? [NSKeyedArchiver archivedDataWithRootObject:event.eventRemindTimeArray] : nil;

        NSString *updateSql = [NSString stringWithFormat:
                               @"UPDATE '%@' SET '%@' = '%@' '%@' = '%@' '%@' = '%@' '%@' = '%@' WHERE '%@' = '%@'",
                               TABLENAME, EVENT_TITLE, event.eventName, EVENT_DETAIL, event.eventDescription, EVENT_TIME, event.eventAddedTime, EVENT_REMIND_TIME, eventRemindTimedata, EVENT_ID, [NSNumber numberWithInteger:event.eventId]];
        BOOL res = [self.eventDataBase executeUpdate:updateSql];
        if (!res) {
            DLog(@"error when update db table");
        } else {
            DLog(@"success to update db table");
        }
        [self.eventDataBase close];
        
        return res;
    }else{
        return NO;
    }
}


#pragma mark - 删除 某一事件

- (BOOL)deleteEvent:(ToDoEventModel *)event
{
    if ([self.eventDataBase open]) {
        
        NSString *deleteSql = [NSString stringWithFormat:
                               @"delete from %@ where %@ = '%@'",
                               TABLENAME, EVENT_ID, [NSNumber numberWithInteger:event.eventId]];
        BOOL res = [self.eventDataBase executeUpdate:deleteSql];
        
        if (!res) {
            DLog(@"error when delete");
        } else {
            DLog(@"success to delete");
        }
        [self.eventDataBase close];
        
        return res;
    }else{
        return NO;
    }
}


#pragma mark - 获取所有事件

- (NSArray *)getAllEvents
{
    NSMutableArray *eventsArray = [[NSMutableArray alloc] init];
    if([self.eventDataBase open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT * FROM %@ order by eventTime desc",TABLENAME];
        FMResultSet * rs = [self.eventDataBase executeQuery:sql];
        while ([rs next]) {
            int eventId = [rs intForColumn:EVENT_ID];
            NSString * title = [rs stringForColumn:EVENT_TITLE];
            NSString * detail = [rs stringForColumn:EVENT_DETAIL];
            NSString * eventTime = [rs stringForColumn:EVENT_TIME];
            NSData * eventRemindTimeData = [rs dataForColumn:EVENT_REMIND_TIME];
            
            ToDoEventModel *model = [[ToDoEventModel alloc] init];
            model.eventId = eventId;
            model.eventName = title;
            model.eventDescription = detail;
            model.eventAddedTime = eventTime;
            model.eventRemindTimeArray = [NSKeyedUnarchiver unarchiveObjectWithData:eventRemindTimeData];

            [eventsArray addObject:model];
        }
        [self.eventDataBase close];
    }
    
    return [eventsArray copy];
}

@end
