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
@property (strong, nonatomic) UIDatePicker *remindTimePicker;
@property (strong, nonatomic) UIToolbar *remindTimePickerToolBar;

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

- (UIToolbar *)remindTimePickerToolBar
{
    if(!_remindTimePickerToolBar){
        _remindTimePickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(.0f, .0f, kScreenWidth, 44.0f)];
        _remindTimePickerToolBar.userInteractionEnabled = YES;
        NSArray *segmentedArray = @[@"马上", @"具体", @"循环"];
	    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
	    segmentedControl.frame = CGRectMake(30.0f, 7.0f, kScreenWidth/2, 30.0);
	    segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
	    segmentedControl.tintColor = [UIColor redColor];
        
        [_remindTimePickerToolBar addSubview:segmentedControl];
        
        [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    
        
        UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [finishButton setFrame:CGRectMake(segmentedControl.right, 7.0f, 50.0f, 30.0f)];
        [finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [finishButton addTarget:self action:@selector(hiddenKeyboard:) forControlEvents:UIControlEventTouchUpInside];
        [_remindTimePickerToolBar addSubview:finishButton];
        
    }
    
    return _remindTimePickerToolBar;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"计划详情";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor colorWithRGBHex:0xDDDDDD];
    [self initRightBarButtonItem];
    //[self configTableView];
    
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard:)];
//    [self.view addGestureRecognizer:tap];
//    tap.cancelsTouchesInView = NO;
    
    [self configSubviews];
}

- (void)initRightBarButtonItem
{
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishEventClick:)]];
}

- (void)configSubviews
{
    UITextField *titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 50.0f, kScreenWidth - 20.0f, 50.0f)];
    titleTextField.borderStyle = UITextBorderStyleNone;
    titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    titleTextField.placeholder = @"计划标题";
    [self.view addSubview:titleTextField];
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
        model.eventAddedTime =  [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        model.eventRemindTime = @"2015-10-19";
        
        
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard:)];
    [self.detailTableView addGestureRecognizer:tap];
    tap.cancelsTouchesInView = NO;

    
    
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
//            [self.remindTimeArray addObject:@"object"];
//            [tableView reloadData];
            [self showDatePicker];
            
            
        }else{
            DLog(@"最多只能添加 %@ 个提醒",[NSNumber numberWithInteger:MAX_REMIND_COUNT]);
        }
    }
}

- (void)hiddenKeyboard:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
    [self hideDatePicker];
}


- (void)showDatePicker
{
    [self.view endEditing:YES];
    if (!self.remindTimePicker) {
        self.remindTimePicker = [[UIDatePicker alloc]init];
        [self.remindTimePicker setDatePickerMode:UIDatePickerModeDate];
        //[_remindTimePicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:-10*365*24*60*60]];
        [self.remindTimePicker setMinimumDate:[NSDate dateWithTimeIntervalSince1970:-[[NSDate date] timeIntervalSince1970]]];
        [self.remindTimePicker setMaximumDate:[NSDate dateWithTimeIntervalSinceNow:0]];
        self.remindTimePicker.backgroundColor = [UIColor whiteColor];
        NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
        NSArray* languages = [defs objectForKey:@"AppleLanguages"];
        NSString* preferredLang = [languages objectAtIndex:0];
        if ([preferredLang isEqualToString:@"zh-Hans"]) {
            self.remindTimePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"Chinese"];
        }

        [self.remindTimePicker setDate:[NSDate date]];
        
        [self.remindTimePicker addTarget:self action:@selector(datePickerValueChange:) forControlEvents:UIControlEventValueChanged];
        [self.remindTimePicker setFrame:CGRectMake(0, self.view.height+44, kScreenWidth, 216)];
    }
    [self.view addSubview:self.remindTimePicker];
    
    [self.remindTimePickerToolBar setFrame:CGRectMake(.0f, self.view.height, kScreenWidth, 44.0f)];
    [self.view addSubview:self.remindTimePickerToolBar];
    
    
    
    [UIView beginAnimations:@"showDatePiker" context:nil];
    [UIView setAnimationDelay:0.35f];
    [self.remindTimePicker setFrame:CGRectMake(0, self.view.height-216, kScreenWidth, 216)];
    [self.remindTimePickerToolBar setFrame:CGRectMake(0, self.view.height-216-44, kScreenWidth, 44)];
    [UIView commitAnimations];
}


- (void)hideDatePicker
{
    [UIView animateWithDuration:0.35 animations:^{
        [self.remindTimePicker setFrame:CGRectMake(0, self.view.height+44, kScreenWidth, 216)];
        [self.remindTimePickerToolBar setFrame:CGRectMake(0, self.view.height, kScreenWidth, 44)];

    }];
}

- (void)datePickerValueChange:(id)sender
{
    DLog(@"选了时间 : %@",self.remindTimePicker.date);
}



- (void)segmentAction:(UISegmentedControl *)seg
{
    switch (seg.selectedSegmentIndex){
        case 0:
            [self changeDatePickerTypeTo0];
            break;
        case 1:
            [self changeDatePickerTypeTo1];
            break;
        case 2:
            [self changeDatePickerTypeTo2];
            break;
        default:
            break;
    }
}


- (void)changeDatePickerTypeTo0
{
    DLog(@"选择 0");
}

- (void)changeDatePickerTypeTo1
{
    DLog(@"选择 1");
}

- (void)changeDatePickerTypeTo2
{
    DLog(@"选择 2");
}


- (void)dealloc
{
    self.detailTableView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
