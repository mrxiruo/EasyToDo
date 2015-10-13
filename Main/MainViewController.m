//
//  MainViewController.m
//  EasyToDo
//
//  Created by XiRuo on 15/10/10.
//  Copyright © 2015年 Xiruo. All rights reserved.
//

#import "MainViewController.h"
#import "MainTableViewCell.h"
#import "ToDoEventModel.h"
#import "EventDetailViewController.h"

#import "EventsDBManager.h"

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *mainTableView;

@property (strong, nonatomic) NSMutableArray *eventsArray;


@end


@implementation MainViewController


-(NSMutableArray *)eventsArray
{
    if (!_eventsArray) {
        _eventsArray = [[NSMutableArray alloc] init];
    }
    return _eventsArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"所有项目";
    //0xF0ECD4
    self.view.backgroundColor = [UIColor colorWithRGBHex:0xDDDDDD];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self initRightBarButtonItem];
    [self configTableView];
    [self loadEventsData];
}

- (void)initRightBarButtonItem
{
    UIButton * searchButton= [self addEventButton];
    self.navigationItem.rightBarButtonItems=@[[[UIBarButtonItem alloc] initWithCustomView:searchButton]];
}

- (void)loadEventsData
{
    NSArray *array =  [[EventsDBManager sharedInstance] getAllEvents];
    if(array){
        [self.eventsArray addObjectsFromArray:array];
        [self.mainTableView reloadData];
    }
}


- (void)configTableView
{
    CGRect rect = CGRectMake(.0f, .0f, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 64.0f);
    self.mainTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mainTableView];
    self.mainTableView.backgroundColor = [UIColor colorWithRGBHex:0xDDDDDD];

    
    [self.mainTableView registerNib:[UINib nibWithNibName:NSStringFromClass(NSClassFromString(@"MainTableViewCell")) bundle:nil] forCellReuseIdentifier:@"MainTableViewCell"];
}


#pragma mark - UITableViewDataSource & UITableViewDelegate

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eventsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * cellName = @"MainTableViewCell";
    
    MainTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(!cell){
        cell = (MainTableViewCell *)[[NSBundle mainBundle] loadNibNamed:cellName owner:self options:nil][0];
    }
    
    ToDoEventModel *model = [self.eventsArray objectAtIndex:indexPath.row];
    cell.eventModel = model;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"进入第 %@ 个项目",[NSNumber numberWithInteger:indexPath.row]);
    EventDetailViewController *eventVC = [[EventDetailViewController alloc] init];
    ToDoEventModel *model = [self.eventsArray objectAtIndex:indexPath.row];
    eventVC.eventModel = model;
    eventVC.isAddNewEvent = NO;
    eventVC.currentEventRow = indexPath.row;
    
    [self.navigationController pushViewController:eventVC animated:YES];
    
    WEAKSELF
    eventVC.finishEditEventBlock = ^(BOOL isAddNewEvent, NSInteger currentEventRow, ToDoEventModel *currentEvent){
        if(!isAddNewEvent && currentEvent){
            [weakSelf.eventsArray replaceObjectAtIndex:currentEventRow withObject:currentEvent];
            [weakSelf.mainTableView reloadData];
        }
    };
}



//设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.mainTableView){
        return YES;
    }
    return NO;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
    //对选中的Cell根据editingStyle进行操作
    if (editingStyle == UITableViewCellEditingStyleDelete )
    {
        ToDoEventModel *eventModel = [self.eventsArray objectAtIndex:indexPath.row];
        
        [self.eventsArray removeObjectAtIndex:indexPath.row];
        [tableView reloadData];

        [[EventsDBManager sharedInstance] deleteEvent:eventModel];
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleDelete;
}


- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

//设置进入编辑状态时，Cell不会缩进
- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



- (UIButton *)addEventButton
{
    UIButton *addEventButton=[UIButton buttonWithType:UIButtonTypeCustom];

    addEventButton.frame=CGRectMake(0, 0, 30.0f, 30.0f);
//    addEventButton.imageEdgeInsets = UIEdgeInsetsMake(.0f, 20.f, .0f, .0f);
    
    [addEventButton setImage:[UIImage imageNamed:@"add_interest_btn"] forState:UIControlStateNormal];
    
    [addEventButton addTarget:self action:@selector(addEventButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return addEventButton;
}

- (void)addEventButtonClick:(UIButton *)button
{
    EventDetailViewController *eventVC = [[EventDetailViewController alloc] init];
    eventVC.isAddNewEvent = YES;
    [self.navigationController pushViewController:eventVC animated:YES];
    WEAKSELF
    eventVC.finishEditEventBlock = ^(BOOL isAddNewEvent, NSInteger currentEventRow, ToDoEventModel *currentEvent){
        if(isAddNewEvent && currentEvent){
            [weakSelf.eventsArray insertObject:currentEvent atIndex:0];
            [weakSelf.mainTableView reloadData];
            NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
            [weakSelf.mainTableView scrollToRowAtIndexPath:indexPath0 atScrollPosition:UITableViewScrollPositionNone animated:NO];
        }
    };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
