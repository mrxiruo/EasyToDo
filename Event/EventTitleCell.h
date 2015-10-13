//
//  EventTitleCell.h
//  EasyToDo
//
//  Created by XiRuo on 15/10/11.
//  Copyright © 2015年 Xiruo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@property (strong, nonatomic) NSString *title;

@end
