//
//  NewPageViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 13-1-7.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "LoginViewController.h"
#import "UserKeychain.h"
#import "MBProgressHUD.h"
#import "UIGlossyButton.h"
#import "NoticeDetailViewController.h"
#import "MailDetailViewController.h"
#import "EditCalendarViewController.h"
#import "FileViewController.h"
#import "SystemConfig.h"
#import <QuickLook/QuickLook.h>

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface NewPageViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate, QLPreviewControllerDataSource, QLPreviewControllerDelegate,CLLocationManagerDelegate> {
    UIImageView *bgTopImageView;
    UIImageView *bgBottomImageView;
    UIImageView *calendarImageView;
    UIImageView *noticeImageView;
    UIImageView *emailImageView;
    UIImageView *memberImageView;
    MBProgressHUD *HUD;
    UILabel *titleLabel;
    EKEventStore *eventStore;
    EKCalendar *defaultCalendar;
    UIButton *calendarButton;
    UIButton *noticeButton;
    UIButton *emailButton;
    UIButton *folderButton;
    UIButton *changeLoginButton;
    UIButton *rightsButton;
    UIImageView *showNewImage;
    UIButton *helpButton;
    
    UIButton *frequentContactButton;
//    UIImageView *calendarImage;
//    UIImageView *emailImage;
//    UIImageView *noticeImage;
    QLPreviewController *qlViewController;
    
    CLLocationManager *locationManager;
    CLLocationCoordinate2D curLocation;
    
    NSString *deviceType;
    NSString *deviceTokenNum;
    NSString *model;
    NSString *location;
    
}

@property (nonatomic, retain) IBOutlet QLPreviewController *qlViewController;
@property (nonatomic, retain) IBOutlet UIButton *helpButton;
@property (nonatomic, retain) IBOutlet UITableView *memberTableView;
@property (nonatomic, retain) IBOutlet UITableView *noticeTableView;
@property (nonatomic, retain) IBOutlet UITableView *eventTableView;
@property (nonatomic, retain) IBOutlet UITableView *mailTableView;
@property (nonatomic, retain) IBOutlet UITableView *mailSenderTableView;
@property (nonatomic, retain) IBOutlet UIImageView *bgTopImageView;
@property (nonatomic, retain) IBOutlet UIImageView *bgBottomImageView;
@property (nonatomic, retain) IBOutlet UIImageView *calendarImageView;
@property (nonatomic, retain) IBOutlet UIImageView *noticeImageView;
@property (nonatomic, retain) IBOutlet UIImageView *emailImageView;
@property (nonatomic, retain) IBOutlet UIImageView *memberImageView;
@property (nonatomic, retain) UITextField *idTextField;
@property (nonatomic, retain) UITextField *pwdTextField;
@property (nonatomic, strong) NSMutableArray *noticeList;
@property (nonatomic, retain) NSMutableArray *memberList;
@property (nonatomic, retain) NSArray *eventList;
@property (nonatomic, retain) NSMutableArray *mailList;
@property (nonatomic, retain) NSMutableArray *senderMailList;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIGlossyButton *loginButton;
@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic, retain) IBOutlet UIButton *calendarButton;
@property (nonatomic, retain) IBOutlet UIButton *noticeButton;
@property (nonatomic, retain) IBOutlet UIButton *emailButton;
@property (nonatomic, retain) IBOutlet UIButton *folderButton;
@property (nonatomic, retain) IBOutlet UIButton *changeLoginButton;
@property (nonatomic, retain) IBOutlet UIButton *rightsButton;
@property (nonatomic, retain) IBOutlet UIImageView *showNewImage;
@property (nonatomic, retain) IBOutlet UIButton *frequentContactButton;
//@property (nonatomic, retain) IBOutlet UIImageView *calendarImage;
//@property (nonatomic, retain) IBOutlet UIImageView *emailImage;
//@property (nonatomic, retain) IBOutlet UIImageView *noticeImage;


-(IBAction) tabSelect:(id) sender;
-(IBAction) showReLogin:(id) sender;
-(IBAction) showCopyRights:(id) sender;
-(IBAction) refreshAllTables:(id)sender;
-(IBAction) logout:(id)sender;
-(IBAction) tappedHelp:(id)sender;

-(IBAction)showFrequentContact:(id)sender;

@end
