//
//  NSString+EasyToDo.m
//  EasyToDo
//
//  Created by XiRuo on 15/10/18.
//  Copyright © 2015年 Xiruo. All rights reserved.
//

#import "NSString+EasyToDo.h"

@implementation NSString (EasyToDo)

-(NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
