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
    self.navigationItem.rightBarButtonItems = @[[[UIBarButtonItem alloc] initWithTitle:@"确认修改" style:UIBarButtonItemStyleDone target:self action:@selector(finishEventClick:)]];
}

- (void)configEvent
{
    if(!self.isAddNewEvent){
        //如果是修改某事件
        self.navigationItem.rightBarButtonItem.title = @"确认修改";
        
        self.titleTextField.text = self.eventModel.eventName;
        self.remindTimeLabel.text = [[NSDate dateWithTimeIntervalSince1970:[self.eventModel.eventRemindTime doubleValue]] getDateStringInMessageList];
        self.detailTextView.text = self.eventModel.eventDescription;
    }else{
        self.navigationItem.rightBarButtonItem.title = @"确认添加";

        self.titleTextField.text = nil;
        self.remindTimeLabel.text = @"点击设置提醒时间,默认不提醒";
        self.detailTextView.text = @"在此输入详细描述";
    }
}


#pragma mark - 点击事件

- (void)finishEventClick:(UIButton *)button
{
    if(!self.titleTextField.text || (self.titleTextField.text.trim.length < 1)){
        self.titleTextField.text = nil;
        return;
    }
    
    if(self.isAddNewEvent){
        //如果是要增加新的事件
        ToDoEventModel *model = [[ToDoEventModel alloc] init];
        
        model.eventName = self.titleTextField.text;
        model.eventDescription = self.detailTextView.text;
        model.eventAddedTime =  [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
        
        if(self.remindTimePicker.date){
            model.eventRemindTime = [NSString stringWithFormat:@"%f",[self.remindTimePicker.date timeIntervalSince1970]];
        }else{
            model.eventRemindTime = nil;
        }
        
        [[EventsDBManager sharedInstance] insertNewEvent:model];
        
        if(self.finishEditEventBlock){
            self.finishEditEventBlock(self.isAddNewEvent, self.currentEventRow, model);
        }
    }else{
        //如果是修改以前的事件
        self.eventModel.eventName = self.titleTextField.text;
        self.eventModel.eventDescription = self.detailTextView.text;
        if(self.eventModel.eventRemindTime){
            self.eventModel.eventRemindTime = [NSString stringWithFormat:@"%f",[self.eventModel.eventRemindTime doubleValue]];
        }else{
            self.eventModel.eventRemindTime = nil;
        }
        
        [[EventsDBManager sharedInstance] updateEventByNewEvent:self.eventModel];

        if(self.finishEditEventBlock){
            self.finishEditEventBlock(self.isAddNewEvent, self.currentEventRow, self.eventModel);
        }
    }

    //成功后马上返回主界面
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)cancelRemindButtonClick:(UIButton *)sender
{
    self.eventModel.eventRemindTime = nil;
    self.remindTimeLabel.text = @"不提醒";
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
            //具体
            self.remindTimePicker.datePickerMode = UIDatePickerModeDateAndTime;
            
            break;
        case 1:
            [self changeDatePickerTypeTo1];
            //马上
            self.remindTimePicker.datePickerMode = UIDatePickerModeTime;
            self.remindTimePicker.date = [NSDate date];
            break;
        case 2:
            [self changeDatePickerTypeTo2];
            //循环
            
            
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


#pragma mark - Getter

- (UIToolbar *)remindTimePickerToolBar
{
    if(!_remindTimePickerToolBar){
        _remindTimePickerToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(.0f, .0f, kScreenWidth, 44.0f)];
        _remindTimePickerToolBar.userInteractionEnabled = YES;
        NSArray *segmentedArray = @[@"具体", @"马上", @"循环"];
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentedArray];
        segmentedControl.frame = CGRectMake(10.0f, 7.0f, kScreenWidth - 60.0f - 60.0f, 30.0);
        segmentedControl.selectedSegmentIndex = 0;//设置默认选择项索引
        segmentedControl.tintColor = [UIColor redColor];
        
        [_remindTimePickerToolBar addSubview:segmentedControl];
        
        [segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        
        
        UIButton *cancelRemindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelRemindButton setFrame:CGRectMake(segmentedControl.right + 20.0f, 7.0f, 60.0f, 30.0f)];
        cancelRemindButton.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        [cancelRemindButton setTitle:@"不提醒" forState:UIControlStateNormal];
        [cancelRemindButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [cancelRemindButton addTarget:self action:@selector(cancelRemindButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_remindTimePickerToolBar addSubview:cancelRemindButton];
    }
    
    return _remindTimePickerToolBar;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
