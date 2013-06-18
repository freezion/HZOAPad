//
//  ChooseMostViewController.m
//  HZOAHD
//
//  Created by Li Feng on 13-2-4.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import "ChooseMostViewController.h"
#import "Employee.h"
#import "ContactCell.h"

@implementation ChooseMostViewController
@synthesize buttonId;
@synthesize mostList;
@synthesize delegateSwitchView;
@synthesize delegateMail;
@synthesize delegateNotice;
@synthesize delegateSelectContact;
@synthesize delegateFrequentContact;

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
    mostList = [Employee getAllMostContact];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mostList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"EmployeeCell";
    
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Employee *employee = [self.mostList objectAtIndex:indexPath.row];
    cell.textOne.text=employee._name;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Employee *employee = [self.mostList objectAtIndex:indexPath.row];
//    [delegateInvitEmployee showContact:employee._id theName:employee._name];
    [delegateMail showContact:employee._id theName:employee._name withButton:buttonId];
    [delegateSelectContact showContact:employee._id theName:employee._name];
//    [delegateReply showContact:employee._id theName:employee._name withButton:buttonId];
//    [delegateForward showContact:employee._id theName:employee._name withButton:buttonId];
    [delegateNotice showContact:employee._id theName:employee._name];
//    [delegateMostContact showContact:employee._id theName:employee._name];
    [delegateSwitchView dismissViewController];
    
    
}


@end
