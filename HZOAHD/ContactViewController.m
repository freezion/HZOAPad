//
//  ContactViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-3.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "ContactViewController.h"


@interface ContactViewController ()

@end

@implementation ContactViewController

@synthesize list;
@synthesize dictionary;
@synthesize delegate;
@synthesize delegateMail;
@synthesize delegateContact;
@synthesize buttonId;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"选择发送人";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(doCancel)];
    
    [[self navigationItem] setLeftBarButtonItem:cancelButton];
    self.dictionary = [[NSMutableDictionary alloc] init];
	//分配给list
	self.list = [NSArray arrayWithArray:[Employee getAllEmployee]];
    for (int i = 0; i < [list count]; i ++) {
        Employee *employee = [list objectAtIndex:i];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        if (i == 0) {
            [array addObject:employee];
            [dictionary setObject:array forKey:employee._partyName];
        }
        for (NSString *currentValue in [dictionary allKeys])
        {
            if ([currentValue isEqualToString:employee._partyName]) {
                array = [dictionary objectForKey:employee._partyName];
                [array addObject:employee];
                [dictionary setObject:array forKey:employee._partyName];
            } else {
                [array addObject:employee];
                [dictionary setObject:array forKey:employee._partyName];
            }
        }
    }
    NSLog(@"dictionary === %@", dictionary);
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

- (void)doCancel {
    [self dismissModalViewControllerAnimated:YES];
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
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContactCell";
    	
	ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:CellIdentifier];
	}
    
	// Get the event at the row selected and display it's title
    Employee *employee = [self.list objectAtIndex:indexPath.row];
    
	cell.textOne.text = employee._name;
    cell.textTwo.text = employee._id;
    
	return cell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactCell *cell = (ContactCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *contactId = cell.textTwo.text;
    [delegate showContact:contactId theName:cell.textOne.text];
    [delegateMail showContact:contactId theName:cell.textOne.text withButton:buttonId];
    [delegateContact showContact:contactId theName:cell.textOne.text];
    [self dismissModalViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
