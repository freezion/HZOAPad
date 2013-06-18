//
//  PopViewController.m
//  HZOAHD
//
//  Created by 潘 群 on 12-11-29.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "PopViewController.h"
#import "AddMailViewController.h"

@interface PopViewController ()

@end

@implementation PopViewController

@synthesize replyButton;
@synthesize forwardButton;
@synthesize replyAllButton;
@synthesize mail;

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
    [replyButton useWhiteLabel: YES];
    replyButton.tintColor = [UIColor darkGrayColor];
	[replyButton setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
    
    [forwardButton useWhiteLabel: YES];
    forwardButton.tintColor = [UIColor darkGrayColor];
	[forwardButton setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
    
    [replyAllButton useWhiteLabel: YES];
    replyAllButton.tintColor = [UIColor darkGrayColor];
	[replyAllButton setShadow:[UIColor blackColor] opacity:0.8 offset:CGSizeMake(0, 1) blurRadius: 4];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showReplyEmailView:(id)sender {
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AddMailViewController *addMailViewController = [storyborad instantiateViewControllerWithIdentifier:@"AddMailViewController"];
    addMailViewController.mail = mail;
    addMailViewController.mailType = kMailTypeReplyMail;
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:addMailViewController];
    [self.navigationController presentModalViewController:naviController animated:YES];
}

- (IBAction)showReplyAllEmailView:(id)sender{
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AddMailViewController *addMailViewController = [storyborad instantiateViewControllerWithIdentifier:@"AddMailViewController"];
    addMailViewController.mail = mail;
    addMailViewController.mailType = kMailTypeReplyAllMail;
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:addMailViewController];
    [self.navigationController presentModalViewController:naviController animated:YES];
}

- (IBAction)showForwardEmailView:(id)sender {
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    AddMailViewController *addMailViewController = [storyborad instantiateViewControllerWithIdentifier:@"AddMailViewController"];
    addMailViewController.mail = mail;
    addMailViewController.mailType = kMailTypeForwardMail;
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:addMailViewController];
    [self.navigationController presentModalViewController:naviController animated:YES];
}

@end
