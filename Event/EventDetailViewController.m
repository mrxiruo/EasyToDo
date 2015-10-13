//
//  EventDetailViewController.m
//  EasyToDo
//
//  Created by XiRuo on 15/10/11.
//  Copyright © 2015年 Xiruo. All rights reserved.
//

#import "EventDetailViewController.h"
#import "EventTitleCell.h"
#import "EventDetailCell.h"
#import "EventRemindCell.h"

#import "EventsDBManager.h"

#define MAX_REMIND_COUNT 5


@interface EventDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *detailTableView;
@property (strong, nonatomic) NSMutableArray *remindTimeArray;

@end

@implementation EventDetailViewController


-(NSMutableArray *)remindTimeArray
{
    if (!_remindTimeArray) {
        _remindTimeArray = [[NSMutableArray alloc] init];
        [_remindTimeArray addObject:@"原始"];
    }
    return _remindTimeArray;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"计划详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithRGBHex:0xDDDDDD];
    [self initRightBarButtonItem];
    [self configTableView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard:)];
    [self.view addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;
}

- (void)initRightBarButtonItem
{
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishEventClick:)]];
}

- (void)finishEventClick:(UIButton *)button
{
    if(self.isAddNewEvent){
        //如果是要增加新的事件

        ToDoEventModel *model = [[ToDoEventModel alloc] init];
        
        EventTitleCell *titleCell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        
        model.eventId = [[NSDate date] timeIntervalSince1970];
        model.eventName = [titleCell.titleTextField.text copy];
        model.eventDescription = @"大帝都大帝都手打手打撒到撒到 速度大手打手打撒到撒到打算打算打算打算的";
        model.eventAddedTime = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:model.eventId]];
        model.eventRemindTimeArray = @[@"2015-10-19",@"2015-10-20"];
        
        
        [[EventsDBManager sharedInstance] insertNewEvent:model];
        
        if(self.finishEditEventBlock){
            self.finishEditEventBlock(self.isAddNewEvent, self.currentEventRow, model);
        }
        
    }else{
        //如果是修改以前的事件
        DLog(@"修改事件完成");
        
        EventTitleCell *titleCell = [self.detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        self.eventModel.eventName = [titleCell.titleTextField.text copy];
        
        if(self.finishEditEventBlock){
            self.finishEditEventBlock(self.isAddNewEvent, self.currentEventRow, self.eventModel);
        }
        
    }
    
    

    
    //成功后马上返回主界面
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configTableView
{
    CGRect rect = CGRectMake(.0f, .0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64.0f);
    self.detailTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.detailTableView.allowsSelection = YES;
    [self.view addSubview:self.detailTableView];
    
    
    [self.detailTableView registerNib:[UINib nibWithNibName:NSStringFromClass(NSClassFromString(@"EventTitleCell")) bundle:nil] forCellReuseIdentifier:@"EventTitleCell"];
    [self.detailTableView registerNib:[UINib nibWithNibName:NSStringFromClass(NSClassFromString(@"EventDetailCell")) bundle:nil] forCellReuseIdentifier:@"EventDetailCell"];
    [self.detailTableView registerNib:[UINib nibWithNibName:NSStringFromClass(NSClassFromString(@"EventRemindCell")) bundle:nil] forCellReuseIdentifier:@"EventRemindCell"];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 2){
        return @"计划详细描述";
    }else{
        return nil;
    }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1){
        return self.remindTimeArray.count;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 || indexPath.section == 1){
        return 50.0f;
    }else{
        return 150.0f;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        NSString * cellName = @"EventTitleCell";
        
        EventTitleCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(!cell){
            cell = (EventTitleCell *)[[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil][0];
        }
        
        cell.title = self.eventModel.eventName;
        
        if(self.isAddNewEvent){
            [cell.titleTextField becomeFirstResponder];
        }
        
        return cell;
    }else if (indexPath.section == 1){
        NSString * cellName = @"EventRemindCell";
        
        EventRemindCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(!cell){
            cell = (EventRemindCell *)[[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil][0];
        }
        
        return cell;
    }else{
        NSString * cellName = @"EventDetailCell";
        
        EventDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(!cell){
            cell = (EventDetailCell *)[[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil][0];
        }
        
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        if(self.remindTimeArray.count < MAX_REMIND_COUNT){
            [self.remindTimeArray addObject:@"object"];
            [tableView reloadData];
        }else{
            DLog(@"最多只能添加 %@ 个提醒",[NSNumber numberWithInteger:MAX_REMIND_COUNT]);
        }
    }
}

- (void)hiddenKeyboard:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
}



-(void)dealloc
{
    self.detailTableView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
