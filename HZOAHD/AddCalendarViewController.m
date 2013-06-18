//
//  AddCalendarViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-11.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "AddCalendarViewController.h"
#import "EditCalendarViewController.h"

@interface AddCalendarViewController ()

@end

@implementation AddCalendarViewController

@synthesize txtTitle;
@synthesize txtLocation;
@synthesize startLabel;
@synthesize endLabel;
@synthesize invitionLabel;
@synthesize alertLabel;
@synthesize typeLabel;
@synthesize txtNotes;
@synthesize startDateT;
@synthesize endDateT;
@synthesize stateAllDay;
@synthesize tokenList;
@synthesize selectIndexSave;
@synthesize selectIndexType;
@synthesize selectIndexType1;
@synthesize eventTypeId;
@synthesize switchImport;
@synthesize importLabel;
@synthesize selectIndexCustomer;
@synthesize selectIndexContract;
@synthesize customerNameLabel;
@synthesize contractIdLabel;
@synthesize contractStartLabel;
@synthesize contractEndLabel;
@synthesize deleteEventButton;
@synthesize editFlag;
@synthesize reminder;
@synthesize customerIdLocal;
@synthesize contractIdLocal;
@synthesize invationsLocal;
@synthesize listContactIdLocal;
@synthesize calendarObj;
@synthesize delegate;
@synthesize customerCell;
@synthesize switchPrivate;
@synthesize privateLable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    NSString *canRead = [usernamepasswordKVPairs objectForKey:KEY_READ_CONTRACT];
    if ([@"0" isEqualToString:canRead]) {
        customerCell.hidden = YES;
    }
    tokenList = [[NSMutableArray alloc] initWithCapacity:0];
    if (editFlag) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:
                                                  UIBarButtonSystemItemDone target:self
                                                  action:@selector(updateClicked)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked)];
        
        deleteEventButton = (UIGlossyButton*) [self.view viewWithTag: 1001];
        [deleteEventButton setActionSheetButtonWithColor: [UIColor redColor]];
        
        txtTitle.text = calendarObj.Title;
        txtLocation.text = calendarObj.Location;
        startLabel.text = [NSUtil parserStringToCustomStringAdv:calendarObj.StartTime withParten:@"yyyy-MM-dd HH:mm:ss" withToParten:@"yyyy年M月d日 HH:mm"];
        endLabel.text = [NSUtil parserStringToCustomStringAdv:calendarObj.EndTime withParten:@"yyyy-MM-dd HH:mm:ss" withToParten:@"yyyy年M月d日 HH:mm"];
        
        if ([calendarObj.Employee_Id isEqualToString:@"" ]||calendarObj.Employee_Id==nil) {
            
            invitionLabel.text=@"无";
            
        }else{
            
            NSString *invationIds = calendarObj.Employee_Id;
            
            NSArray *idList = [invationIds componentsSeparatedByString:@","];
            NSString *invationNames = calendarObj.CustomerName;
            NSArray *nameList = [invationNames componentsSeparatedByString:@","];
            
            for (int i = 0; i < [nameList count]; i ++) {
                [tokenList addObject:[nameList objectAtIndex:i]];
                [listContactIdLocal setObject:[idList objectAtIndex:i] forKey:[NSString stringWithFormat:@"%d",i]];
                
            }
            invitionLabel.text = [NSString stringWithFormat:@"%d", [nameList count]];
        }

        
        if ([calendarObj.Reminder isEqualToString:@""] || calendarObj.Reminder == nil) {
            alertLabel.text = @"无";
            selectIndexSave = 0;
        } else {
            if ([calendarObj.Reminder isEqualToString:@"900"]) {
                alertLabel.text = @"15 分钟前";
                selectIndexSave = 1;
            } else if ([calendarObj.Reminder isEqualToString:@"1800"]) {
                alertLabel.text = @"30 分钟前";
                selectIndexSave = 2;
            } else if ([calendarObj.Reminder isEqualToString:@"2700"]) {
                alertLabel.text = @"45 分钟前";
                selectIndexSave = 3;
            } else if ([calendarObj.Reminder isEqualToString:@"3600"]) {
                alertLabel.text = @"1 小时前";
                selectIndexSave = 4;
            }
        }
        contractIdLabel.text = calendarObj.ProjectNum;
        customerNameLabel.text = calendarObj.ClientName;
        contractStartLabel.text = calendarObj.ProjectStartTime;
        contractEndLabel.text = calendarObj.ProjectEndTime;
        typeLabel.text = calendarObj.TypeName;
        if ([calendarObj.import isEqualToString:@"0"]) {
            importLabel.text = @"普通";
            privateLable.text=@"公开";
            [importLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
            [privateLable setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
            [switchImport setOn:NO];
            [switchPrivate setOn:NO];
        }else if ([calendarObj.import isEqualToString:@"1"]){
            importLabel.text = @"紧急";
            privateLable.text=@"公开";
            [importLabel setTextColor:[UIColor redColor]];
            [privateLable setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
            [switchImport setOn:YES];
            [switchPrivate setOn:NO];
        }else if ([calendarObj.import isEqualToString:@"2"]){
            importLabel.text = @"普通";
            privateLable.text=@"不公开";
            [importLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
            [privateLable setTextColor:[UIColor redColor]];
            [switchImport setOn:NO];
            [switchPrivate setOn:YES];
        }else if ([calendarObj.import isEqualToString:@"3"]){
            importLabel.text = @"紧急";
            privateLable.text=@"不公开";
            [importLabel setTextColor:[UIColor redColor]];
            [privateLable setTextColor:[UIColor redColor]];
            [switchImport setOn:YES];
            [switchPrivate setOn:YES];
        }

        txtNotes.text = calendarObj.Note;
        
        if ([calendarObj.AllDay isEqualToString:@"0"]) {
            stateAllDay = NO;
        } else {
            stateAllDay = YES;
        }
        deleteEventButton.hidden = YES;
        
        [self.switchImport addTarget:self action:@selector(setStateImport:) forControlEvents:UIControlEventTouchUpInside];
        [self.switchPrivate addTarget:self action:@selector(setStatePrivate:) forControlEvents:UIControlEventTouchUpInside];
        
    } else {
        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:
                                                  UIBarButtonSystemItemDone target:self
                                                  action:@selector(doneClicked)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked)];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年M月d日 H:00"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        
        startDateT = [NSDate dateWithTimeIntervalSinceNow: 60 * 60];
        NSString *oneHourAfter = [dateFormatter stringFromDate:startDateT];
        startLabel.text = oneHourAfter;
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年M月d日 H:00"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        endDateT = [NSDate dateWithTimeIntervalSinceNow: 60 * 120];
        NSString *twoHourAfter = [dateFormatter stringFromDate:endDateT];
        endLabel.text = twoHourAfter;
        
        stateAllDay = NO;
        
        selectIndexSave = 0;
        selectIndexType = 0;
        selectIndexCustomer = 0;
        selectIndexContract = 0;
        eventTypeId = @"1";
        typeLabel.text = @"无";
        deleteEventButton.hidden = YES;
        listContactIdLocal = [NSMutableDictionary dictionary];
        [self.switchImport addTarget:self action:@selector(setStateImport:) forControlEvents:UIControlEventTouchUpInside];
        [self.switchPrivate addTarget:self action:@selector(setStatePrivate:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CheckCalendar"])
	{
		CheckCalendarViewController *checkCalendarViewController = segue.destinationViewController;
		checkCalendarViewController.delegate = self;
        checkCalendarViewController.startDateStr = startLabel.text;
        checkCalendarViewController.endDateStr = endLabel.text;
        checkCalendarViewController.state = stateAllDay;
	} else if ([segue.identifier isEqualToString:@"PickContact"]) {
        SelectContactViewController *selectContactViewController = segue.destinationViewController;
        selectContactViewController.delegate = self;
        selectContactViewController.listContactId = listContactIdLocal;
        selectContactViewController.tokens =tokenList;
        
    } else if ([segue.identifier isEqualToString:@"AlertPicker"]) {
        EventAlertViewController *eventAlertViewController = segue.destinationViewController;
        eventAlertViewController.delegate = self;
        eventAlertViewController.selectedIndex = selectIndexSave;
    } else if ([segue.identifier isEqualToString:@"CalendarType"]) {
        EventTypeViewController *eventTypeViewController = segue.destinationViewController;
        eventTypeViewController.delegate = self;
        eventTypeViewController.typeLabelTxt = typeLabel.text;
    } else if ([segue.identifier isEqualToString:@"CustomerPick"]) {
        SearchCustomerViewController *searchCustomerViewController = segue.destinationViewController;
        searchCustomerViewController.delegate = self;
        searchCustomerViewController.customerSelectedIndex = selectIndexCustomer;
        searchCustomerViewController.contractSelectedIndex = selectIndexContract;
    }
}

- (void)updateClicked {
    calendarObj.Title = txtTitle.text;
    calendarObj.Location = txtLocation.text;
    calendarObj.Note = txtNotes.text;
    if (reminder == nil) {
        calendarObj.Reminder = @"0";
    } else {
        calendarObj.Reminder = reminder;
    }
    if (stateAllDay) {
        calendarObj.AllDay = @"1";
        calendarObj.StartTime = startLabel.text;
        calendarObj.EndTime = endLabel.text;
    } else {
        calendarObj.AllDay = @"0";
        calendarObj.StartTime = startLabel.text;
        calendarObj.EndTime = endLabel.text;
    }
    if (eventTypeId) {
        calendarObj.Type = eventTypeId;
    } else {
        calendarObj.Type = @"1";
    }
    if (invationsLocal == nil) {
        calendarObj.Employee_Id = @"";
    } else {
        calendarObj.Employee_Id = invationsLocal;
    }
    
    calendarObj.Readed = [usernamepasswordKVPairs objectForKey:KEY_USERID];

    if ([switchImport isOn]) {
        if ([switchPrivate isOn]) {
            calendarObj.import = @"3";
        } else {
            calendarObj.import = @"1";
        }
    } else {
        if ([switchPrivate isOn]) {
            calendarObj.import = @"2";
        } else {
            calendarObj.import = @"0";
        }
    }
    
    calendarObj.senderId = [usernamepasswordKVPairs objectForKey:KEY_USERID];
    if (customerIdLocal) {
        calendarObj.CustomerId = customerIdLocal;
    } else {
        calendarObj.CustomerId = @"0";
    }
    if (contractIdLocal) {
        calendarObj.ProjectId = contractIdLocal;
    } else {
        calendarObj.ProjectId = @"0";
    }
    calendarObj.ProjectNum = contractIdLabel.text;
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD setDelegate:self];
    [HUD setLabelText:@"提交数据..."];
    [HUD showWhileExecuting:@selector(doEdit:) onTarget:self withObject:nil animated:YES];
}

- (void) doEdit: (id) sender {
    [Calendar updateCalendar:calendarObj];
    
    alertEdit = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改完毕" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alertEdit show];
    
}


- (void)doneClicked {
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    EKCalendar *defaultCalendar;
    NSArray *listCalendars = [eventStore calendars];
    for (EKCalendar *calendar in listCalendars) {
        NSLog(@"%@", calendar.title);
        if ([calendar.title isEqualToString:KEY_CALENDAR]) {
            defaultCalendar = calendar;
            break;
        }
    }
    calendarObj = [[Calendar alloc] init ];
    calendarObj.ID = @"";
    calendarObj.Title = txtTitle.text;
    calendarObj.Location = txtLocation.text;
    calendarObj.Note = txtNotes.text;
    if (reminder == nil) {
        calendarObj.Reminder = @"0";
    } else {
        calendarObj.Reminder = reminder;
    }
    if (stateAllDay) {
        calendarObj.AllDay = @"1";
        calendarObj.StartTime = startLabel.text;
        calendarObj.EndTime = endLabel.text;
    } else {
        calendarObj.AllDay = @"0";
        calendarObj.StartTime = [NSUtil parserStringToCustomString:startLabel.text withParten:@"yyyy年M月d日 HH:mm"];
        calendarObj.EndTime = [NSUtil parserStringToCustomString:endLabel.text withParten:@"yyyy年M月d日 HH:mm"];
    }
    if (eventTypeId == nil) {
        calendarObj.Type =  @"";
    } else {
        calendarObj.Type = eventTypeId;
    }
    if (invationsLocal == nil) {
        calendarObj.Employee_Id = @"";
    } else {
        calendarObj.Employee_Id = invationsLocal;
    }
    NSLog(@"%@",calendarObj.Employee_Id);
    calendarObj.Readed = [usernamepasswordKVPairs objectForKey:KEY_USERID];
    if ([switchImport isOn]) {
        if ([switchPrivate isOn]) {
            calendarObj.import = @"3";
        } else {
            calendarObj.import = @"1";
        }
    } else {
        if ([switchPrivate isOn]) {
            calendarObj.import = @"2";
        } else {
            calendarObj.import = @"0";
        }
    }
    //NSLog(@"%@",calendarObj.import);
    calendarObj.senderId = [usernamepasswordKVPairs objectForKey:KEY_USERID];
    if (customerIdLocal) {
        calendarObj.CustomerId = customerIdLocal;
    } else {
        calendarObj.CustomerId = @"0";
    }
    if (contractIdLocal) {
        calendarObj.ProjectId = contractIdLocal;
    } else {
        calendarObj.ProjectId = @"0";
    }
    if ([self checkCalendar]) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.dimBackground = YES;
        [HUD setDelegate:self];
        [HUD setLabelText:@"提交数据..."];
        [HUD showWhileExecuting:@selector(doSend:) onTarget:self withObject:nil animated:YES];
    }
    
    
}

- (BOOL) checkCalendar {
    BOOL flag = YES;
    if ([txtTitle.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入标题" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        flag = NO;
    }
    return flag;
}

- (void) doSend: (id) sender {
    [Calendar addCalendar:calendarObj withEmployeeId:[usernamepasswordKVPairs objectForKey:KEY_USERID] withEventStoreId:nil];
    
    alertAdd = [[UIAlertView alloc] initWithTitle:@"提示" message:@"添加完毕" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alertAdd show];
}

- (void)cancelClicked {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)deleteEvent:(id) sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除事件" message:@"将要删除事件" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (alertView == alertAdd) {
            [self cancelClicked];
        }
        if (alertView == alertEdit) {
            [delegate changeFrontFlag];
            [self cancelClicked];
        }
    } else {
        // TODO: DELETE
    }
}

- (void)setStateImport:(id) sender {
    if ([sender isOn]) {
        importLabel.text = @"紧急";
        [importLabel setTextColor:[UIColor redColor]];
    } else {
        importLabel.text = @"普通";
        [importLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
    }
}
- (void)setStatePrivate:(id) sender {
    if ([sender isOn]) {
        privateLable.text = @"不公开";
        [privateLable setTextColor:[UIColor redColor]];
        calendarObj.Employee_Id = @"";

    } else {
        privateLable.text = @"公开";
        [privateLable setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
        
    }
}


#pragma mark - CheckCalendarDelegate
- (void)checkCalendarViewController:(CheckCalendarViewController *)controller didSelectCalendar:(NSDate *) startDate withEndDate:(NSDate *) endDate withAllDay:(BOOL) state {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (state) {
        [dateFormatter setDateFormat:@"yyyy年M月d日 HH:mm"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        
        NSString *oneHourAfter = [dateFormatter stringFromDate:startDate];
        startLabel.text = oneHourAfter;
        
        NSString *twoHourAfter = [dateFormatter stringFromDate:endDate];
        endLabel.text = twoHourAfter;
        stateAllDay = YES;
    } else {
        [dateFormatter setDateFormat:@"yyyy年M月d日 HH:mm"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
        
        NSString *oneHourAfter = [dateFormatter stringFromDate:startDate];
        startLabel.text = oneHourAfter;
        
        NSString *twoHourAfter = [dateFormatter stringFromDate:endDate];
        endLabel.text = twoHourAfter;
        stateAllDay = NO;
    }  
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - SelectContactControllerDelegate
- (void)selectContactViewController:(SelectContactViewController *)controller didSelectContact:(int) count withTokens:(NSArray *) tokens withInvations:(NSString *)invations withListContactId:(NSMutableDictionary *) listContactId {
    [tokenList setArray:tokens];

    invationsLocal = @"";
    if ([tokens count] > 0) {
        int i = 0;
        for (TIToken *token in tokens) {
            if (token.idValue) {
                if (i < [tokens count] - 1)
                    invationsLocal = [invationsLocal stringByAppendingFormat:@"%@,", token.idValue];
                else {
                    invationsLocal = [invationsLocal stringByAppendingFormat:@"%@", token.idValue];
                }
            }
            i ++;
        }
        //invationsLocal = [invationsLocal stringByAppendingFormat:@",%@", [usernamepasswordKVPairs objectForKey:KEY_USERID]];
        invitionLabel.text = [NSString stringWithFormat:@"%d", [tokens count]];
       
    }
    else {
        invitionLabel.text = @"无";
        invationsLocal =nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - EventAlertViewController
- (void)eventAlertViewController:(EventAlertViewController *)controller didSelectAlert:(NSString *) timer withSelectIndex:(int)selectedIndex withLabelTitle:(NSString *) title {
    selectIndexSave = selectedIndex;
    if (selectedIndex != 0) {
        alertLabel.text = title;
        if (selectedIndex == 0) {
            reminder = @"";
        } else if (selectedIndex == 1) {
            reminder = @"900";
        } else if (selectedIndex == 2) {
            reminder = @"1800";
        } else if (selectedIndex == 3) {
            reminder = @"2700";
        } else if (selectedIndex == 4) {
            reminder = @"3600";
        } else {
            reminder = @"";
        }
    } else {
        alertLabel.text = @"无";
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - EventTypeViewDelegate
- (void)eventTypeViewController:(EventTypeViewController *)controller didSelectType:(NSString *) typeId withSelectIndex:(int) selectedIndex withLabelTitle:(NSString *) title withOriginType:(NSString *)OriginEventType{
    selectIndexType1 = selectedIndex;
    eventTypeId = typeId;
    if(eventTypeId == nil){
        typeLabel.text = @"日常工作";
    }
    else{
        typeLabel.text = title;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ChooseCustomerDelegate
- (void)searchCustomerViewController:(SearchCustomerViewController *)controller didSelectContract:(NSString *) contractId withSelectIndex:(int) selectedIndex withCustomerSelectIndex:(int) customerSelectIndex withLabelTitle:(NSString *) title withStartDate:(NSString *) startDate withEndDate:(NSString *) endDate withCustomerId:(NSString *) customerId withCustomerName:(NSString *) customerName {
    selectIndexCustomer = customerSelectIndex;
    selectIndexContract = selectedIndex;
    customerIdLocal = customerId;
    contractIdLocal = contractId;
    if ([customerName isEqualToString:@""] || customerName == nil) {
        customerNameLabel.text = @"无";
    } else {
        customerNameLabel.text = customerName;
    }
    if ([title isEqualToString:@""] || title == nil) {
        contractIdLabel.text = @"无";
    } else {
        contractIdLabel.text = title;
    }
    if ([startDate isEqualToString:@""] || startDate == nil) {
        contractStartLabel.text = @"无";
    } else {
        contractStartLabel.text = startDate;
    }
    if ([endDate isEqualToString:@""] || endDate == nil) {
        contractEndLabel.text = @"无";
    } else {
        contractEndLabel.text = endDate;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
