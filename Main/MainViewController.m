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
    self.view.backgroundColor = [UIColor clearColor];
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
//    model.eventName = [NSString stringWithFormat:@"%@ 去北京最繁华的地带玩耍,啦啦啦 To Do",[NSNumber numberWithInteger:indexPath.row]];
    cell.eventModel = model;
    
    //[self configBlockOfCell:cell];
    
    return cell;
}

- (void)configBlockOfCell:(UITableViewCell *)cell
{
//    WEAKSELF
//    cell.addFriendBlock = ^(UITableViewCell *cell){
//        DLog(@"添加 %@",cell.user.name);
//    };
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"进入第 %@ 个项目",[NSNumber numberWithInteger:indexPath.row]);
    EventDetailViewController *eventVC = [[EventDetailViewController alloc] init];
    [self.navigationController pushViewController:eventVC animated:YES];
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
        //            TODO
//        MBUser * user = [self.usersArray objectAtIndex:indexPath.row - 1];
//        [self deleteFriend:user];
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
    [self.navigationController pushViewController:eventVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end