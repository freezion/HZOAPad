//
//  EventTypeViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-14.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "EventTypeViewController.h"

@interface EventTypeViewController ()

@end

@implementation EventTypeViewController

@synthesize selectedIndex;
@synthesize delegate;
@synthesize typeId;
@synthesize typeName;
@synthesize didSelectSystemConfig;
@synthesize values;
@synthesize typeLabelTxt;


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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
    
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    NSMutableArray *systemConfigs = [SystemConfig loadSystemConfigById:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    self.values = systemConfigs;
    //    if (selectedIndex == 0) {
    //        cellNormal.accessoryType = UITableViewCellAccessoryCheckmark;
    //    } else if (selectedIndex == 1) {
    //        cellVisiting.accessoryType = UITableViewCellAccessoryCheckmark;
    //    } else if (selectedIndex == 2) {
    //        cellHoliday.accessoryType = UITableViewCellAccessoryCheckmark;
    //    } else if (selectedIndex == 3) {
    //        cellMeeting.accessoryType = UITableViewCellAccessoryCheckmark;
    //    }
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

- (void)backAction:(id) sender {
    [delegate eventTypeViewController:self didSelectType:typeId withSelectIndex:selectedIndex withLabelTitle:typeName withOriginType:typeLabelTxt];
}

#pragma mark - Table view delegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [values count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:@"CalendarTypeCell"];
    SystemConfig *systemConfig = [values objectAtIndex:indexPath.row];
    cell.textLabel.text=systemConfig.name;
    if (indexPath.row == selectedIndex)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectedIndex != NSNotFound)
	{
		UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
    
    selectedIndex = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	cell.accessoryType = UITableViewCellAccessoryCheckmark;
    didSelectSystemConfig = [values objectAtIndex:selectedIndex];
    //typeId = [NSString stringWithFormat:@"%d", cell.tag];
    typeId = didSelectSystemConfig.typeId;
    NSLog(@"%@",typeId);
    typeName = cell.textLabel.text;
    
}

@end
