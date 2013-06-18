//
//  MailDetailViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-8-7.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "MailDetailViewController.h"
#import "SVWebViewController.h"
#import "UserKeychain.h"
#import "AddMailViewController.h"
#import "PopViewController.h"

NSString *str0;

@interface MailDetailViewController ()

@end

@implementation MailDetailViewController
@synthesize senderLabel;
@synthesize receiveLabel;
@synthesize dateTime;
@synthesize context;
@synthesize mail;
@synthesize mailType;
@synthesize titleLabel;
@synthesize button;
@synthesize buttonName;
@synthesize moreButton;
@synthesize arrayFileIds;
@synthesize arrayFileNames;
@synthesize ccLabel;
@synthesize frontFlag;

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
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    PopViewController *popViewController = [storyborad instantiateViewControllerWithIdentifier:@"PopViewController"];
    popViewController.mail = mail;
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:popViewController];
    navigationController.contentSizeForViewInPopover = CGSizeMake(100, 100);
    popover = [[UIPopoverController alloc]initWithContentViewController:navigationController];
    popover.delegate = self;
    popover.popoverContentSize = CGSizeMake(160, 210);
    
	// Do any additional setup after loading the view.
    //NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    self.moreButton.hidden = YES;
    self.titleLabel.text = mail.title;
    self.senderLabel.text = mail.senderName;
    self.dateTime.text = mail.date;
    self.ccLabel.text = mail.ccListName;
    [context loadHTMLString:mail.context baseURL:nil];
    self.receiveLabel.text = mail.reciverName;
    if ([frontFlag isEqualToString:@""] || frontFlag == nil) {        
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithBarButtonSystemItem:
                                                 UIBarButtonSystemItemCancel target:self
                                                 action:@selector(cancelClick:)];
    }
    
    if ([mail.fileId isEqualToString:@""]) {
       
    } else {
        NSString *fileIds = mail.fileId;
        if ([fileIds rangeOfString:@","].length > 0) {
            arrayFileIds = [mail.fileId componentsSeparatedByString:@","];
            arrayFileNames = [mail.fileName componentsSeparatedByString:@","];
            if ([arrayFileIds count] < 4) {
                for (int i = 0; i < [arrayFileIds count]; i ++) {
                    NSString *fileId = [arrayFileIds objectAtIndex:i];
                    NSString *fileName = [arrayFileNames objectAtIndex:i];
                    button = [[UIButton alloc]initWithFrame:CGRectMake(85 + i * 215,225,40,40)];
                    [button setTitle:fileId forState:UIControlStateNormal];
                    button.property = fileId;
                    NSString *imageName = [self returnUIImageNameForAttachment:fileName];
                    NSLog(@"fileName === %@", fileName);
                    UIImage *image = [UIImage imageNamed:imageName];
                    [button setImage:image forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(launchSafari:) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:button];
                
                    CGRect frameBtn = CGRectMake(126 + i * 215,225,170,37);
                    buttonName = [UIButton buttonWithType:UIButtonTypeCustom];
                    buttonName.frame = frameBtn;
                    buttonName.property = fileId;
                    [buttonName setTitle:fileName forState:UIControlStateNormal];
                    [buttonName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    buttonName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    [buttonName addTarget:self action:@selector(launchSafari:) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:buttonName];
                } 
//                else {
//                    self.moreButton.hidden = NO;
//                    [moreButton addTarget:self action:@selector(openSheetPop:forEvent:) forControlEvents:UIControlEventTouchUpInside];
//                }
            }
            else {
                for (int i = 0; i < 4; i ++) {   
                    NSString *fileId = [arrayFileIds objectAtIndex:i];
                    NSString *fileName = [arrayFileNames objectAtIndex:i];
                    button = [[UIButton alloc]initWithFrame:CGRectMake(85 + i * 215,225,40,40)];
                    [button setTitle:fileId forState:UIControlStateNormal];
                    button.property = fileId;
                    NSString *imageName = [self returnUIImageNameForAttachment:fileName];
                    UIImage *image = [UIImage imageNamed:imageName];
                    [button setImage:image forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(launchSafari:) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:button];
                    
                    CGRect frameBtn = CGRectMake(126 + i * 215,225,170,37);
                    buttonName = [UIButton buttonWithType:UIButtonTypeCustom];
                    buttonName.frame = frameBtn;
                    buttonName.property = fileId;
                    [buttonName setTitle:fileName forState:UIControlStateNormal];
                    [buttonName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    buttonName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    [buttonName addTarget:self action:@selector(launchSafari:) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:buttonName];
                } 
                self.moreButton.hidden = NO;
                [moreButton addTarget:self action:@selector(openSheetPop:forEvent:) forControlEvents:UIControlEventTouchUpInside];
            }
        } else {
            button = [[UIButton alloc]initWithFrame:CGRectMake(85,225,40,40)];
            NSString *imageName = [self returnUIImageNameForAttachment:mail.fileName];
            [button setTitle:mail.fileId forState:UIControlStateNormal];
            button.property = mail.fileId;
            UIImage *image = [UIImage imageNamed:imageName];
            [button setImage:image forState:UIControlStateNormal];
            [button addTarget:self action:@selector(launchSafari:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:button];

            CGRect frameBtn = CGRectMake(126,225,170,37);
            buttonName = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonName.frame = frameBtn;
            buttonName.property = mail.fileId;
            [buttonName setTitle:mail.fileName forState:UIControlStateNormal];
            [buttonName setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            buttonName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [buttonName addTarget:self action:@selector(launchSafari:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:buttonName];
        }
        
    }
    [context setBackgroundColor:[UIColor clearColor]];
    [self hideGradientBackground:context];
    NSLog(@"%@", mailType);
}

- (void) hideGradientBackground:(UIView*)theView
{
    for (UIView * subview in theView.subviews)
    {
        if ([subview isKindOfClass:[UIImageView class]])
            subview.hidden = YES;
        
        [self hideGradientBackground:subview];
    }
}

- (IBAction)showPop:(id)sender forEvent:(UIEvent*)event {
    CGRect popoverRect = CGRectMake(1000, 0, 0, 0);
    [popover presentPopoverFromRect:popoverRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
//    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    TSActionSheet *actionSheet = [[TSActionSheet alloc] initWithTitle:@"选择操作"];
//    [actionSheet addButtonWithTitle:@"回复" block:^{
//        AddMailViewController *addMailViewController = [storyborad instantiateViewControllerWithIdentifier:@"AddMailViewController"];
//        addMailViewController.mail = mail;
//        addMailViewController.mailType = kMailTypeReplyMail;
//        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:addMailViewController];
//        [self.navigationController presentModalViewController:naviController animated:YES];
//    }];
//    [actionSheet addButtonWithTitle:@"转发" block:^{
//        AddMailViewController *addMailViewController = [storyborad instantiateViewControllerWithIdentifier:@"AddMailViewController"];
//        addMailViewController.mail = mail;
//        addMailViewController.mailType = kMailTypeForwardMail;
//        UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:addMailViewController];
//        [self.navigationController presentModalViewController:naviController animated:YES];
//    }];
//    actionSheet.cornerRadius = 5;
//    [actionSheet showWithTouch:event];
}

- (void)cancelClick:(id) sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)openSheetPop:(id)sender forEvent:(UIEvent*)event {
    TSActionSheet *actionSheet = [[TSActionSheet alloc] initWithTitle:@"邮件附件"];
     for (int i = 4; i < [arrayFileIds count]; i ++) {
         NSString *fileId = [arrayFileIds objectAtIndex:i];
         NSString *fileName = [arrayFileNames objectAtIndex:i];
         [actionSheet addButtonWithTitle:fileName block:^{
             NSString *strUrl = [FILE_ADDRESS stringByAppendingString:fileId];
             NSLog(@"strUrl ======= %@", strUrl);
             NSURL *URL = [NSURL URLWithString:strUrl];
             SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
             webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
             webViewController.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsCopyLink | SVWebViewControllerAvailableActionsMailLink;
             [self presentModalViewController:webViewController animated:YES];
         }];
     }
    actionSheet.cornerRadius = 5;      
    [actionSheet showWithTouch:event];
}
    
- (NSString *)returnUIImageNameForAttachment:(NSString *) fileName {
    int pos = 0;
    NSRange range = [fileName rangeOfString:@"." options:NSBackwardsSearch];
    NSString *retString = @"";
    if ( range.length > 0 ) {
        pos = range.location;
        NSString *substring = [[fileName substringFromIndex:range.location + 1] lowercaseString];
        if ([substring isEqualToString:@"doc"] || [substring isEqualToString:@"docx"]) {
            retString = @"microsoft_office_word.png";
        } 
        else if ([substring isEqualToString:@"xls"] || [substring isEqualToString:@"xlsx"]) {
            retString = @"microsoft_office_excel.png";
        }
        else if ([substring isEqualToString:@"ppt"] || [substring isEqualToString:@"pptx"]) {
            retString = @"microsoft_office_powerpoint.png";
        }
        else if ([substring isEqualToString:@"pdf"]) {
            retString = @"microsoft_office_picture_manager.png";
        }
        else {
            retString = @"microsoft_office_outlook.png";
        }
    } else {
        retString = @"microsoft_office_outlook.png";
    }
    return retString;
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

-(void)takeMailType:(NSString *)type {
    NSLog(@"%@", type);
}

- (IBAction)launchSafari:(id)sender {
    NSString *strUrl;
    UIButton *buttonT = (UIButton *) sender;
    strUrl = [FILE_ADDRESS stringByAppendingString:buttonT.property];
    NSLog(@"strUrl ======= %@", strUrl);
    NSURL *URL = [NSURL URLWithString:strUrl];
	SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
	webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    webViewController.availableActions = SVWebViewControllerAvailableActionsOpenInSafari | SVWebViewControllerAvailableActionsCopyLink | SVWebViewControllerAvailableActionsMailLink;
	[self presentModalViewController:webViewController animated:YES];
}

@end
