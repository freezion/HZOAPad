//
//  PublicCalendarViewController.m
//  HZOAHD
//
//  Created by Li Feng on 13-3-12.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import "PublicCalendarViewController.h"

@implementation PublicCalendarViewController
@synthesize eventTitleLabel;
@synthesize startDateLabel;
@synthesize endDateLabel;
@synthesize locationLabel;
@synthesize notesCell;
@synthesize senderCell;
@synthesize calendarObj;
@synthesize calenderId;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"事件详细资料";
   // NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    calendarObj = [Calendar getSingleOpenCanlendar:calenderId];
    
    eventTitleLabel.text = calendarObj.Title;
    locationLabel.text = calendarObj.Location;
    startDateLabel.text = [NSUtil parserStringToCustomStringAdv:calendarObj.StartTime withParten:@"yyyy-MM-dd HH:mm:ss" withToParten:@"yyyy年M月d日 HH:mm"];
    endDateLabel.text = [NSUtil parserStringToCustomStringAdv:calendarObj.EndTime withParten:@"yyyy-MM-dd HH:mm:ss" withToParten:@"yyyy年M月d日 HH:mm"];
    
    senderCell.detailTextLabel.text = calendarObj.senderName;
    
    if ([calendarObj.Note isEqualToString:@""] || calendarObj.Note == nil) {
        notesCell.detailTextLabel.text = @"";
    } else {
        notesCell.detailTextLabel.text = calendarObj.Note;
    }
    
}
@end
