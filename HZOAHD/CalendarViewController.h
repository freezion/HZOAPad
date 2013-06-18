//
//  CalendarViewController.h
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-7-30.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"
#import "Calendar.h"
#import "CalendarCell.h"
#import "EditCalendarViewController.h"

@interface CalendarViewController : UITableViewController<EGORefreshTableHeaderDelegate, UINavigationControllerDelegate, MBProgressHUDDelegate> {
	EKEventStore *eventStore;
	EKCalendar *defaultCalendar;
    NSMutableArray *eventsList;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    UIColor *defaultTintColor;
    UISegmentedControl *segmentedControl;
    MBProgressHUD *HUD;
    int segmentIndex;
    NSString *myCalendarType;
    
}

@property (nonatomic, retain) EKEventStore *eventStore;
@property (nonatomic, retain) EKCalendar *defaultCalendar;
@property (nonatomic, retain) NSMutableArray *eventsList;
@property (nonatomic, retain) UISegmentedControl *segmentedControl;
@property (nonatomic, retain) NSString *myCalendarType;
@property (nonatomic) int segmentIndex;

- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
