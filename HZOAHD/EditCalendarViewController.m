//
//  EditCalendarViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-14.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "EditCalendarViewController.h"

@interface EditCalendarViewController ()

@end

@implementation EditCalendarViewController

@synthesize importCell;
@synthesize endDateLabel;
@synthesize locationLabel;
@synthesize contractNum;
@synthesize contractEndDateLabel;
@synthesize invationCell;
@synthesize startDateLabel;
@synthesize eventTitleLabel;
@synthesize contractStartDateLabel;
@synthesize alertCell;
@synthesize typeCell;
@synthesize buttonCell;
@synthesize customerNameLabel;
@synthesize notesCell;
@synthesize retMessageButton;
@synthesize calenderId;
@synthesize calendarObj;
@synthesize frontFlag;
@synthesize accpetButton;
@synthesize rejectButton;
@synthesize senderCell;
@synthesize privateCell;

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
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    calendarObj = [Calendar getSingleCanlendar:calenderId];
    [retMessageButton setBackgroundImage:[UIImage imageNamed:@"mails.png"] forState:UIControlStateNormal];
    if ([calendarObj.senderId isEqualToString:[usernamepasswordKVPairs objectForKey:KEY_USERID]]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:
                                              UIBarButtonSystemItemEdit target:self
                                              action:@selector(editClicked)];
        if ([calendarObj.message isEqualToString:@""]) {
            [retMessageButton setBackgroundImage:[UIImage imageNamed:@"mails.png"] forState:UIControlStateNormal];
        } else {
            [retMessageButton setBackgroundImage:[UIImage imageNamed:@"mail_add.png"] forState:UIControlStateNormal];
        }
    }
    if ([frontFlag isEqualToString:@""] || frontFlag == nil) {        
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:
                                                  UIBarButtonSystemItemCancel target:self
                                                 action:@selector(cancelClick:)];
    }
    eventTitleLabel.text = calendarObj.Title;
    locationLabel.text = calendarObj.Location;
    startDateLabel.text = [NSUtil parserStringToCustomStringAdv:calendarObj.StartTime withParten:@"yyyy-MM-dd HH:mm:ss" withToParten:@"yyyy年M月d日 HH:mm"];
    endDateLabel.text = [NSUtil parserStringToCustomStringAdv:calendarObj.EndTime withParten:@"yyyy-MM-dd HH:mm:ss" withToParten:@"yyyy年M月d日 HH:mm"];

    invationCell.detailTextLabel.text = calendarObj.Employee_Name;
    
    //NSLog(@"%@",calendarObj.Employee_Name);
    senderCell.detailTextLabel.text = calendarObj.senderName;
    //NSLog(@"%@", calendarObj.Reminder);
    if ([calendarObj.Reminder isEqualToString:@""] || calendarObj.Reminder == nil)
        alertCell.detailTextLabel.text = @"无";
    else {
        NSString *reminder = @"";
        if ([calendarObj.Reminder isEqualToString:@"900"]) {
            reminder = @"15 分钟前";
        } else if ([calendarObj.Reminder isEqualToString:@"1800"]) {
            reminder = @"30 分钟前";
        } else if ([calendarObj.Reminder isEqualToString:@"2700"]) {
            reminder = @"45 分钟前";
        } else if ([calendarObj.Reminder isEqualToString:@"3600"]) {
            reminder = @"1 小时前";
        }
        alertCell.detailTextLabel.text = reminder;
    }
    customerNameLabel.text = calendarObj.ClientName;
    contractNum.text = calendarObj.ProjectNum;
    if ([calendarObj.ProjectStartTime isEqualToString:@"0001-01-01 00:00:00"]) {
        contractStartDateLabel.text = @"";
    } else {
        contractStartDateLabel.text = calendarObj.ProjectStartTime;
    }
    if ([calendarObj.ProjectEndTime isEqualToString:@"0001-01-01 00:00:00"]) {
        contractEndDateLabel.text = @"";
    } else {
        contractEndDateLabel.text = calendarObj.ProjectEndTime;
    }
    typeCell.detailTextLabel.text = calendarObj.TypeName;
    if ([calendarObj.import isEqualToString:@"0"]) {
        importCell.detailTextLabel.text = @"普通";
        privateCell.detailTextLabel.text=@"否";
        [importCell.detailTextLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
        [privateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
    } else if ([calendarObj.import isEqualToString:@"1"]){
        importCell.detailTextLabel.text = @"紧急";
        privateCell.detailTextLabel.text=@"否";
        [importCell.detailTextLabel setTextColor:[UIColor redColor]];
        [privateCell.detailTextLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
    } else if ([calendarObj.import isEqualToString:@"2"]){
        importCell.detailTextLabel.text = @"普通";
        privateCell.detailTextLabel.text=@"是";
        [importCell.detailTextLabel setTextColor:[UIColor colorWithRed:0/255.0f green:101/255.0f blue:150/255.0f alpha:1.0]];
        [privateCell.detailTextLabel setTextColor:[UIColor redColor]];
    }else if ([calendarObj.import isEqualToString:@"3"]){
        importCell.detailTextLabel.text = @"紧急";
        privateCell.detailTextLabel.text=@"是";
        [importCell.detailTextLabel setTextColor:[UIColor redColor]];
        [privateCell.detailTextLabel setTextColor:[UIColor redColor]];
    }
    if ([calendarObj.Note isEqualToString:@""] || calendarObj.Note == nil) {
        notesCell.detailTextLabel.text = @"";
    } else {
        notesCell.detailTextLabel.text = calendarObj.Note;
    }
    
    if (![calendarObj.senderId isEqualToString:[usernamepasswordKVPairs objectForKey:KEY_USERID]]) {
        UIGlossyButton *acceptButton = (UIGlossyButton *) [self.tableView viewWithTag: 1001];
        [acceptButton setActionSheetButtonWithColor: [UIColor blueColor]];
        //- (NSRange)rangeOfString:(NSString *)aString; 
        NSRange range = [calendarObj.Readed rangeOfString:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
        if (range.location == NSNotFound) {
            NSLog(@"NSNotFound!");
            acceptButton.hidden = NO;
        } else {
            NSLog(@"Found!");
            acceptButton.hidden = YES;
        }
    } else {
        [accpetButton useWhiteLabel: YES];
        accpetButton.tintColor = [UIColor darkGrayColor];
        [accpetButton setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
        accpetButton.hidden = NO;
        
        [rejectButton useWhiteLabel: YES];
        rejectButton.tintColor = [UIColor redColor];
        [rejectButton setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
        rejectButton.hidden = NO;
    }
    
}

- (void)cancelClick:(id) sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)changeFrontFlag {
    frontFlag = @"true";
}

- (void) viewWillAppear:(BOOL)animated {
    if ([frontFlag isEqualToString:@"true"]) {
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (IBAction)acceptEvent:(id) sender {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    [Calendar accpetEvent:calendarObj.ID withEmployeeID:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已接受" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alertView show];
    accpetButton.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rejectEvent:(id) sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定拒绝该安排吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
    } else {
        NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
        NSString *employeeId = [usernamepasswordKVPairs objectForKey:KEY_USERID];
        [Calendar rejectEvent:calendarObj.ID withEmployeeID:employeeId];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view..
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(IBAction)tapedMessageButton:(id)sender {
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ReturnMessageViewController *returnMessageViewController = [storyborad instantiateViewControllerWithIdentifier:@"ReturnMessageViewController"];
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    if ([calendarObj.senderId isEqualToString:[usernamepasswordKVPairs objectForKey:KEY_USERID]]) {
        returnMessageViewController.editFlag = NO;
        returnMessageViewController.textValue = calendarObj.message;
    } else {
        returnMessageViewController.editFlag = YES;
        returnMessageViewController.textValue = @"";
        returnMessageViewController.calendarObj = calendarObj;
    }
    UINavigationController *navBar = [[UINavigationController alloc]initWithRootViewController:returnMessageViewController];
    [self.navigationController presentModalViewController:navBar animated:YES]; 
}

-(void)editClicked {
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AddCalendarViewController *addCalendarViewController = [storyborad instantiateViewControllerWithIdentifier:@"AddCalendarViewController"];
    addCalendarViewController.editFlag = YES;
    addCalendarViewController.calendarObj = calendarObj;
    addCalendarViewController.delegate = self;
    UINavigationController *navBar = [[UINavigationController alloc]initWithRootViewController:addCalendarViewController];
    [self presentModalViewController:navBar animated:YES];
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
