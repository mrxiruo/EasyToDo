//
//  NSDate+EasyToDo.m
//  EasyToDo
//
//  Created by XiRuo on 15/10/14.
//  Copyright © 2015年 Xiruo. All rights reserved.
//

#import "NSDate+EasyToDo.h"

@implementation NSDate (EasyToDo)

- (NSString *)getDateStringInMessageList
{
    NSDate *now = [NSDate date];
    static NSCalendar *gregorian;
    if (gregorian == nil) gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil) dateFormatter = [[NSDateFormatter alloc] init];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
    | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *compDate = [gregorian components:unitFlags fromDate:self];
    NSDateComponents *compNow = [gregorian components:unitFlags fromDate:now];
    
    if (compDate.year == compNow.year && compDate.month == compNow.month)
    {
        if (compDate.day == compNow.day)//今天
        {
            [dateFormatter setDateFormat:@"HH:mm"];
            NSString *strDate = [dateFormatter stringFromDate:self];
            return NSLocalizedString(strDate, @"");
        }
        else if (compDate.day == compNow.day - 1)//昨天
        {
            return NSLocalizedString(@"昨天", @"");
        }
    }
    
    [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:self];
    return NSLocalizedString(strDate, @"");
}


- (NSString *)getIntervalDisplayDateString
{
    NSDate *now = [NSDate date];
    
    static NSCalendar *gregorian;
    if (gregorian == nil) gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    static NSDateFormatter *dateFormatter = nil;
    if (dateFormatter == nil){
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit |
                             NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:self toDate:now options:0];
    
    NSTimeInterval toNowInterval = [now timeIntervalSinceDate:self];
    if (toNowInterval < 0) {
        return NSLocalizedString(@"刚刚", @"");
    }
    if ([components year]) {
        return [NSString stringWithFormat:@"%30%@", NSLocalizedString(@"天前", @"")];
    } else if ([components day] && [components day] <= 30) {
        return [NSString stringWithFormat:@"%ld%@", (long)[components day], NSLocalizedString(@"天前", @"")];
    } else if ([components hour]) {
        NSString *hourAgoStr = @"小时前";
        if ([components hour] < 2) {
            hourAgoStr = @"小时前";
        }
        return [NSString stringWithFormat:@"%ld%@", (long)[components hour], NSLocalizedString(hourAgoStr, @"")];
    } else if ([components minute]) {
        NSString *minuteAgoStr = @"分钟前";
        if ([components minute] < 2) {
            minuteAgoStr = @"分钟前";
        }
        return [NSString stringWithFormat:@"%ld%@", (long)[components minute], NSLocalizedString(minuteAgoStr, @"")];
    } else if ([components second]) {
        NSString *secondAgoStr = @"秒前";
        if ([components second] < 2) {
            secondAgoStr = @"秒前";
        }
        return [NSString stringWithFormat:@"%ld%@", (long)[components second], NSLocalizedString(secondAgoStr, @"")];
    }
    
    return NSLocalizedString(@"刚刚", @"");
}


@end
