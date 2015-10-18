//
//  NSDate+EasyToDo.h
//  EasyToDo
//
//  Created by XiRuo on 15/10/14.
//  Copyright © 2015年 Xiruo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (EasyToDo)


/**
 *  获取以天为间隔的时间时间显示格式,例如昨天,今天,或精确时间14:25等
 */
- (NSString *)getDateStringInMessageList;


/**
 *  获取间隔更为精确例如2分钟前,2秒前的时间显示格式
 */
- (NSString *)getIntervalDisplayDateString;




@end
