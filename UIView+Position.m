//
//  UIView+Position.m
//  EasyToDo
//
//  Created by XiRuo on 15/10/15.
//  Copyright © 2015年 Xiruo. All rights reserved.
//

#import "UIView+Position.h"

@implementation UIView (Position)

// getter
- (CGFloat)top
{
    return self.frame.origin.y;
}
- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}
- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}
- (CGFloat)left
{
    return self.frame.origin.x;
}
- (CGFloat)width
{
    return self.frame.size.width;
}
- (CGFloat)height
{
    return self.frame.size.height;
}
// setter
- (void)setTop:(CGFloat)top
{
    self.frame = CGRectMake(self.left, top, self.width, self.height);
}
- (void)setRight:(CGFloat)right
{
    CGFloat diff = right - self.right;
    self.frame = CGRectMake(self.left + diff, self.top, self.width, self.height);
}
- (void)setBottom:(CGFloat)bottom
{
    CGFloat diff = bottom - self.bottom;
    self.frame = CGRectMake(self.left, self.top + diff, self.width, self.height);
}
- (void)setLeft:(CGFloat)left
{
    self.frame = CGRectMake(left, self.top, self.width, self.height);
}
- (void)setWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.left, self.top, width, self.height);
}
- (void)setHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.left, self.top, self.width, height);
}

@end
