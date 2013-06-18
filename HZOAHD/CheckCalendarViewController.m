//
//  CheckCalendarViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-12.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "CheckCalendarViewController.h"
#import "AddCalendarViewController.h"

@interface CheckCalendarViewController ()

@end

@implementation CheckCalendarViewController

@synthesize startLabel;
@synthesize endLabel;
@synthesize allDaySwitch;
@synthesize startDate;
@synthesize endDate;
@synthesize dateFormatter;
@synthesize delegate;
@synthesize state;
@synthesize startDateStr;
@synthesize endDateStr;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
    
    dateFormatter = [[NSDateFormatter alloc] init];    
    if (state) {
        [dateFormatter setDateFormat:@"yyyy年M月d日 HH:mm"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        allDaySwitch.on = YES;
    } else {
        [dateFormatter setDateFormat:@"yyyy年M月d日 HH:mm"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        allDaySwitch.on = NO;
    }
    NSLog(@"%@", startDateStr);
    startDate = [dateFormatter dateFromString:startDateStr];
    endDate = [dateFormatter dateFromString:endDateStr];
    
    startLabel.text = startDateStr;
    endLabel.text = endDateStr;
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 488, 1024, 0)];
    if (state) {
        datePicker.datePickerMode = UIDatePickerModeDate;
    } else {
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    
    
    datePicker.minuteInterval = 5;
    [datePicker addTarget:self action:@selector(dateDidChange:) forControlEvents:UIControlEventValueChanged];
    [datePicker setDate:startDate];
    [self.view addSubview:datePicker];
    
    [self.allDaySwitch addTarget:self action:@selector(setStateAllDay:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (BOOL) validateDate {
    BOOL flag = NO;
    dateFormatter = [[NSDateFormatter alloc] init];
    if (state) {
        [dateFormatter setDateFormat:@"yyyy年M月d日"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    } else {
        [dateFormatter setDateFormat:@"yyyy年M月d日 HH:mm"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    }
    
    //startDate = [dateFormatter dateFromString:startLabel.text];
    //endDate = [dateFormatter dateFromString:endLabel.text];
    
    if ([endDate compare:startDate] == NSOrderedAscending) {
        return flag;
    } else {
        flag = YES;
    }
    
    return flag;
}

- (void)setStateAllDay:(id) sender {
    state = [sender isOn];
    if (state) {
        datePicker.datePickerMode = UIDatePickerModeDate;

        startLabel.text = [NSUtil parserDateToCustomString:startDate withParten:@"yyyy年M月d日"];
        endLabel.text = [NSUtil parserDateToCustomString:endDate withParten:@"yyyy年M月d日"];
        NSLog(@"%@", startLabel.text);
        NSLog(@"%@", endLabel.text);
        startDate = [NSUtil parserStringToAppendDate:startLabel.text withParten:@" 00:00"];
        endDate = [NSUtil parserStringToAppendDate:endLabel.text withParten:@" 23:59"];
        if (![self validateDate]) {
            [startLabel setTextColor:[UIColor redColor]];
            [endLabel setTextColor:[UIColor redColor]];
        } else {
            [startLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
            [endLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
        }
    } else {
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        startDate = [NSUtil parserStringToCustomDate:startDateStr withParten:@"yyyy年M月d日 HH:mm"];
        endDate = [NSUtil parserStringToCustomDate:endDateStr withParten:@"yyyy年M月d日 HH:mm"];
        if (startDate == nil) {
            startDate = [NSUtil parserStringToCustomDate:startDateStr withParten:@"yyyy年M月d日 00:00"];
            startDateStr = [NSUtil parserStringToCustomStringAdv:startDateStr withParten:@"yyyy年M月d日" withToParten:@"yyyy年M月d日 00:00"];
        }
        if (endDate == nil) {
            endDate = [NSUtil parserStringToCustomDate:endDateStr withParten:@"yyyy年M月d日 23:59"];
            endDateStr = [NSUtil parserStringToCustomStringAdv:endDateStr withParten:@"yyyy年M月d日" withToParten:@"yyyy年M月d日 23:59"];
        }
        startLabel.text = startDateStr; 
        endLabel.text = endDateStr;
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePicker.minuteInterval = 5;
        [datePicker addTarget:self action:@selector(dateDidChange:) forControlEvents:UIControlEventValueChanged];
        [datePicker setDate:startDate];
        
        if (![self validateDate]) {
            [startLabel setTextColor:[UIColor redColor]];
            [endLabel setTextColor:[UIColor redColor]];
        } else {
            [startLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
            [endLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
        }
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [datePicker setDate:startDate];
    } else if (indexPath.row == 1) {
        [datePicker setDate:endDate];
    }
}

- (void)backAction:(id) sender {

    if ([self validateDate]) {
        [self.delegate checkCalendarViewController:self didSelectCalendar:startDate withEndDate:endDate withAllDay:state];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法储存事件" message:@"开始日期必须早与结束日期。" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)dateDidChange:(UIDatePicker *) sender {
    int row = [self.tableView indexPathForSelectedRow].row;
    if (row == 0) {
        startDate = sender.date;
    } else {
        endDate = sender.date;
    }
    if (state) {
        if (row == 0) {
            startLabel.text = [NSUtil parserDateToCustomString:startDate withParten:@"yyyy年M月d日"];
            startDate = [NSUtil parserStringToAppendDate:startLabel.text withParten:@" 00:00"];
        } else {
            endLabel.text = [NSUtil parserDateToCustomString:endDate withParten:@"yyyy年M月d日"];
            endDate = [NSUtil parserStringToAppendDate:endLabel.text withParten:@" 23:59"];

        }
        if (![self validateDate]) {
            [startLabel setTextColor:[UIColor redColor]];
            [endLabel setTextColor:[UIColor redColor]];
        } else {
            [startLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
            [endLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
        }
    } else {
        if (row == 0) {
            startLabel.text = [NSUtil parserDateToCustomString:startDate withParten:@"yyyy年M月d日 HH:mm"];
            endDate = [NSDate dateWithTimeInterval:60 * 60 sinceDate:startDate];
            endLabel.text = [NSUtil parserDateToCustomString:endDate withParten:@"yyyy年M月d日 HH:mm"];
        } else {
            endLabel.text = [NSUtil parserDateToCustomString:endDate withParten:@"yyyy年M月d日 HH:mm"];
        }
        
        if (![self validateDate]) {
            [startLabel setTextColor:[UIColor redColor]];
            [endLabel setTextColor:[UIColor redColor]];
        } else {
            [startLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
            [endLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
        }
    }
}

@end
