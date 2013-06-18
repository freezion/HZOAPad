//
//  AddCalendarViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-11.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "CheckCalendarViewController.h"
#import "SelectContactViewController.h"
#import "EventAlertViewController.h"
#import "EventTypeViewController.h"
#import "Calendar.h"
#import "SearchCustomerViewController.h"
#import "UIGlossyButton.h"
#import "MBProgressHUD.h"

@protocol AddCalendarDelegate <NSObject>
- (void)changeFrontFlag;
@end

@interface AddCalendarViewController : UITableViewController <CheckCalendarDelegate, SelectContactViewControllerDelegate, EventAlertViewDelegate, EventTypeViewDelegate, SearchCustomerDelegate,UIAlertViewDelegate, MBProgressHUDDelegate> {
    id<AddCalendarDelegate> delegate;
    MBProgressHUD *HUD;
    UITextField *txtTitle;
    UITextField *txtLocation;
    UILabel *startLabel;
    UILabel *endLabel;
    UILabel *invitionLabel;
    UILabel *alertLabel;
    UILabel *typeLabel;
    UITextField *txtNotes;
    NSDate *startDateT;
    NSDate *endDateT;
    BOOL stateAllDay;
    NSMutableArray *tokenList;
    NSString *reminder;
    NSString *customerIdLocal;
    NSString *contractIdLocal;
    int selectIndexSave;
    int selectIndexType;
    int selectIndexType1;
    int selectIndexCustomer;
    int selectIndexContract;
    NSString *eventTypeId;
    UISwitch *switchImport;
    UILabel *importLabel;
    UILabel *customerNameLabel;
    UILabel *contractIdLabel;
    UILabel *contractStartLabel;
    UILabel *contractEndLabel;
    UIGlossyButton *deleteEventButton;
    BOOL editFlag;
    Calendar *calendarObj;
    NSMutableDictionary *usernamepasswordKVPairs;
    NSString *invationsLocal;
    NSMutableDictionary *listContactIdLocal;
    UIAlertView *alertAdd;
    UIAlertView *alertEdit;
    UITableViewCell *customerCell;
    
    UISwitch *switchPrivate;
    UILabel *privateLable;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *customerCell;
@property (nonatomic, retain) id<AddCalendarDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIGlossyButton *deleteEventButton;
@property (nonatomic, retain) IBOutlet UITextField *txtTitle;
@property (nonatomic, retain) IBOutlet UITextField *txtLocation;
@property (nonatomic, retain) IBOutlet UILabel *startLabel;
@property (nonatomic, retain) IBOutlet UILabel *endLabel;
@property (nonatomic, retain) IBOutlet UILabel *invitionLabel;
@property (nonatomic, retain) IBOutlet UILabel *alertLabel;
@property (nonatomic, retain) IBOutlet UILabel *typeLabel;
@property (nonatomic, retain) IBOutlet UITextField *txtNotes;
@property (nonatomic, retain) IBOutlet UISwitch *switchImport;
@property (nonatomic, retain) IBOutlet UILabel *importLabel;
@property (nonatomic, retain) IBOutlet UILabel *customerNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *contractIdLabel;
@property (nonatomic, retain) IBOutlet UILabel *contractStartLabel;
@property (nonatomic, retain) IBOutlet UILabel *contractEndLabel;
@property (nonatomic, retain) IBOutlet UISwitch *switchPrivate;
@property (nonatomic, retain) IBOutlet UILabel *privateLable;
@property (nonatomic, retain) NSDate *startDateT;
@property (nonatomic, retain) NSDate *endDateT;
@property (nonatomic) BOOL stateAllDay;
@property (nonatomic) BOOL editFlag;
@property (nonatomic, retain) NSMutableArray *tokenList;
@property (nonatomic, retain) NSString *eventTypeId;
@property (nonatomic) int selectIndexSave;
@property (nonatomic) int selectIndexType;
@property (nonatomic) int selectIndexType1;
@property (nonatomic) int selectIndexCustomer;
@property (nonatomic) int selectIndexContract;
@property (nonatomic, retain) NSString *reminder;
@property (nonatomic, retain) NSString *customerIdLocal;
@property (nonatomic, retain) NSString *contractIdLocal;
@property (nonatomic, retain) NSString *invationsLocal;
@property (nonatomic, retain) NSMutableDictionary *listContactIdLocal;
@property (nonatomic, retain) Calendar *calendarObj;


- (IBAction)deleteEvent:(id) sender;

@end
