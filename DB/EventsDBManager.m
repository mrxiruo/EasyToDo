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

#define EVENT_ID        @"eventId"
#define EVENT_TITLE     @"eventTitle"
#define EVENT_DETAIL    @"eventDetail"
#define EVENT_ADD_TIME      @"eventAddTime"
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
    
    //为数据库设置缓存，提高查询效率
    [self.eventDataBase setShouldCacheStatements:YES];
    
    if([self.eventDataBase open]){
        NSString *sqlCreateTable =  [NSString stringWithFormat:
                                     @"CREATE TABLE IF NOT EXISTS '%@'\
                                     ('%@' INTEGER PRIMARY KEY AUTOINCREMENT,\
                                     '%@' TEXT,\
                                     '%@' TEXT, \
                                     '%@' TEXT, \
                                     '%@' TEXT)",\
                                     TABLENAME,\
                                     EVENT_ID,\
                                     EVENT_TITLE,\
                                     EVENT_DETAIL,\
                                     EVENT_ADD_TIME,\
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
    if ([self.eventDataBase open]){
        NSString *insertSql1= [NSString stringWithFormat:
                               @"INSERT INTO '%@' ('%@', '%@', '%@', '%@') VALUES ('%@', '%@', '%@', '%@')",
                               TABLENAME, EVENT_TITLE, EVENT_DETAIL, EVENT_ADD_TIME, EVENT_REMIND_TIME, event.eventName, event.eventDescription, event.eventAddedTime, event.eventRemindTime];
        BOOL res = [self.eventDataBase executeUpdate:insertSql1];
        
        if (!res) {
            DLog(@"error when insert db table");
        } else {
            DLog(@"success to insert db table");
            
            sqlite_int64 eventId = [self.eventDataBase lastInsertRowId];
            event.eventId = eventId;
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
        //可以
        BOOL res = [self.eventDataBase executeUpdate:@"UPDATE TableAllEvents SET eventTitle=?,eventDetail=?,eventRemindTime=? WHERE eventId=?", event.eventName, event.eventDescription, event.eventRemindTime, [NSNumber numberWithInteger:event.eventId]];
        
//        NSString *updateSql = [NSString stringWithFormat:@"UPDATE '%@' SET '%@'='%@','%@'='%@','%@'='%@','%@'='%@' WHERE '%@'='%@'", TABLENAME, EVENT_TITLE, event.eventName,EVENT_DETAIL, event.eventDescription, EVENT_ADD_TIME, event.eventAddedTime, EVENT_REMIND_TIME, event.eventRemindTime, ID, [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:event.eventId]]];
//        BOOL res = [self.eventDataBase executeUpdate:updateSql];
        
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
    //TO DO
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
                          @"SELECT * FROM %@ order by %@ desc",TABLENAME, EVENT_ADD_TIME];
        FMResultSet * rs = [self.eventDataBase executeQuery:sql];
        
        while ([rs next]) {
            ToDoEventModel *model = [[ToDoEventModel alloc] init];
            
            model.eventId = [rs intForColumn:EVENT_ID];
            model.eventName = [rs stringForColumn:EVENT_TITLE];
            model.eventDescription = [rs stringForColumn:EVENT_DETAIL];
            model.eventAddedTime = [rs stringForColumn:EVENT_ADD_TIME];
            model.eventRemindTime = [rs stringForColumn:EVENT_REMIND_TIME];

            [eventsArray addObject:model];
        }
        [self.eventDataBase close];
    }
    
    return [eventsArray copy];
}

@end
