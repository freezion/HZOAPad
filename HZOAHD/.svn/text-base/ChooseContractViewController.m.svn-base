//
//  ChooseContractViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-15.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "ChooseContractViewController.h"

@interface ChooseContractViewController ()

@end

@implementation ChooseContractViewController

@synthesize delegate;
@synthesize customerSelectedIndex;
@synthesize customerId;
@synthesize contractList;
@synthesize selectedIndex;
@synthesize customerName;

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
    
    
    contractList = [Contract getContractIdByCustomer:customerId];
    if ([contractList count] == 0) {
        
    } else {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
    }
    
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

- (void) backAction:(id) sender {
    Contract *contract = [self.contractList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    Contract *contractDate = [Contract getContractInfoByContractId:contract.contractId];
    [delegate chooseContractViewController:self didSelectContract:contract.contractId withSelectIndex:[self.tableView indexPathForSelectedRow].row withCustomerSelectIndex:customerSelectedIndex withLabelTitle:contract.compactNum withStartDate:contractDate.startDate withEndDate:contractDate.endDate withCustomerId:customerId withCustomerName:customerName];
    
    
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
    return [contractList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContractCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Contract *contract = [self.contractList objectAtIndex:indexPath.row];
    cell.textLabel.text = contract.compactNum;
    if (indexPath.row == selectedIndex)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return cell;
}

#pragma mark - Table view delegate

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
}

@end
