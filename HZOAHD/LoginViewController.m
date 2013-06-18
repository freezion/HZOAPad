//
//  LoginViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-7-27.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "LoginViewController.h"
#import "UIGlossyButton.h"
#import "UIView+LayerEffects.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "UserKeychain.h"
#import "CalendarViewController.h"
#import "Employee.h"
#import "MainViewController.h"

NSMutableString *divCharacters;
NSString *type = @"login";

@interface LoginViewController ()

@end

@implementation LoginViewController


@synthesize txtUser,txtPass;
@synthesize btnLogin;

- (IBAction)login:(id)sender {
    [txtUser resignFirstResponder];
    [txtPass resignFirstResponder];
    //验证用户名 密码
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD setDelegate:self];
    [HUD setLabelText:@"提交验证"];
    [HUD showWhileExecuting:@selector(myLoginTask) onTarget:self withObject:nil animated:YES];
}

- (void)myLoginTask {
    NSString *user = [txtUser.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *pass = [txtPass.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"UserCheck.asmx/loginUserCheckForIOS"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    
    NSString *deviceType = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).deviceType;
    NSString *deviceTokenNum = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).deviceTokenNum;
    NSLog(@"%@",deviceType);
    NSLog(@"%@",deviceTokenNum);
    
    NSString *model = [[UIDevice currentDevice] model];
    if ([model isEqualToString:@"iPad Simulator"]) {
        deviceType = @"0";
        deviceTokenNum = @"999";
    }
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    [request setPostValue:user forKey:@"name"];
    [request setPostValue:pass forKey:@"pwd"];
    [request setPostValue:deviceType forKey:@"deviceType"];
    [request setPostValue:deviceTokenNum forKey:@"deviceToken"];
    [request buildPostBody];
    [request setDelegate:self];
    [request startSynchronous];
    
    
    //[self removeAllEvent];
    // TODO : DELETE
//    sleep(3);
//    [self dismissViewControllerAnimated:YES completion:nil];
//    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
//    [usernamepasswordKVPairs setObject:txtUser.text forKey:KEY_USERID];
//    [usernamepasswordKVPairs setObject:txtPass.text forKey:KEY_PASSWORD];
//    [UserKeychain save:KEY_LOGINID_PASSWORD data:usernamepasswordKVPairs];
}


- (void)removeAllEvent {
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
    NSArray *calendarArray = [NSArray arrayWithObject:defaultCalendar];
    NSPredicate *predicate = [eventStore predicateForEventsWithStartDate:[NSUtil beginningOfMonth] endDate:[NSUtil endOfMonth] calendars:calendarArray]; 

    NSArray *events = [eventStore eventsMatchingPredicate:predicate];
    NSError *error;
    for (EKEvent *event in events) {
        [eventStore removeEvent:event span:EKSpanThisEvent error:&error];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"%@", [request responseString]);
    
    if(request.responseStatusCode == 200)
    {
        NSString *responseString = [request responseString];
        NSError *error;
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:responseString options:0 error:&error];
        GDataXMLElement *root = [doc rootElement];
        NSString *xmlString = [root stringValue];
        if ([xmlString isEqualToString:@"errorPwd"] || [xmlString isEqualToString:@"unExist"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            NSString *deviceTokenNum = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).deviceTokenNum;
            NSArray *listItems = [xmlString componentsSeparatedByString:@","];
            NSString *userId = [listItems objectAtIndex:0];
            NSString *name = [listItems objectAtIndex:1];
            NSString *deptId = [listItems objectAtIndex:2];
            //用户名和密码存入keychain
            NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
            [usernamepasswordKVPairs setObject:txtUser.text forKey:KEY_LOGINID];
            [usernamepasswordKVPairs setObject:txtPass.text forKey:KEY_PASSWORD];
            [usernamepasswordKVPairs setObject:userId forKey:KEY_USERID];
            [usernamepasswordKVPairs setObject:name forKey:KEY_USERNAME];
            [usernamepasswordKVPairs setObject:deptId forKey:KEY_DEPTID];
            [usernamepasswordKVPairs setObject:deviceTokenNum forKey:KEY_DEVICETOKEN];
            //save session
            [UserKeychain save:KEY_LOGINID_PASSWORD data:usernamepasswordKVPairs];
            
            NSLog(@"Employee ID : %@", [usernamepasswordKVPairs objectForKey:KEY_USERID]);
            NSLog(@"Employee Name : %@", [usernamepasswordKVPairs objectForKey:KEY_USERNAME]);
            // dismiss self
            [self cancelFunc:nil];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法访问，请检查网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    NSLog(@"request finished");    
}

- (IBAction)cancelFunc:(id) sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error.localizedDescription);
}

- (IBAction)backgroundTap:(id)sender {
    [txtUser resignFirstResponder];
    [txtPass resignFirstResponder];    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [txtUser becomeFirstResponder];
    UIGlossyButton *b;
    b = (UIGlossyButton*) [self.view viewWithTag: 1020];
	[b useWhiteLabel: YES];
    b.buttonCornerRadius = 2.0; 
    b.buttonBorderWidth = 1.0f;
	[b setStrokeType: kUIGlossyButtonStrokeTypeBevelUp];
    b.tintColor = b.borderColor = [UIColor colorWithRed:70.0f/255.0f green:105.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
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

#pragma mark UITextFieldDelegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	
	return YES;
}

@end
