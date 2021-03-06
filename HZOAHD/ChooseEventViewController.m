//
//  ChooseEventViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-24.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "ChooseEventViewController.h"
#import "CalendarViewController.h"

@interface ChooseEventViewController ()

@end

@implementation ChooseEventViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MyEventPick"])
	{
        CalendarViewController *calendarViewController = segue.destinationViewController;
        calendarViewController.myCalendarType = @"EventPick";
    }
    else if ([segue.identifier isEqualToString:@"MyInvationPick"])
	{
        CalendarViewController *calendarViewController = segue.destinationViewController;
        calendarViewController.myCalendarType = @"InvationPick";
    }
    else if ([segue.identifier isEqualToString:@"MyConformPick"])
	{
        CalendarViewController *calendarViewController = segue.destinationViewController;
        calendarViewController.myCalendarType = @"ConformPick";
    }
    else if ([segue.identifier isEqualToString:@"PublicEventPick"])
	{
        CalendarViewController *calendarViewController = segue.destinationViewController;
        calendarViewController.myCalendarType = @"PublicEventPick";
    }
    
}

@end
