//
//  NewPageViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 13-1-
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import "NewPageViewController.h"
#import "CopyrightViewController.h"
#import "Notice.h"
#import "Calendar.h"
#import "Mail.h"
#import "MyFolder.h"
#import "NoticeCell.h"
#import "MailCell.h"
#import "CalendarCell.h"
#import "Employee.h"
#import "FrequentContactViewController.h"
#import "Customer.h"



@interface NewPageViewController ()

@end
BOOL refreshFlag = YES;

@implementation NewPageViewController
@synthesize idTextField;
@synthesize pwdTextField;
@synthesize titleLabel;
@synthesize calendarImageView;
@synthesize bgBottomImageView;
@synthesize bgTopImageView;
@synthesize noticeImageView;
@synthesize emailImageView;
@synthesize memberImageView;
@synthesize loginButton;
@synthesize mailList;
@synthesize noticeList;
@synthesize memberList;
@synthesize eventList;
@synthesize senderMailList;
@synthesize memberTableView;
@synthesize noticeTableView;
@synthesize eventTableView;
@synthesize mailTableView;
@synthesize mailSenderTableView;
@synthesize eventStore;
@synthesize defaultCalendar;
@synthesize calendarButton;
@synthesize noticeButton;
@synthesize emailButton;
@synthesize folderButton;
@synthesize changeLoginButton;
@synthesize rightsButton;
@synthesize helpButton;
@synthesize qlViewController;
@synthesize frequentContactButton;
@synthesize showNewImage;
//@synthesize calendarImage;
//@synthesize emailImage;
//@synthesize noticeImage;


-(IBAction) tabSelect:(id) sender {
    AppDelegate *d = [[UIApplication sharedApplication] delegate];
    ;
    if (sender == calendarButton) {
        self.tabBarController.selectedIndex = 1;
        d.calendarMessage = @"0";
    } else if (sender == noticeButton) {
        self.tabBarController.selectedIndex = 2;
        d.noticeMessage = @"0";
    } else if (sender == emailButton) {
        self.tabBarController.selectedIndex = 3;
        d.emailMessage = @"0";
    } else if (sender == folderButton) {
        self.tabBarController.selectedIndex = 4;
    }
}

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
    [self getCurVersion];
    [self getCurPosition];
	
    UIImage *calendarImage = [[UIImage imageNamed:@"sytable"] resizableImageWithCapInsets:UIEdgeInsetsMake(10,6,10,6)];
    calendarImageView.image = calendarImage;
    emailImageView.image = calendarImage;
    memberImageView.image = calendarImage;
    
    UIImage *noticeImage = [[UIImage imageNamed:@"sytable"] resizableImageWithCapInsets:UIEdgeInsetsMake(0,6,6,6)];
    
    noticeImageView.image = noticeImage;
    
    UIImage *bgBottomImage = [[UIImage imageNamed:@"mainpageElem3"] resizableImageWithCapInsets:UIEdgeInsetsMake(12,10,12,10)];
    bgBottomImageView.image = bgBottomImage;
    bgTopImageView.image = bgBottomImage;
    
    
    [Employee synchronizeEmployee];
    
    self.eventStore = [[EKEventStore alloc] init];
    NSArray *listCalendars = [eventStore calendars];
    for (EKCalendar *calendar in listCalendars) {
        NSLog(@"%@", calendar.title);
        if ([calendar.title isEqualToString:KEY_CALENDAR]) {
            self.defaultCalendar = calendar;
            break;
        }
    }
    
    deviceType = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).deviceType;
    deviceTokenNum = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).deviceTokenNum;
    model = [[UIDevice currentDevice] model];
    
    if ([model isEqualToString:@"iPad Simulator"]) {
        deviceType = @"0";
        deviceTokenNum = @"999";
    }
}

//获取当前版本信息
- (void) getCurVersion
{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    double app_Ver=[app_Version doubleValue];
    NSString *currVersion = [SystemConfig getVersion];
    
    if (app_Ver<[currVersion doubleValue]) {
        UIAlertView *alertVersion=[[UIAlertView alloc] initWithTitle:@"提示" message:@"发现新版本" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
        [alertVersion show];
        //New-32
        self.showNewImage.image = [UIImage imageNamed:@"new_PIC.png"];
    }else{
        self.showNewImage.image = [UIImage imageNamed:@""];
    }
}

- (void) goAppStore
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/hua-zhong-she-nei-ban-gong/id562881419?mt=8"]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        
    }else{
        [self goAppStore];
    }
}
//获得自己的当前的位置信息
- (void) getCurPosition
{
	//开始探测自己的位置
	if (locationManager == nil)
	{
		locationManager =[[CLLocationManager alloc] init];
	}
	
	if ([CLLocationManager locationServicesEnabled])
	{
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		locationManager.distanceFilter = kCLLocationAccuracyHundredMeters;
		[locationManager startUpdatingLocation];
	}
}

//响应当前位置的更新，在这里记录最新的当前位置
- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation
			fromLocation:(CLLocation *)oldLocation
{
    
    if (oldLocation == nil) {
        CLGeocoder* geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:
         ^(NSArray *placemarks, NSError *error){
             for (CLPlacemark *placemark in placemarks) {
                 
                 NSString *cityStr=[placemark.addressDictionary objectForKey:@"City"];
                 
                 NSLog(@"city %@",cityStr);
                 
                 NSString *Street=[placemark.addressDictionary objectForKey:@"Street"];
                 
                 NSLog(@"Street %@",Street);
                 
                 NSString *State=[placemark.addressDictionary objectForKey:@"State"];
                 
                 NSLog(@"State %@",State);
                 
                 NSString *ZIP=[placemark.addressDictionary objectForKey:@"ZIP"];
                 
                 NSLog(@"ZIP %@",ZIP);
                 
                 NSString *Country=[placemark.addressDictionary objectForKey:@"Country"];
                 
                 NSLog(@"Country %@",Country);
                 
                 NSString *CountryCode=[placemark.addressDictionary objectForKey:@"CountryCode"];
                 
                 NSLog(@"CountryCode %@",CountryCode);
                 
                 NSString *FormattedAddressLines=[placemark.addressDictionary objectForKey:@"FormattedAddressLines"];
                 
                 NSLog(@"FormattedAddressLines %@",FormattedAddressLines);
                 
                 if (State == nil) {
                     location = @"";
                 } else {
                     location = State;
                     if (cityStr != nil) {
                         location = [location stringByAppendingString:cityStr];
                     }
                     if (Street != nil) {
                         location = [location stringByAppendingString:Street];
                     }
                 }
                 
                 NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
                 NSString *activeFlag = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).activeFlag;
                 if ([@"1" isEqualToString:activeFlag]) {
                     Customer *customer = [[Customer alloc] init];
                     customer.LoginType = @"1";
                     customer.deviceType = model;
                     customer.deviceToken = [usernamepasswordKVPairs objectForKey:KEY_DEVICETOKEN];
                     customer.Location = location;
                     customer.EmpID = [usernamepasswordKVPairs objectForKey:KEY_USERID];
                     [Customer takeStatus:customer];
    
                     
                     ((AppDelegate *)[[UIApplication sharedApplication] delegate]).activeFlag = @"0";
                 }
                 break;
             }
         }];
    }
}
-(IBAction)showFrequentContact:(id)sender{
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    FrequentContactViewController *frequentContactViewController = [storyborad instantiateViewControllerWithIdentifier:@"FrequentContactViewController"];
    UINavigationController *freNavController = [[UINavigationController alloc] initWithRootViewController:frequentContactViewController];
    [self presentModalViewController:freNavController animated:YES];
    
}

-(IBAction) refreshAllTables:(id)sender {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    if (usernamepasswordKVPairs == nil) {
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        LoginViewController *loginViewController = [storyborad instantiateViewControllerWithIdentifier:@"loginViewController"];
        [self presentModalViewController:loginViewController animated:NO];
    } else {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.dimBackground = YES;
        [HUD setDelegate:self];
        [HUD setLabelText:@"数据加载中"];
        [HUD showWhileExecuting:@selector(synthesizePage) onTarget:self withObject:nil animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    double app_Ver=[app_Version doubleValue];
    NSString *currVersion = [SystemConfig getVersion];
    
    if (app_Ver<[currVersion doubleValue]) {
        self.showNewImage.image = [UIImage imageNamed:@"new_PIC.png"];
    }else{
        self.showNewImage.image = [UIImage imageNamed:@""];
    }
    
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    if (usernamepasswordKVPairs == nil) {
        //        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        //        LoginViewController *loginViewController = [storyborad instantiateViewControllerWithIdentifier:@"loginViewController"];
        //        [self presentModalViewController:loginViewController animated:NO];
        
        self.tabBarController.tabBar.hidden = YES;
        
        UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        darkView.alpha = 0.5;
        darkView.backgroundColor = [UIColor blackColor];
        darkView.tag = 9;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
        [darkView addGestureRecognizer:tapGesture];
        [self.view addSubview:darkView];
        
        UIImage *image = [UIImage imageNamed:@"login.jpg"];
        UIImageView *loginView = [[UIImageView alloc] initWithImage:image];
        loginView.tag = 10;
        loginView.frame = CGRectMake(312, 84, 400, 400);
        [self.view addSubview:loginView];
        
        UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(350, 250, 100, 24)];
        idLabel.text = @"登录ID:";
        idLabel.backgroundColor = [UIColor clearColor];
        idLabel.tag = 11;
        [self.view addSubview:idLabel];
        
        UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(350, 300, 100, 24)];
        pwdLabel.text = @"密   码:";
        pwdLabel.backgroundColor = [UIColor clearColor];
        pwdLabel.tag = 12;
        [self.view addSubview:pwdLabel];
        
        idTextField = [[UITextField alloc] initWithFrame:CGRectMake(420, 250, 250, 28)];
        idTextField.tag = 13;
        idTextField.placeholder = @"输入登录ID";
        idTextField.borderStyle = UITextBorderStyleRoundedRect;
        idTextField.keyboardType = UIKeyboardTypeAlphabet;
        idTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.view addSubview:idTextField];
        
        [idTextField becomeFirstResponder];
        
        pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(420, 300, 250, 28)];
        pwdTextField.tag = 14;
        pwdTextField.placeholder = @"输入密码";
        pwdTextField.borderStyle = UITextBorderStyleRoundedRect;
        pwdTextField.keyboardType = UIKeyboardTypeAlphabet;
        pwdTextField.secureTextEntry = YES;
        [self.view addSubview:pwdTextField];
        
        loginButton = [[UIGlossyButton alloc]initWithFrame:CGRectMake(570, 350, 100, 40)];
        loginButton.tag = 15;
        [loginButton useWhiteLabel: YES];
        [loginButton setTitle:NSLocalizedString(@"登  录", nil) forState:UIControlStateNormal];
        loginButton.buttonCornerRadius = 2.0;
        loginButton.buttonBorderWidth = 1.0f;
        [loginButton setStrokeType: kUIGlossyButtonStrokeTypeBevelUp];
        loginButton.tintColor = loginButton.borderColor = [UIColor colorWithRed:70.0f/255.0f green:105.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
        [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:loginButton];
    }
    else {
        
        if (refreshFlag) {
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.dimBackground = YES;
            [HUD setDelegate:self];
            [HUD setLabelText:@"数据加载中"];
            [HUD showWhileExecuting:@selector(synthesizePage) onTarget:self withObject:nil animated:YES];
            refreshFlag = NO;
        }
        
    }
}

- (void)synthesizePage {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    // notice
    [Notice synchronizeNotice:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    noticeList = [Notice synchronizeNotice:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
   // noticeList = [Notice getLocalNotice:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
        [self.noticeTableView reloadData];
    // Event
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    NSTimeInterval  interval = 24 * 60 * 60 * 31;
    NSDate *threeDayAfter = [currentDate initWithTimeIntervalSinceNow:+interval];
    //NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
    //eventList = [self fetchEventsForToday:currentDate];
   // eventList = [Calendar getCalendarDataByDateTime:currentDate withEndDate:threeDayAfter withEmployeeId:[usernamepasswordKVPairs objectForKey:KEY_USERID] withCalendar:nil];
    eventList = [Calendar getAllMyData:[usernamepasswordKVPairs objectForKey:KEY_USERID] withStartDate:currentDate withEndDate:threeDayAfter];
        [self.eventTableView reloadData];
    // Email
    [Mail synchronizeEmail:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    mailList = [Mail getLocalReciveEmail:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
        [self.mailTableView reloadData];
    // sender Email
    senderMailList = [Mail getLocalSenderEmail:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
        [self.mailSenderTableView reloadData];
    
    memberList = [MyFolder getAllCompany];
        [self.memberTableView reloadData];
    
    
//        AppDelegate *d = [[UIApplication sharedApplication] delegate];
//        ;
//        NSString *calendarKey = d.calendarMessage;
//        NSString *emailKey = d.emailMessage;
//        NSString *noticeKey = d.noticeMessage;
//        if ([calendarKey isEqualToString:@"1"]) {
//            self.calendarImage.image = [UIImage imageNamed:@"New-32.png"];
//        } else {
//            self.calendarImage.image = [UIImage imageNamed:@""];
//        }
//    
//        if ([emailKey isEqualToString:@"1"]) {
//            self.emailImage.image = [UIImage imageNamed:@"New-32.png"];
//        } else {
//            self.emailImage.image = [UIImage imageNamed:@""];
//        }
//    
//       if ([noticeKey isEqualToString:@"1"]) {
//            self.noticeImage.image = [UIImage imageNamed:@"New-32.png"];
//        } else {
//            self.noticeImage.image = [UIImage imageNamed:@""];
//        }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction) showReLogin:(id) sender {
    
    self.tabBarController.tabBar.hidden = YES;    
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    UIImage *image = [UIImage imageNamed:@"login.jpg"];
    UIImageView *loginView = [[UIImageView alloc] initWithImage:image];
    loginView.tag = 10;
    loginView.frame = CGRectMake(312, 84, 400, 400);
    [self.view addSubview:loginView];
    
    UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(350, 250, 100, 24)];
    idLabel.text = @"登录ID:";
    idLabel.backgroundColor = [UIColor clearColor];
    idLabel.tag = 11;
    [self.view addSubview:idLabel];
    
    UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(350, 300, 100, 24)];
    pwdLabel.text = @"密   码:";
    pwdLabel.backgroundColor = [UIColor clearColor];
    pwdLabel.tag = 12;
    [self.view addSubview:pwdLabel];
    
    idTextField = [[UITextField alloc] initWithFrame:CGRectMake(420, 250, 250, 28)];
    idTextField.tag = 13;
    idTextField.placeholder = @"输入登录ID";
    idTextField.borderStyle = UITextBorderStyleRoundedRect;
    idTextField.keyboardType = UIKeyboardTypeAlphabet;
    idTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:idTextField];
    
    [idTextField becomeFirstResponder];
    
    pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(420, 300, 250, 28)];
    pwdTextField.tag = 14;
    pwdTextField.placeholder = @"输入密码";
    pwdTextField.borderStyle = UITextBorderStyleRoundedRect;
    pwdTextField.keyboardType = UIKeyboardTypeAlphabet;
    pwdTextField.secureTextEntry = YES;
    [self.view addSubview:pwdTextField];
    
    loginButton = [[UIGlossyButton alloc]initWithFrame:CGRectMake(570, 350, 100, 40)];
    loginButton.tag = 15;
	[loginButton useWhiteLabel: YES];
    [loginButton setTitle:NSLocalizedString(@"登  录", nil) forState:UIControlStateNormal];
    loginButton.buttonCornerRadius = 2.0;
    loginButton.buttonBorderWidth = 1.0f;
	[loginButton setStrokeType: kUIGlossyButtonStrokeTypeBevelUp];
    loginButton.tintColor = loginButton.borderColor = [UIColor colorWithRed:70.0f/255.0f green:105.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(425, 150, 200, 50)];
    titleLabel.text = @"Intranet";
    titleLabel.font = [UIFont systemFontOfSize:50];
    titleLabel.tag = 16;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.tag = 17;
    [closeButton setBackgroundImage:[UIImage imageNamed:@"fileclose.png"] forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(670, 87, 30, 30);
    [closeButton addTarget:self action:@selector(removeViews:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    darkView.alpha = 0.5;
    [UIView commitAnimations];
    
    //    noticeList = nil;
    //    memberList = nil;
    //    eventList = nil;
    //    mailList = nil;
    //    senderMailList = nil;
    //    [self.noticeTableView reloadData];
    //    [self.eventTableView reloadData];
    //    [self.mailTableView reloadData];
    //    [self.mailSenderTableView reloadData];
    //    [self.memberTableView reloadData];
}

- (void)removeViews:(id)object {
    self.tabBarController.tabBar.hidden = NO;
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
    [[self.view viewWithTag:12] removeFromSuperview];
    [[self.view viewWithTag:13] removeFromSuperview];
    [[self.view viewWithTag:14] removeFromSuperview];
    [[self.view viewWithTag:15] removeFromSuperview];
    [[self.view viewWithTag:16] removeFromSuperview];
    [[self.view viewWithTag:17] removeFromSuperview];
}

- (void)hideKeyboard:(id)sender {
    [idTextField resignFirstResponder];
    [pwdTextField resignFirstResponder];
}

- (void)dismissDatePicker:(id)sender {
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
}

- (IBAction) showCopyRights:(id) sender {
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    CopyrightViewController *copyrightViewController = [storyborad instantiateViewControllerWithIdentifier:@"CopyrightViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:copyrightViewController];
    [self presentModalViewController:navigationController animated:YES];
}

- (void)login {
    [idTextField resignFirstResponder];
    [pwdTextField resignFirstResponder];
    //验证用户名 密码
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.dimBackground = YES;
    [HUD setDelegate:self];
    [HUD setLabelText:@"提交验证"];
    [HUD showWhileExecuting:@selector(myLoginTask) onTarget:self withObject:nil animated:YES];
}

- (void)myLoginTask {
    NSString *user = [idTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *pass = [pwdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *webserviceUrl = [WEBSERVICE_ADDRESS stringByAppendingString:@"UserCheck.asmx/loginUserCheckForIOS"];
    NSURL *url = [NSURL URLWithString:webserviceUrl];
    
    deviceType = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).deviceType;
    deviceTokenNum = ((AppDelegate *)[[UIApplication sharedApplication] delegate]).deviceTokenNum;
    
    model = [[UIDevice currentDevice] model];
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
            NSArray *listItems = [xmlString componentsSeparatedByString:@","];
            NSString *userId = [listItems objectAtIndex:0];
            NSString *name = [listItems objectAtIndex:1];
            NSString *deptId = [listItems objectAtIndex:2];
            NSString *canRead = [listItems objectAtIndex:3];
            //用户名和密码存入keychain
            NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
            [usernamepasswordKVPairs setObject:idTextField.text forKey:KEY_LOGINID];
            [usernamepasswordKVPairs setObject:pwdTextField.text forKey:KEY_PASSWORD];
            [usernamepasswordKVPairs setObject:userId forKey:KEY_USERID];
            [usernamepasswordKVPairs setObject:name forKey:KEY_USERNAME];
            [usernamepasswordKVPairs setObject:deptId forKey:KEY_DEPTID];
            [usernamepasswordKVPairs setObject:canRead forKey:KEY_READ_CONTRACT];
            [usernamepasswordKVPairs setObject:deviceTokenNum forKey:KEY_DEVICETOKEN];
            
            //save session
            [UserKeychain save:KEY_LOGINID_PASSWORD data:usernamepasswordKVPairs];
            //9602320c06c5cd3c
            NSLog(@"Employee ID : %@", [usernamepasswordKVPairs objectForKey:KEY_USERID]);
            NSLog(@"Employee Name : %@", [usernamepasswordKVPairs objectForKey:KEY_USERNAME]);
            // dismiss self
            [self removeViews:nil];
            
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            HUD.dimBackground = YES;
            [HUD setDelegate:self];
            [HUD setLabelText:@"数据加载中"];
            [HUD showWhileExecuting:@selector(synthesizePage) onTarget:self withObject:nil animated:YES];
            refreshFlag = NO;
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无法访问，请检查网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    NSLog(@"request finished");
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error.localizedDescription);
}

-(IBAction) logout:(id)sender {
    [UserKeychain delete:KEY_LOGINID_PASSWORD];
    [self showExit:nil];
    
}

-(void) showExit:(id) sender {
    
    self.tabBarController.tabBar.hidden = YES;
    
    UIView *darkView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    UIImage *image = [UIImage imageNamed:@"login.jpg"];
    UIImageView *loginView = [[UIImageView alloc] initWithImage:image];
    loginView.tag = 10;
    loginView.frame = CGRectMake(312, 84, 400, 400);
    [self.view addSubview:loginView];
    
    UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(350, 250, 100, 24)];
    idLabel.text = @"登录ID:";
    idLabel.backgroundColor = [UIColor clearColor];
    idLabel.tag = 11;
    [self.view addSubview:idLabel];
    
    UILabel *pwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(350, 300, 100, 24)];
    pwdLabel.text = @"密   码:";
    pwdLabel.backgroundColor = [UIColor clearColor];
    pwdLabel.tag = 12;
    [self.view addSubview:pwdLabel];
    
    idTextField = [[UITextField alloc] initWithFrame:CGRectMake(420, 250, 250, 28)];
    idTextField.tag = 13;
    idTextField.placeholder = @"输入登录ID";
    idTextField.borderStyle = UITextBorderStyleRoundedRect;
    idTextField.keyboardType = UIKeyboardTypeAlphabet;
    idTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:idTextField];
    
    [idTextField becomeFirstResponder];
    
    pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(420, 300, 250, 28)];
    pwdTextField.tag = 14;
    pwdTextField.placeholder = @"输入密码";
    pwdTextField.borderStyle = UITextBorderStyleRoundedRect;
    pwdTextField.keyboardType = UIKeyboardTypeAlphabet;
    pwdTextField.secureTextEntry = YES;
    [self.view addSubview:pwdTextField];
    
    loginButton = [[UIGlossyButton alloc]initWithFrame:CGRectMake(570, 350, 100, 40)];
    loginButton.tag = 15;
	[loginButton useWhiteLabel: YES];
    [loginButton setTitle:NSLocalizedString(@"登  录", nil) forState:UIControlStateNormal];
    loginButton.buttonCornerRadius = 2.0;
    loginButton.buttonBorderWidth = 1.0f;
	[loginButton setStrokeType: kUIGlossyButtonStrokeTypeBevelUp];
    loginButton.tintColor = loginButton.borderColor = [UIColor colorWithRed:70.0f/255.0f green:105.0f/255.0f blue:192.0f/255.0f alpha:1.0f];
    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(425, 150, 200, 50)];
    titleLabel.text = @"Intranet";
    titleLabel.font = [UIFont systemFontOfSize:50];
    titleLabel.tag = 16;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    
    //UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //closeButton.tag = 17;
    //[closeButton setBackgroundImage:[UIImage imageNamed:@"fileclose.png"] forState:UIControlStateNormal];
    //closeButton.frame = CGRectMake(670, 87, 30, 30);
    //[closeButton addTarget:self action:@selector(removeViews:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:closeButton];
    
    [UIView beginAnimations:@"MoveIn" context:nil];
    darkView.alpha = 0.5;
    [UIView commitAnimations];
    
    noticeList = nil;
    memberList = nil;
    eventList = nil;
    mailList = nil;
    senderMailList = nil;
    [self.noticeTableView reloadData];
    [self.eventTableView reloadData];
    [self.mailTableView reloadData];
    [self.mailSenderTableView reloadData];
    [self.memberTableView reloadData];
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == noticeTableView) {
        Notice *noticeObj = [self.noticeList objectAtIndex:indexPath.row];
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        NoticeDetailViewController *noticeDetailViewController = [storyborad instantiateViewControllerWithIdentifier:@"NoticeDetailViewController"];
        noticeDetailViewController.notice = noticeObj;
        noticeDetailViewController.frontFlag = @"front";
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:noticeDetailViewController];
        [self presentModalViewController:nav animated:YES];
        
    } else if (tableView == eventTableView) {
        Calendar *calendarObj = [self.eventList objectAtIndex:indexPath.row];
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        EditCalendarViewController *editCalendarViewController = [storyborad instantiateViewControllerWithIdentifier:@"EditCalendarViewController"];
        editCalendarViewController.calenderId = calendarObj.ID;
        editCalendarViewController.frontFlag = @"front";
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:editCalendarViewController];
        [self presentModalViewController:nav animated:YES];
    } else if (tableView == mailTableView) {
        Mail *mailObj = [self.mailList objectAtIndex:indexPath.row];
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        MailDetailViewController *mailDetailViewController = [storyborad instantiateViewControllerWithIdentifier:@"MailDetailViewController"];
        mailDetailViewController.mail = mailObj;
        mailDetailViewController.frontFlag = @"front";
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mailDetailViewController];
        [self presentModalViewController:nav animated:YES];
    } else if (tableView == mailSenderTableView) {
        Mail *mailObj = [self.senderMailList objectAtIndex:indexPath.row];
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        MailDetailViewController *mailDetailViewController = [storyborad instantiateViewControllerWithIdentifier:@"MailDetailViewController"];
        mailDetailViewController.mail = mailObj;
        mailDetailViewController.frontFlag = @"front";
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mailDetailViewController];
        [self presentModalViewController:nav animated:YES];
    } else if (tableView == memberTableView) {
        MyFolder *myFolder = [self.memberList objectAtIndex:indexPath.row];
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        FileViewController *fileViewController = [storyborad instantiateViewControllerWithIdentifier:@"FileViewController"];
        fileViewController.memberId = myFolder.folderID;
        fileViewController.needCancel = @"need";
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:fileViewController];
        [self presentModalViewController:nav animated:YES];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
    //                               reuseIdentifier:CellIdentifier]
    if (tableView == noticeTableView) {
        NoticeCell *cell = (NoticeCell *)[tableView dequeueReusableCellWithIdentifier:@"NoticeCell"];
        //NoticeCell *cell = (NoticeCell *)[tableView dequeueReusableCellWithIdentifier:@"NoticeCell"];
        Notice *notice = [self.noticeList objectAtIndex:indexPath.row];
        cell.nameLabel.text = notice.title;
        cell.detailLabel.text = notice.context;
        cell.dateLabel.text = notice.date;
        cell.senderLabel.text = notice.sender;
//        cell.typeLabel.text = notice.typeName;
//        if ([notice.readed isEqualToString:@"0"]) {
//            cell.readImageView.image = [UIImage imageNamed:@"y.png"];
//        } else {
//            cell.readImageView.image = [UIImage imageNamed:@""];
//        }
        return cell;
    } else if (tableView == eventTableView) {
        CalendarCell *cell = (CalendarCell *)[tableView dequeueReusableCellWithIdentifier:@"CalendarCell"];
        Calendar *calendarObj = [self.eventList objectAtIndex:indexPath.row];
        cell.eventNameLabel.text = calendarObj.Title;
        if ([calendarObj.AllDay isEqualToString:@"1"]) {
            cell.startTimeLabel.hidden = YES;
            cell.endTimeLabel.hidden = YES;
            cell.startTextLabel.hidden = YES;
            cell.endTextLabel.hidden = YES;
            cell.alldayImage.image = [UIImage imageNamed:@"24h.png"];
        } else {
            cell.startTimeLabel.text = [NSUtil parserStringToCustomStringAdv:calendarObj.StartTime withParten:@"yyyy-MM-dd HH:mm:ss" withToParten:@"HH:mm"];
            cell.endTimeLabel.text = [NSUtil parserStringToCustomStringAdv:calendarObj.EndTime withParten:@"yyyy-MM-dd HH:mm:ss" withToParten:@"HH:mm"];
            cell.alldayImage.image = [UIImage imageNamed:@""];
        }
        return cell;
    } else if (tableView == mailTableView) {
        MailCell *cell = (MailCell *)[tableView dequeueReusableCellWithIdentifier:@"MailCell"];
        Mail *mail = [self.mailList objectAtIndex:indexPath.row];
        cell.titleLabel.text = mail.title;
        //cell.detailLabel.text = mail.context;
        cell.dateLabel.text = mail.date;
        cell.senderLabel.text = mail.senderName;
        //cell.importLabel.text = mail.importName;
        return cell;
    } else if (tableView == mailSenderTableView) {
        MailCell *cell = (MailCell *)[tableView dequeueReusableCellWithIdentifier:@"MailCell"];
        Mail *mail = [self.senderMailList objectAtIndex:indexPath.row];
        cell.titleLabel.text = mail.title;
        //cell.detailLabel.text = mail.context;
        cell.dateLabel.text = mail.date;
        cell.senderLabel.text = mail.senderName;
       // cell.importLabel.text = mail.importName;
        return cell;
    } else if (tableView == memberTableView) {
        FileCell *cell = (FileCell *)[tableView dequeueReusableCellWithIdentifier:@"FileCell"];
        MyFolder *myFolder = [self.memberList objectAtIndex:indexPath.row];
        cell.fileName.text = myFolder.companyNameCN;
        return cell;
    }
    return nil;
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
    int count = 0;
    if (tableView == noticeTableView) {
        count = [noticeList count];
    } else if (tableView == eventTableView) {
        count = [eventList count];
    } else if (tableView == mailTableView) {
        count = [mailList count];
    } else if (tableView == mailSenderTableView) {
        count = [senderMailList count];
    } else if (tableView == memberTableView) {
        count = [memberList count];
    }
    return count;
}

-(IBAction) tappedHelp:(id)sender {
    qlViewController = [[QLPreviewController alloc] init];
    qlViewController.dataSource = self;
    qlViewController.delegate = self;
    qlViewController.title = @"帮助";
    qlViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked)];
    qlViewController.navigationItem.rightBarButtonItem.title = @"";
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:qlViewController];
    
    [self presentModalViewController:navigationController animated:YES];
}

- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}

- (void) cancelClicked {
    [qlViewController.navigationController dismissModalViewControllerAnimated:YES];
}

- (id <QLPreviewItem>)previewController: (QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"Intranet_iPad" ofType:@"doc" inDirectory:@"/"]];;
}

- (void) viewWillAppear:(BOOL)animated {
    //[[qlViewController navigationItem] setRightBarButtonItem:nil];
}

@end
