//
//  ChooseCustomerViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-15.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "ChooseCustomerViewController.h"

@interface ChooseCustomerViewController ()

@end

@implementation ChooseCustomerViewController
@synthesize customerList;
@synthesize contractSelectedIndex;
@synthesize delegate;
@synthesize customerSelectedIndex;
@synthesize contractIdLocal;
@synthesize startDateLocal;
@synthesize endDateLocal;
@synthesize customerIdLocal;
@synthesize contractName;
@synthesize customerNameLocal;

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
    customerList = [Customer getAllCustomer];
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
    Customer *customer = [self.customerList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    
    if ([segue.identifier isEqualToString:@"ContractPick"])
	{
		ChooseContractViewController *chooseContractViewController = segue.destinationViewController;
        chooseContractViewController.delegate = self;
        chooseContractViewController.customerId = customer.customerId;
        chooseContractViewController.customerName = customer.name;
        chooseContractViewController.customerSelectedIndex = [self.tableView indexPathForSelectedRow].row;
        chooseContractViewController.selectedIndex = contractSelectedIndex;
    }
}

-(void)backAction:(id) sender {
    [delegate chooseCustomerViewController:self didSelectContract:contractIdLocal withSelectIndex:contractSelectedIndex withCustomerSelectIndex:customerSelectedIndex withLabelTitle:contractName withStartDate:startDateLocal withEndDate:endDateLocal withCustomerId:customerIdLocal withCustomerName:customerNameLocal];
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
    return [customerList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    Customer *customer = [self.customerList objectAtIndex:indexPath.row];
    cell.textLabel.text = customer.name;
    
    return cell;
}

#pragma mark - ChooseContractDelegate
- (void)chooseContractViewController:(ChooseContractViewController *)controller didSelectContract:(NSString *) contractId withSelectIndex:(int) selectedIndex withCustomerSelectIndex:(int) customerSelectIndex withLabelTitle:(NSString *) title withStartDate:(NSString *)startDate withEndDate:(NSString *)endDate withCustomerId:(NSString *)customerId withCustomerName:(NSString *)customerName {
    self.contractIdLocal = contractId;
    contractSelectedIndex = selectedIndex;
    contractName = title;
    startDateLocal = startDate;
    endDateLocal = endDate;
    customerIdLocal = customerId;
    customerNameLocal = customerName;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
