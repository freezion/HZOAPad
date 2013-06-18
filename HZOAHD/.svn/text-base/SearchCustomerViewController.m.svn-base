//
//  SearchCustomerViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-10-24.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "SearchCustomerViewController.h"
#import "Customer.h"

@interface SearchCustomerViewController ()

@end

@implementation SearchCustomerViewController

@synthesize customerList;
@synthesize contractSelectedIndex;
@synthesize customerSelectedIndex;
@synthesize contractIdLocal;
@synthesize startDateLocal;
@synthesize endDateLocal;
@synthesize customerIdLocal;
@synthesize contractName;
@synthesize customerNameLocal;
@synthesize nameList;
@synthesize searchBar;
@synthesize delegate;

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
	// Do any additional setup after loading the view.
    //[searchBar setShowsScopeBar:NO];
    //[searchBar sizeToFit];
    
    CGRect newBounds = [[self tableView] bounds];
    newBounds.origin.y = newBounds.origin.y + searchBar.bounds.size.height;
    [[self tableView] setBounds:newBounds];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
    customerList = [Customer getAllCustomer];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    
    Customer *customer = nil;
    //if ([segue.identifier isEqualToString:@"ContractPick"])
	//{
		if(sender == self.searchDisplayController.searchResultsTableView) {
            customer = [searchResults objectAtIndex:[self.searchDisplayController.searchResultsTableView indexPathForSelectedRow].row];
        }
        else {
            customer = [self.customerList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        }
        ChooseContractViewController *chooseContractViewController = segue.destinationViewController;
        chooseContractViewController.delegate = self;
        chooseContractViewController.customerId = customer.customerId;
        chooseContractViewController.customerName = customer.name;
        chooseContractViewController.customerSelectedIndex = [self.tableView indexPathForSelectedRow].row;
        chooseContractViewController.selectedIndex = contractSelectedIndex;
        
        
    //}
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
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [customerList count];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Customer *customer = [[Customer alloc] init];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        customer = [searchResults objectAtIndex:indexPath.row];
    } else {
        customer = [customerList objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = customer.name;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [self performSegueWithIdentifier:@"candyDetail" sender:tableView];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate 
                                    predicateWithFormat:@"SELF.name contains[cd] %@",
                                    searchText];
    
    searchResults = [customerList filteredArrayUsingPredicate:resultPredicate];
    [self.tableView reloadData];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString 
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    [self.tableView reloadData];
    return YES;
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

-(void)backAction:(id) sender {
    [delegate searchCustomerViewController:self didSelectContract:contractIdLocal withSelectIndex:contractSelectedIndex withCustomerSelectIndex:customerSelectedIndex withLabelTitle:contractName withStartDate:startDateLocal withEndDate:endDateLocal withCustomerId:customerIdLocal withCustomerName:customerNameLocal];
}

@end
