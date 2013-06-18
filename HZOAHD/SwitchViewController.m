//
//  SwitchViewController.m
//  HZOAHD
//
//  Created by Li Feng on 13-2-4.
//  Copyright (c) 2013年 Changzhou Institute of Tech. All rights reserved.
//

#import "SwitchViewController.h"
#import "Employee.h"
#import "ChooseEmployeeViewController.h"
#import "ChooseMostViewController.h"

@implementation SwitchViewController

@synthesize chooseEmployeeViewController;
@synthesize chooseMostViewController;
@synthesize status;
@synthesize buttonId;
@synthesize delegateMail;
@synthesize delegateSwitchView;
@synthesize delegateNotice;
@synthesize delegateSelectContact;
@synthesize delegateFrequentContact;

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
    self.title = @"选择联系人";
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doCancel)];
    self.navigationItem.leftBarButtonItem=cancelButton;
    
    if (status!=1) {
        
        UIButton *buttonChange = [UIButton buttonWithType:UIButtonTypeCustom];
        // Since the buttons can be any width we use a thin image with a stretchable center point
        UIImage *buttonChangeImage = [[UIImage imageNamed:@"users"] stretchableImageWithLeftCapWidth:5  topCapHeight:0];
        UIImage *buttonChangePressedImage = [[UIImage imageNamed:@"users"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
        [buttonChange setBackgroundImage:buttonChangeImage forState:UIControlStateNormal];
        [buttonChange setBackgroundImage:buttonChangePressedImage forState:UIControlStateHighlighted];
        CGRect buttonChangeFrame = [buttonChange frame];
        buttonChangeFrame.size.width = buttonChangeImage.size.width;
        buttonChangeFrame.size.height = buttonChangeImage.size.height-15;
        [buttonChange setFrame:buttonChangeFrame];
        [buttonChange addTarget:self action:@selector(doChange) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *buttonChangeBar = [[UIBarButtonItem alloc] initWithCustomView:buttonChange];
        self.navigationItem.rightBarButtonItem = buttonChangeBar;

    }
    
     NSMutableArray *mostList = [Employee getAllMostContact];
    
    UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ChooseMostViewController *newChooseMostViewController = [storyborad instantiateViewControllerWithIdentifier:@"ChooseMostViewController"];
    //newChooseMostViewController
    newChooseMostViewController.delegateMail=self.delegateMail;
    newChooseMostViewController.delegateNotice=self.delegateNotice;
    newChooseMostViewController.delegateSelectContact=self.delegateSelectContact;
    newChooseMostViewController.delegateFrequentContact=self.delegateFrequentContact;
    newChooseMostViewController.delegateSwitchView=self;
    newChooseMostViewController.buttonId=self.buttonId;
    
    ChooseEmployeeViewController *newChooseEmployeeViewController = [storyborad instantiateViewControllerWithIdentifier:@"ChooseEmployeeViewController"];
    newChooseEmployeeViewController.delegateMail=self.delegateMail;
    newChooseEmployeeViewController.delegateNotice=self.delegateNotice;
    newChooseEmployeeViewController.delegateSelectContact=self.delegateSelectContact;
    newChooseEmployeeViewController.delegateFrequentContact=self.delegateFrequentContact;
    newChooseEmployeeViewController.delegateSwitchView=self;
    newChooseEmployeeViewController.buttonId=self.buttonId;
    
    self.chooseMostViewController=newChooseMostViewController;
    [chooseMostViewController.view setFrame:[self.view bounds]];
    self.chooseEmployeeViewController=newChooseEmployeeViewController;
    [chooseEmployeeViewController.view setFrame:[self.view bounds]];
    
    if ([mostList count]!=0 && status!=1) {
        [self.view insertSubview:chooseMostViewController.view atIndex:0];
    }else{
        [self.view insertSubview:chooseEmployeeViewController.view atIndex:0];
    }
}

- (void)doChange{
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.50];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    //UIStoryboard *storyborad = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    if (self.chooseMostViewController.view.superview == nil) {
//        if (self.frequentContactViewController == nil) {
//            FrequentContactViewController *newfrequentContactViewController = [storyborad instantiateViewControllerWithIdentifier:@"FrequentContactViewController"];
//            self.frequentContactViewController = newfrequentContactViewController;
//        }
        [chooseMostViewController.view setFrame:[self.view bounds]];
        self.title = @"常用联系人";
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        [chooseEmployeeViewController viewWillAppear:YES];
        [chooseMostViewController viewWillDisappear:YES];
        
        [chooseEmployeeViewController.view removeFromSuperview];
        [self.view insertSubview:chooseMostViewController.view atIndex:0];
        [chooseMostViewController viewDidDisappear:YES];
        [chooseEmployeeViewController viewDidAppear:YES];
    } else {
//        if (self.chooseEmployeeViewController == nil) {
//            ChooseEmployeeViewController *newChooseEmployeeViewController = [storyborad instantiateViewControllerWithIdentifier:@"ChooseEmployeeViewController"];
//            self.chooseEmployeeViewController = newChooseEmployeeViewController;
//        }
        [chooseEmployeeViewController.view setFrame:[self.view bounds]];
        self.title = @"选择联系人";
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        [chooseMostViewController viewWillAppear:YES];
        [chooseEmployeeViewController viewWillDisappear:YES];
        
        [chooseMostViewController.view removeFromSuperview];
        [self.view insertSubview:chooseEmployeeViewController.view atIndex:0];
        [chooseEmployeeViewController viewDidDisappear:YES];
        [chooseMostViewController viewDidAppear:YES];
    }
    [UIView commitAnimations];
}

- (void)doCancel{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)dismissViewController {
    
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
