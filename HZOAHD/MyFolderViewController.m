//
//  MyFolderViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-8.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "MyFolderViewController.h"
#import "SVWebViewController.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"

@interface MyFolderViewController ()

@end

@implementation MyFolderViewController

@synthesize folderList;
@synthesize filteredCandyArray;
@synthesize searchBar;

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

    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
//    UIBarButtonItem *refreshButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(syncData:forEvent:)];
//    self.navigationItem.leftBarButtonItem = refreshButtonItem;
    
    //NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    folderList = [MyFolder getAllCompany];
    
    filteredCandyArray = [NSMutableArray arrayWithCapacity:[folderList count]];
    [[self tableView] reloadData];
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

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"buttonIndex = %d", buttonIndex);
        //Cancel button pressed do nothing here
    } else {
        NSLog(@"buttonIndex = %d", buttonIndex);
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.dimBackground = YES;
        [HUD setDelegate:self];
        [HUD setLabelText:@"正在同步数据"];
        [HUD showWhileExecuting:@selector(synchronizeData) onTarget:self withObject:nil animated:YES];
    }
}

- (void)syncData:(id)sender forEvent:(UIEvent*)event {
    TSActionSheet *actionSheet = [[TSActionSheet alloc] initWithTitle:@"选择操作"];
    [actionSheet addButtonWithTitle:@"同步联系人" block:^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"同步联系人将花费一定时间，是否同步？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }];
    actionSheet.cornerRadius = 5;
    [actionSheet showWithTouch:event];
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
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        return [filteredCandyArray count];
    }
	else
	{
        return [folderList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MemberCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    MyFolder *folder = nil;
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        folder = [filteredCandyArray objectAtIndex:[indexPath row]];
    }
	else
	{
        folder = [folderList objectAtIndex:[indexPath row]];
    }
    
    cell.textLabel.text = folder.companyNameCN;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [self performSegueWithIdentifier:@"folderDetail" sender:tableView];
}

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{  
    MyFolder *folder = nil;
    // In order to manipulate the destination view controller, another check on which table (search or normal) is displayed is needed
    if(sender == self.searchDisplayController.searchResultsTableView) {
        NSIndexPath *indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        folder = [filteredCandyArray objectAtIndex:[indexPath row]];
    }
    else {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        folder = [folderList objectAtIndex:[indexPath row]];
    }
    FileViewController *fileViewController = [segue destinationViewController];
    fileViewController.memberId = folder.folderID;
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	// Update the filtered array based on the search text and scope.
	
    // Remove all objects from the filtered search array
	[self.filteredCandyArray removeAllObjects];
    
	// Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.companyNameCN contains[c] %@",searchText];
    NSArray *tempArray = [folderList filteredArrayUsingPredicate:predicate];
    
    filteredCandyArray = [NSMutableArray arrayWithArray:tempArray];
}


#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
    [self.tableView reloadData];
    
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{

    folderList = [MyFolder getAllCompany];
	[self.tableView reloadData];
	//  model should call this when its done loading
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}
@end
