//
//  NoticeViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-2.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "NoticeViewController.h"
#import "SystemConfig.h"

@interface NoticeViewController ()

@end

@implementation NoticeViewController

@synthesize noticeList;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:
    UIBarButtonSystemItemAdd target:self action:@selector(addNotice:)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    
    //UIBarButtonItem *refreshButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(syncData:forEvent:)];
    //self.navigationItem.leftBarButtonItem = refreshButtonItem;
    
//    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"界面底图.jpg"]];
//    [tempImageView setFrame:self.tableView.frame]; 
//    
//    self.tableView.backgroundView = tempImageView;
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    //noticeList = [Notice getLocalNotice:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    noticeList = [Notice synchronizeNotice:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    //[self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    //noticeList = [Notice getLocalNotice:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    noticeList = [Notice synchronizeNotice:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.noticeList = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark -
#pragma mark Add a new notice

- (void)addNotice:(id)sender {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    NSMutableArray *systemConfigs = [SystemConfig getNoticeType:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
   // NSLog(@"%d",[systemConfigs count]);
    if ([systemConfigs count] > 0) {
        UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        AddNoticeViewController *addViewController = [storyborad instantiateViewControllerWithIdentifier:@"AddNoticeViewController"];
        addViewController.values=systemConfigs;
        UINavigationController *tmpNavController = [[UINavigationController alloc] initWithRootViewController:addViewController];
        [self.navigationController presentModalViewController:tmpNavController animated:YES];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"不能发送公告" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        [alert show];
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

- (void) synchronizeData {
    sleep(1);
    [Employee synchronizeEmployee];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"同步完成";
	sleep(1);
}

#pragma mark - Table view data source

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [cell setBackgroundColor:[UIColor colorWithRed:.8 green:.8 blue:1 alpha:1]];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.noticeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NoticeCell *cell = (NoticeCell *)[tableView dequeueReusableCellWithIdentifier:@"NoticeCell"];
    
	Notice *notice = [self.noticeList objectAtIndex:indexPath.row];
	cell.nameLabel.text = notice.title;
	cell.detailLabel.text = notice.context;
	cell.dateLabel.text = notice.date;
    cell.senderLabel.text = notice.sender;
    cell.typeLabel.text = notice.typeName;
    
    if ([notice.readed isEqualToString:@"0"]) {
        cell.readImageView.image = [UIImage imageNamed:@"New-32.png"];
    } else {
        cell.readImageView.image = [UIImage imageNamed:@""];
    }
    if ([notice.fileId isEqualToString:@""] || notice.fileId == nil) {
        cell.attachmentImageView.image = [UIImage imageNamed:@""];
    } else {
        cell.attachmentImageView.image = [UIImage imageNamed:@"attachment.png"];
    }
    return cell;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	if (editingStyle == UITableViewCellEditingStyleDelete)
//	{
//		[self.noticeList removeObjectAtIndex:indexPath.row];
//		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//	}   
//}

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];

    NoticeDetailViewController *noticeDetailViewController = [segue destinationViewController];
    Notice *notice = [noticeList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    noticeDetailViewController.notice = notice;
  
    if ([notice.readed isEqualToString:@"0"]) {
        [Notice readedNotice:notice.ID withEmployeeId:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
        noticeList = [Notice getLocalNotice:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)doneLoadingTableViewData {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    noticeList = [Notice synchronizeNotice:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    
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
