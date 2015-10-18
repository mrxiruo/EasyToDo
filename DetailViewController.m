//
//  DetailViewController.m
//  EasyToDo
//
//  Created by XiRuo on 15/10/15.
//  Copyright © 2015年 Xiruo. All rights reserved.
//

#import "DetailViewController.h"
#import "EventsDBManager.h"


@interface DetailViewController ()

@property (strong, nonatomic) UIDatePicker *remindTimePicker;
@property (strong, nonatomic) UIToolbar *remindTimePickerToolBar;


@end

@implementation DetailViewController

- (UIToolbar *)remindTimePickerToolBar
{
    if(!_remindTimePickerToolBar){
        _remindTimePickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(.0f, .0f, kScreenWidth, 44.0f)];
        _remindTimePickerToolBar.userInteractionEnabled = YES;
        NSArray *segmentedArray = @[@"马上", @"具体", @"循环"];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
        segmentedControl.frame = CGRectMake(30.0f, 7.0f, kScreenWidth - 60.0f - 60.0f, 30.0);
        segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
        segmentedControl.tintColor = [UIColor redColor];
        
        [_remindTimePickerToolBar addSubview:segmentedControl];
        
        [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        
        
        UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [finishButton setFrame:CGRectMake(segmentedControl.right + 20.0f, 7.0f, 50.0f, 30.0f)];
        [finishButton setTitle:@"完成" forState:UIControlStateNormal];
        [finishButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
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
    [self configEvent];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard:)];
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *remindLabelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker)];
    [self.remindTimeLabel addGestureRecognizer:remindLabelTap];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.isAddNewEvent){
        [self.titleTextField becomeFirstResponder];
    }
}

- (void)initRightBarButtonItem
{
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishEventClick:)]];
}

- (void)configEvent
{
    if(!self.isAddNewEvent){
        //如果是修改某事件
        self.titleTextField.text = self.eventModel.eventName;
        self.remindTimeLabel.text = [[NSDate dateWithTimeIntervalSince1970:[self.eventModel.eventRemindTime doubleValue]] getDateStringInMessageList];
        self.detailTextView.text = self.eventModel.eventDescription;
    }else{
        self.titleTextField.text = nil;
        self.remindTimeLabel.text = @"点击设置提醒时间";
        self.detailTextView.text = @"在此输入详细描述";
    }
}


- (void)finishEventClick:(UIButton *)button
{
    if(self.isAddNewEvent){
        //如果是要增加新的事件
        ToDoEventModel *model = [[ToDoEventModel alloc] init];
        
        model.eventName = self.titleTextField.text;
        model.eventDescription = self.detailTextView.text;
        model.eventAddedTime =  [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        model.eventRemindTime = [NSString stringWithFormat:@"%f",[self.remindTimePicker.date timeIntervalSince1970]];
        
        [[EventsDBManager sharedInstance] insertNewEvent:model];
        
        if(self.finishEditEventBlock){
            self.finishEditEventBlock(self.isAddNewEvent, self.currentEventRow, model);
        }
    }else{
        //如果是修改以前的事件
        self.eventModel.eventName = self.titleTextField.text;
        self.eventModel.eventDescription = self.detailTextView.text;
        self.eventModel.eventRemindTime = [NSString stringWithFormat:@"%f",[self.eventModel.eventRemindTime doubleValue]];
        
        [[EventsDBManager sharedInstance] updateEventByNewEvent:self.eventModel];

        if(self.finishEditEventBlock){
            self.finishEditEventBlock(self.isAddNewEvent, self.currentEventRow, self.eventModel);
        }
    }

    //成功后马上返回主界面
    [self.navigationController popViewControllerAnimated:YES];
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
        [self.remindTimePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        [self.remindTimePicker setMinimumDate:[NSDate date]];
        self.remindTimePicker.backgroundColor = [UIColor whiteColor];
        NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
        NSArray* languages = [defs objectForKey:@"AppleLanguages"];
        NSString* preferredLang = [languages objectAtIndex:0];
        if ([preferredLang isEqualToString:@"zh-Hans"]) {
            self.remindTimePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"Chinese"];
        }
        
        [self.remindTimePicker setDate:[NSDate dateWithTimeIntervalSince1970:[self.eventModel.eventRemindTime doubleValue]]];
        
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
//    DLog(@"选了时间 : %@",self.remindTimePicker.date);
    self.eventModel.eventRemindTime = [NSString stringWithFormat:@"%f",[self.remindTimePicker.date timeIntervalSince1970]];
    self.remindTimeLabel.text = [self.remindTimePicker.date getDateStringInMessageList];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
