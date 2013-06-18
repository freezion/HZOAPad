//
//  MailListViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-7.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "MailListViewController.h"
#import "AddMailViewController.h"
#import "MailDetailViewController.h"
#import "Mail.h"
#import "MailCell.h"

@interface MailListViewController ()

@end

@implementation MailListViewController

@synthesize mailList;

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

    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                      UIBarButtonSystemItemAdd target:self action:@selector(addMail:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    mailList = [Mail getLocalReciveEmail:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.mailList = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark -
#pragma mark Add a new mail

- (void)addMail:(id)sender {
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AddMailViewController *addViewController = [storyborad instantiateViewControllerWithIdentifier:@"AddMailViewController"];
    UINavigationController *tmpNavController = [[UINavigationController alloc] initWithRootViewController:addViewController];
    [self.navigationController presentModalViewController:tmpNavController animated:YES];
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
    return mailList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MailCell";
    MailCell *cell = (MailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Mail *mail = [self.mailList objectAtIndex:indexPath.row];
	cell.titleLabel.text = mail.title;
	cell.detailLabel.text = mail.cleanHtml;
	cell.dateLabel.text = mail.date;
    cell.senderLabel.text = mail.senderName;
    if ([mail.readed isEqualToString:@"0"]) {
        cell.readImageView.image = [UIImage imageNamed:@"New-32.png"];
    } else {
        cell.readImageView.image = [UIImage imageNamed:@""];
    }
    if ([mail.fileId isEqualToString:@""]) {
        [cell.attachmentImageView setImage:[UIImage imageNamed:@""]];
    } else {
        [cell.attachmentImageView setImage:[UIImage imageNamed:@"attachment"]];
    } 
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
        Mail *mail = (Mail *)[self.mailList objectAtIndex:indexPath.row];
        NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
        [Mail deleteReceiveEmailById:mail.ID withEmployeeId:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
		[self.mailList removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}   
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    MailDetailViewController *viewController = [segue destinationViewController];
    Mail *mail = [mailList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    NSLog(@"%@",mail.ccList);
    viewController.mail = mail;
    viewController.mailType = @"receive";
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    if ([mail.readed isEqualToString:@"0"]) {

        [Mail readedMail:mail.ID withEmployeeId:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
        mailList = [Mail getLocalReciveEmail:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
        
        [self.tableView reloadData];
    }
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
	NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    [Mail synchronizeEmail:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    mailList = [Mail getLocalReciveEmail:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
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
