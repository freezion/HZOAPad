//
//  NewMainViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 13-1-4.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import "NewMainViewController.h"
#import "PopoverContentViewController.h"
#import "Employee.h"

@interface NewMainViewController ()

@end

@implementation NewMainViewController
@synthesize calendarButton;
@synthesize noticeButton;
@synthesize emailButton;
@synthesize folderButton;
@synthesize changeLoginButton;
@synthesize rightsButton;
@synthesize exitButton;
@synthesize popover;
@synthesize tableView;

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
	UIImage *tabBackground = [[UIImage imageNamed:@"featured_category_cell_background_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [calendarButton setBackgroundImage:tabBackground forState:UIControlStateHighlighted];
    [noticeButton setBackgroundImage:tabBackground forState:UIControlStateHighlighted];
    [emailButton setBackgroundImage:tabBackground forState:UIControlStateHighlighted];
    [folderButton setBackgroundImage:tabBackground forState:UIControlStateHighlighted];
    [changeLoginButton setBackgroundImage:tabBackground forState:UIControlStateHighlighted];
    [rightsButton setBackgroundImage:tabBackground forState:UIControlStateHighlighted];
    [exitButton setBackgroundImage:tabBackground forState:UIControlStateHighlighted];
    
    PopoverContentViewController *content = [[PopoverContentViewController alloc] init];
	
	// Setup the popover for use in the detail view.
	self.popover = [[UIPopoverController alloc] initWithContentViewController:content];
	self.popover.popoverContentSize = CGSizeMake(320., 320.);
	self.popover.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    NSArray *empList = [Employee getAllEmployee];
    if ([empList count] == 0) {
        [Employee synchronizeEmployee];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tappedButton:(id)sender {
    UIImage *tabBackground = [[UIImage imageNamed:@"featured_category_cell_background_selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [calendarButton setBackgroundImage:nil forState:UIControlStateNormal];
    [calendarButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [noticeButton setBackgroundImage:nil forState:UIControlStateNormal];
    [noticeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [emailButton setBackgroundImage:nil forState:UIControlStateNormal];
    [emailButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [folderButton setBackgroundImage:nil forState:UIControlStateNormal];
    [folderButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [changeLoginButton setBackgroundImage:nil forState:UIControlStateNormal];
    [changeLoginButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [rightsButton setBackgroundImage:nil forState:UIControlStateNormal];
    [rightsButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [exitButton setBackgroundImage:nil forState:UIControlStateNormal];
    [exitButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    if (sender == calendarButton) {
        [calendarButton setBackgroundImage:tabBackground forState:UIControlStateNormal];
        [calendarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [popover presentPopoverFromRect:calendarButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    } else if (sender == noticeButton) {
        [noticeButton setBackgroundImage:tabBackground forState:UIControlStateNormal];
        [noticeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else if (sender == emailButton) {
        [emailButton setBackgroundImage:tabBackground forState:UIControlStateNormal];
        [emailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else if (sender == folderButton) {
        [folderButton setBackgroundImage:tabBackground forState:UIControlStateNormal];
        [folderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else if (sender == changeLoginButton) {
        [changeLoginButton setBackgroundImage:tabBackground forState:UIControlStateNormal];
        [changeLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else if (sender == rightsButton) {
        [rightsButton setBackgroundImage:tabBackground forState:UIControlStateNormal];
        [rightsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else if (sender == exitButton) {
        [exitButton setBackgroundImage:tabBackground forState:UIControlStateNormal];
        [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return nil;
}


@end
