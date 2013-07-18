//
//  TmpMailViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-18.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "TmpMailViewController.h"
#import "AddMailViewController.h"
#import "MailDetailViewController.h"

@interface TmpMailViewController ()

@end

@implementation TmpMailViewController

@synthesize mailList;
@synthesize editFlag;
@synthesize deleteList;

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
    
    UIBarButtonItem *trashButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
                                        UIBarButtonSystemItemTrash target:self action:@selector(editMode)];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 40.0f)];
    //[toolbar setBarStyle:UIBarStyleDefault];
    [toolbar setTranslucent:YES];
    NSArray* buttons = [NSArray arrayWithObjects:trashButtonItem, addButtonItem, nil];
    [toolbar setItems:buttons animated:NO];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    mailList = [Mail getTmpMail:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    //NSLog(@"mailList == %@", mailList);
}

-(void)refreshTableView {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    [Mail synchronizeEmail:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    mailList = [Mail getTmpMail:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
	[self.tableView reloadData];
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

- (void) editMode {
    if (editFlag) {
        NSMutableArray *deleteMail = [[NSMutableArray alloc] init];
        deleteList = @"";
        for (int i = 0; i < [mailList count]; i ++) {
            Mail *mail = [mailList objectAtIndex:i];
            if (mail.isChecked) {
                [deleteMail addObject:mail];
            }
        }
        
        for (int i = 0; i < [deleteMail count]; i ++) {
            Mail *mail = [deleteMail objectAtIndex:i];
            deleteList = [deleteList stringByAppendingFormat:@"%@", mail.ID];
            if (i != [deleteMail count] - 1) {
                deleteList = [deleteList stringByAppendingString:@","];
            }
        }
        
        if (![deleteList isEqualToString:@""]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认要删除这些邮件吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alert.tag = 0;
            [alert show];
        } else {
            editFlag = NO;
            [self.tableView reloadData];
        }
    } else {
        editFlag = YES;
        [self.tableView reloadData];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        editFlag = NO;
        [self refreshTableView];
    } else {
        editFlag = NO;
        if (alertView.tag == 0) {
            NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
            [Mail deleteReceiveEmailById:deleteList withEmployeeId:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
            [self refreshTableView];
        }
    }
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
	cell.detailLabel.text = mail.context;
	cell.dateLabel.text = mail.date;
    cell.senderLabel.text = mail.senderName;
    cell.importLabel.text = mail.importName;
    cell.readImageView.image = [UIImage imageNamed:@""];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    if ([mail.fileId isEqualToString:@""]) {
        [cell.attachmentImageView setImage:[UIImage imageNamed:@""]];
    } else {
        [cell.attachmentImageView setImage:[UIImage imageNamed:@"attachment"]];
    }
    
    if (editFlag) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (mail.isChecked) {
            cell.readImageView.image = [UIImage imageNamed:@"Selected1.png"];
        } else {
            
            cell.readImageView.image = [UIImage imageNamed:@"Unselected1.png"];
        }
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
    Mail *mail = [mailList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    MailCell *cell = (MailCell *)[tableView cellForRowAtIndexPath:indexPath];
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AddMailViewController *viewController = [storyborad instantiateViewControllerWithIdentifier:@"AddMailViewController"];
    viewController.mailType = kMailTypeTmpMail;
    viewController.mail = mail;
    
    if (editFlag) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (mail.isChecked) {
            cell.readImageView.image = [UIImage imageNamed:@"Unselected.png"];
            mail.isChecked = NO;
        } else {
            cell.readImageView.image = [UIImage imageNamed:@"Selected.png"];
            mail.isChecked = YES;
        }
        
    } else {
        [self.navigationController pushViewController:viewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    mailList = [Mail getTmpMail:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
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
