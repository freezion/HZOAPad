//
//  CalendarViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-7-30.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "CalendarViewController.h"
#import "UserKeychain.h"
#import "LoginViewController.h"
#import "Employee.h"
#import "AddCalendarViewController.h"
#import "EditCalendarViewController.h"
#import "PublicCalendarViewController.h"

NSString *currentDateStr;
NSDate *currentDate;
NSString *show = @"当前选择的日期: ";
NSString *flag = @"NO";
NSString *eventStoreId = @"";

@interface CalendarViewController ()

@end

@implementation CalendarViewController

@synthesize eventStore;
@synthesize defaultCalendar;
@synthesize eventsList;
@synthesize segmentedControl;
@synthesize segmentIndex;
@synthesize myCalendarType;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.eventStore = [[EKEventStore alloc] init];
    [Employee synchronizeEmployee];
    [Employee deleteAllTmpContact];
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // the selector is available, so we must be on iOS 6 or newer
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未知错误" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else if (!granted)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有授权！请允许访问iCal" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    self.defaultCalendar = [self.eventStore defaultCalendarForNewEvents];
                }
            });
        }];
    }
    else
    {
        self.defaultCalendar = [self.eventStore defaultCalendarForNewEvents];
    }
    
    
    eventStoreId = eventStore.eventStoreIdentifier;
    if (_refreshHeaderView == nil) {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    //self.navigationController.navigationBar.tintColor = [UIColor purpleColor]; 
    
    self.tableView.dataSource = self;
    
    self.title = @"日程安排";
	
	// Initialize an event store object with the init method. Initilize the array for events.
	
    
	self.eventsList = [[NSMutableArray alloc] initWithArray:0];
	NSArray *listCalendars = [eventStore calendars];
    for (EKCalendar *calendar in listCalendars) {
        NSLog(@"%@", calendar.title);
        if ([calendar.title isEqualToString:KEY_CALENDAR]) {
            self.defaultCalendar = calendar;
            break;
        }
    }
	// Get the default calendar from store.
	//self.defaultCalendar = [self.eventStore calendarWithIdentifier:@"E187D61E-D5B1-4A92-ADE0-6FC2B3AF424F"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    self.navigationItem.prompt = [show stringByAppendingFormat:@"%@", currentDateStr];                 
    
    
//    self.navigationController.delegate = self;
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    currentDate = [dateFormatter dateFromString:currentDateStr];
    NSTimeInterval  interval = 24 * 60 * 60 * 31;
    NSDate *threeDayAfter = [currentDate initWithTimeIntervalSinceNow:+interval];
    // Fetch today's event on selected calendar and put them into the eventsList array
    [self.eventsList removeAllObjects];
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    
    if ([myCalendarType isEqualToString:@"EventPick"]) {
        self.eventsList = [Calendar getAllMyData:[usernamepasswordKVPairs objectForKey:KEY_USERID] withStartDate:currentDate withEndDate:threeDayAfter];
    }
    else if ([myCalendarType isEqualToString:@"InvationPick"]) {
        self.eventsList = [Calendar allMySendData:[usernamepasswordKVPairs objectForKey:KEY_USERID] withStartDate:currentDate withEndDate:threeDayAfter];
    }
    else if ([myCalendarType isEqualToString:@"ConformPick"]) {
        self.eventsList = [Calendar allInvitedMeData:[usernamepasswordKVPairs objectForKey:KEY_USERID] withStartDate:currentDate withEndDate:threeDayAfter];
    }
    else if ([myCalendarType isEqualToString:@"PublicEventPick"]) {
        self.eventsList = [Calendar getPublicData:currentDate withEndDate:threeDayAfter];
    }
    //self.eventsList = [Calendar getCalendarDataByDateTime:currentDate withEndDate:threeDayAfter withEmployeeId:[usernamepasswordKVPairs objectForKey:KEY_USERID] withCalendar:nil];   
    [self.tableView reloadData];

    
}

- (void)viewWillAppear:(BOOL)animated {
    NSArray *segmentTextContent = [NSArray arrayWithObjects:
                                   @"打开iCal",
                                   @"日期选择",
                                   @"新增安排",
								   nil];
	self.segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
	//segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.momentary = YES;
	self.segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	self.segmentedControl.frame = CGRectMake(0, 0, 400, 30);
	[self.segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	
	defaultTintColor = segmentedControl.tintColor;	// keep track of this for later
    
	self.navigationItem.titleView = segmentedControl;
}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//
//}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.eventsList = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
//    if ([flag isEqualToString:@"YES"]) {
//        [self dismissDatePicker:nil];
//        if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
//            //翻转为竖屏时
//            [self setVerticalFrame];
//        }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
//            //翻转为横屏时
//            [self setHorizontalFrame];
//        }
//    }
//}

- (IBAction)segmentAction:(id)sender
{
	// The segmented control was clicked, handle it here 
	self.segmentedControl = (UISegmentedControl *)sender;
	//NSLog(@"Segment clicked: %d", segmentedControl.selectedSegmentIndex);
    
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
        {            
            NSArray *eventArray = [self fetchEventsForToday:currentDate];
            NSError *error;
            for (EKEvent *event in eventArray) {
                [eventStore removeEvent:event span:EKSpanThisEvent error:&error];
            }
            
            for (Calendar *calendarObj in eventsList) {
                EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                event.calendar = defaultCalendar;
                event.title = calendarObj.Title;
                event.notes = calendarObj.Note;
                event.startDate = [NSUtil parserStringToDate:calendarObj.StartTime];
                event.endDate = [NSUtil parserStringToDate:calendarObj.EndTime];
                if (![calendarObj.Reminder isEqualToString:@""]) {
                    float value = -[calendarObj.Reminder floatValue];
                    NSMutableArray *alarmsArray = [[NSMutableArray alloc] init];
                    EKAlarm *alarm = [EKAlarm alarmWithRelativeOffset:value];
                    [alarmsArray addObject:alarm];
                    event.alarms = [NSArray arrayWithArray:alarmsArray];
                } else {
                    event.alarms = nil;
                }
                event.location = calendarObj.Location;           
                if ([calendarObj.AllDay isEqualToString:@"1"]) {
                    event.allDay = YES;
                } else {
                    event.allDay = NO;
                }
                [eventStore saveEvent:event span:EKSpanThisEvent error:&error];
            }
            //lanuch ical            
            NSURL *url = [NSURL URLWithString:@"calshow:"];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
        case 1:
        {
            if ([self.view viewWithTag:9]) {
                return;
            }
            
            UIDeviceOrientation interfaceOrientation=[[UIApplication sharedApplication] statusBarOrientation];
            if (interfaceOrientation == UIDeviceOrientationPortrait || interfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
                //翻转为竖屏时
                [self setVerticalFrame];
            }else if (interfaceOrientation==UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight) {
                //翻转为横屏时
                [self setHorizontalFrame];
            }
        }
            break;
        case 2:
        {
            [self addEvent:sender];
        }
            break;
    
    }
}

- (void)changeDate:(UIDatePicker *)sender {
    NSLog(@"New Date: %@", sender.date);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    currentDateStr = [dateFormatter stringFromDate:sender.date];
    self.navigationItem.prompt = [show stringByAppendingFormat:@"%@", currentDateStr];
    currentDate = sender.date;
    [self.eventsList removeAllObjects];
    NSTimeInterval  interval = 24 * 60 * 60 * 31;
    NSDate *threeDayAfter = [currentDate initWithTimeIntervalSinceNow:+interval];
    // Fetch today's event on selected calendar and put them into the eventsList array
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    if ([myCalendarType isEqualToString:@"EventPick"]) {
        self.eventsList = [Calendar getAllMyData:[usernamepasswordKVPairs objectForKey:KEY_USERID] withStartDate:currentDate withEndDate:threeDayAfter];
    }
    else if ([myCalendarType isEqualToString:@"InvationPick"]) {
        self.eventsList = [Calendar allMySendData:[usernamepasswordKVPairs objectForKey:KEY_USERID] withStartDate:currentDate withEndDate:threeDayAfter];
    }
    else if ([myCalendarType isEqualToString:@"ConformPick"]) {
        self.eventsList = [Calendar allInvitedMeData:[usernamepasswordKVPairs objectForKey:KEY_USERID] withStartDate:currentDate withEndDate:threeDayAfter];
    }
    else if ([myCalendarType isEqualToString:@"PublicEventPick"]) {
        self.eventsList = [Calendar getPublicData:currentDate withEndDate:threeDayAfter];
    }
    [self.tableView reloadData];
}

- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}

- (void)dismissDatePicker:(id)sender {
    flag = @"NO";
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
}

-(void)setVerticalFrame
{
    NSLog(@"竖屏");
    flag = @"YES";
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-260, self.view.bounds.size.width, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, self.view.bounds.size.width, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 2500)];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)];
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    //UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 770, 216)];
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
    datePicker.tag = 10;
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    datePicker.frame = datePickerTargetFrame;
    darkView.alpha = 0.5;
    [UIView commitAnimations];
}

-(void)setHorizontalFrame
{
    NSLog(@"横屏");
    flag = @"YES";
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-260, self.view.bounds.size.width, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, self.view.bounds.size.width, 216);
    
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 2500)];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)];
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    //UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 770, 216)];
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
    datePicker.tag = 10;
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)];
    [toolBar setItems:[NSArray arrayWithObjects:spacer, doneButton, nil]];
    [self.view addSubview:toolBar];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    datePicker.frame = datePickerTargetFrame;
    darkView.alpha = 0.5;
    [UIView commitAnimations];
}

#pragma mark -
#pragma mark Table view data source

// Fetching events happening in the next 24 hours with a predicate, limiting to the default calendar 
- (NSArray *)fetchEventsForToday:(NSDate *) startDate {
	// endDate is 1 day = 60*60*24 seconds = 86400 seconds from startDate
	//NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:86400];
	//NSDate *endDate = [NSDate dateWithTimeInterval:86400 sinceDate:startDate];
    NSTimeInterval  interval = 24 * 60 * 60 * 31;
    NSDate *endDate = [currentDate initWithTimeIntervalSinceNow:+interval];
    //NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    //[Calendar getCalendarDataByDateTime:startDate withEndDate:endDate withEmployeeId:[usernamepasswordKVPairs objectForKey:KEY_USERID] withCalendar:self.defaultCalendar];
    
	// Create the predicate. Pass it the default calendar.
	NSArray *calendarArray = [NSArray arrayWithObject:defaultCalendar];
    
	NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate 
                                                                    calendars:calendarArray]; 
	
	// Fetch all events that match the predicate.
	NSArray *events = [self.eventStore eventsMatchingPredicate:predicate];
	return events;
}

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    Calendar *calendarObj = [self.eventsList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    EditCalendarViewController *editCalendarViewController = segue.destinationViewController;
    editCalendarViewController.calenderId = calendarObj.ID;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return eventsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CalendarCell";
	CalendarCell *cell = (CalendarCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	// Get the event at the row selected and display it's title
    Calendar *calendarObj = [self.eventsList objectAtIndex:indexPath.row];
    cell.eventNameLabel.text = calendarObj.Title;
    if ([calendarObj.AllDay isEqualToString:@"1"]) {
        cell.startTimeLabel.hidden = YES;
        cell.endTimeLabel.hidden = YES;
        cell.startTextLabel.hidden = YES;
        cell.endTextLabel.hidden = YES;
        cell.alldayImage.image = [UIImage imageNamed:@"24h.png"];
    } else {
        cell.startTimeLabel.text = [NSUtil parserStringToCustomStringAdv:calendarObj.StartTime withParten:@"yyyy-MM-dd HH:mm:ss" withToParten:@"HH:mm cccc"];
        cell.endTimeLabel.text = [NSUtil parserStringToCustomStringAdv:calendarObj.EndTime withParten:@"yyyy-MM-dd HH:mm:ss" withToParten:@"HH:mm cccc"];
        cell.alldayImage.image = [UIImage imageNamed:@""];
    }
	return cell;

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([myCalendarType isEqualToString:@"PublicEventPick"]){
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        PublicCalendarViewController *publicCalendarViewController = [storyborad instantiateViewControllerWithIdentifier:@"PublicCalendarViewController"];
        Calendar *calendarObj = [self.eventsList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        publicCalendarViewController.calenderId = calendarObj.ID;
        NSLog(@"%@",publicCalendarViewController.calenderId);
        [self.navigationController pushViewController:publicCalendarViewController animated:YES];
    }else{
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        EditCalendarViewController *editCalendarViewController = [storyborad instantiateViewControllerWithIdentifier:@"EditCalendarViewController"];
        Calendar *calendarObj = [self.eventsList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        editCalendarViewController.calenderId = calendarObj.ID;
        [self.navigationController pushViewController:editCalendarViewController animated:YES];
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)doneFunc {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Add a new event

// If event is nil, a new event is created and added to the specified event store. New events are 
// added to the default calendar. An exception is raised if set to an event that is not in the 
// specified event store.
- (void)addEvent:(id)sender {    
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AddCalendarViewController *addCalendarViewController = [storyborad instantiateViewControllerWithIdentifier:@"AddCalendarViewController"];
    UINavigationController *navBar = [[UINavigationController alloc]initWithRootViewController:addCalendarViewController];
    [self presentModalViewController:navBar animated:YES];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo

	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_reloading = NO;
    [self.eventsList removeAllObjects];
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    NSTimeInterval  interval = 24 * 60 * 60 * 31;
    NSDate *threeDayAfter = [currentDate initWithTimeIntervalSinceNow:+interval];
    //NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    //eventList = [self fetchEventsForToday:currentDate];
    if ([myCalendarType isEqualToString:@"EventPick"]) {
        self.eventsList = [Calendar getAllMyData:[usernamepasswordKVPairs objectForKey:KEY_USERID] withStartDate:currentDate withEndDate:threeDayAfter];
    }
    else if ([myCalendarType isEqualToString:@"InvationPick"]) {
        self.eventsList = [Calendar allMySendData:[usernamepasswordKVPairs objectForKey:KEY_USERID] withStartDate:currentDate withEndDate:threeDayAfter];
    }
    else if ([myCalendarType isEqualToString:@"ConformPick"]) {
        self.eventsList = [Calendar allInvitedMeData:[usernamepasswordKVPairs objectForKey:KEY_USERID] withStartDate:currentDate withEndDate:threeDayAfter];
    }
    else if ([myCalendarType isEqualToString:@"PublicEventPick"]) {
        self.eventsList = [Calendar getPublicData:currentDate withEndDate:threeDayAfter];
    }
    
    [self.tableView reloadData];
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

@end
