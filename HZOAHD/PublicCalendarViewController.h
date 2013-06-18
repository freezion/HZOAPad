//
//  PublicCalendarViewController.h
//  HZOAHD
//
//  Created by Li Feng on 13-3-12.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Calendar.h"

@interface PublicCalendarViewController : UITableViewController{
    UILabel *eventTitleLabel;
    UILabel *locationLabel;
    UILabel *startDateLabel;
    UILabel *endDateLabel;
    
    UITableViewCell *notesCell;
    UITableViewCell *senderCell;
    
    Calendar *calendarObj;
    NSString *calenderId;
}

@property (nonatomic, retain) IBOutlet UILabel *eventTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationLabel;
@property (nonatomic, retain) IBOutlet UILabel *startDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *endDateLabel;

@property (nonatomic, retain) IBOutlet UITableViewCell *notesCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *senderCell;

@property (nonatomic, retain) NSString *calenderId;
@property (nonatomic, retain) Calendar *calendarObj;

@end
