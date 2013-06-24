//
//  NoticeDetailViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-6.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "NoticeDetailViewController.h"
#import "SVModalWebViewController.h"

@interface NoticeDetailViewController ()

@end

@implementation NoticeDetailViewController
@synthesize scrollView;
@synthesize noticeTitle;
@synthesize sender;
@synthesize dateTime;
@synthesize context;
@synthesize noticeType;
@synthesize notice;
@synthesize attchmentButton;
@synthesize frontFlag;
@synthesize fileId;
@synthesize arrayFileIds;
@synthesize arrayFileNames;

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
    if ([frontFlag isEqualToString:@""] || frontFlag == nil) {        
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithBarButtonSystemItem:
                                                 UIBarButtonSystemItemCancel target:self
                                                 action:@selector(cancelClick:)];
    }
    self.noticeTitle.text = notice.title;
    self.sender.text = notice.sender;
    self.dateTime.text = notice.date;
    self.noticeType.text = notice.typeName;
    NSString *contextStr = notice.context;
    self.context.text = contextStr;
    self.context.editable = NO;
    
    if ([notice.fileId isEqualToString:@""] || notice.fileId == nil) {
        attchmentButton.hidden = YES;
    } else {
        attchmentButton.hidden = NO;
        NSString *fileIds = notice.fileId;
        if ([fileIds rangeOfString:@","].length > 0) {
            arrayFileIds = [notice.fileId componentsSeparatedByString:@","];
            arrayFileNames = [notice.fileName componentsSeparatedByString:@","];
        }
    }
    
    
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

- (void)cancelClick:(id) sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)launchSafari:(id)sender {
    NSString *strUrl;
    strUrl = [[NSUtil chooseFileRealm] stringByAppendingString:self.fileId];
    NSLog(@"strUrl ======= %@", strUrl);
    NSURL *URL = [NSURL URLWithString:strUrl];
	SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
	webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    webViewController.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsCopyLink | SVWebViewControllerAvailableActionsMailLink;
	[self presentModalViewController:webViewController animated:YES];
}

- (IBAction)showAttchments:(id)sender{
    SBTableAlert *alertView;
    alertView=[[SBTableAlert alloc] initWithTitle:@"附件查看" cancelButtonTitle:@"取消" messageFormat:nil];

    
    [alertView setDelegate:self];
	[alertView setDataSource:self];
    
    [alertView show];

	//[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell;
    
    for (int i = 0; i < [arrayFileIds count]; i ++) {
        //NSString *fileId = [arrayFileIds objectAtIndex:i];
        NSString *fileName = [arrayFileNames objectAtIndex:i];
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell.textLabel setText:fileName];
    }
	return cell;
}
- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section {
	return [arrayFileIds count];
		
}
- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"%d",indexPath.row);
    self.fileId = [arrayFileIds objectAtIndex:indexPath.row];
    
    NSString *strUrl;
    strUrl = [[NSUtil chooseFileRealm] stringByAppendingString:self.fileId];
    NSLog(@"strUrl ======= %@", strUrl);
    NSURL *URL = [NSURL URLWithString:strUrl];
	SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
	webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    webViewController.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsCopyLink | SVWebViewControllerAvailableActionsMailLink;
	[self presentModalViewController:webViewController animated:YES];
}
- (void)tableAlert:(SBTableAlert *)tableAlert didDismissWithButtonIndex:(NSInteger)buttonIndex {
	
}

@end
