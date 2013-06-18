//
//  ReturnMessageViewController.m
//  HZOAHD
//
//  Created by Gong Lingxiao on 12-9-16.
//  Copyright (c) 2012年 Changzhou Institute of Tech. All rights reserved.
//

#import "ReturnMessageViewController.h"

@interface ReturnMessageViewController ()

@end

@implementation ReturnMessageViewController
@synthesize editFlag;
@synthesize textValue;
@synthesize textView;
@synthesize calendarObj;

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
    self.view.backgroundColor = [UIColor colorWithRed:197.0/255.0 green:204.0/255.0 blue:210.0/255.0 alpha:1.0];
    
    
    if (editFlag) {
        textView.text = @"";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithBarButtonSystemItem:
                                                  UIBarButtonSystemItemDone target:self
                                                  action:@selector(doneClicked)];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked)];
        textView.editable = YES;
    } else {
        textView.text = textValue;
        textView.editable = NO;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelClicked)];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)cancelClicked {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)doneClicked {
    NSMutableDictionary *usernamepasswordKVPairs = (NSMutableDictionary *)[UserKeychain load:KEY_LOGINID_PASSWORD];
    [Calendar senderMessage:calendarObj withContext:textView.text withEmployee:[usernamepasswordKVPairs objectForKey:KEY_USERID]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"反馈成功" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self cancelClicked];
    } else {
        // TODO: DELETE
    }
}

@end
